# standard packages
import warnings
import os 
import time
import pickle
import json
import logging
from argparse import ArgumentParser, Namespace

# custom modules
from asp import params
from modules.utils import asp2railenv
from modules.api_enriched import FlatlandPlan, FlatlandReplan, IncrementalFlatlandPlan
from modules.convert_enriched import convert_malfunctions_to_clingo, convert_formers_to_clingo, convert_futures_to_clingo

from html_viz import grid_json, train_info, LandscapeBuilder, generate_html, build_car_dict, get_additional_info

from flatland.envs.rail_env_action import RailEnvActions

logger = logging.getLogger("TRAIN_PATHS")
logger.setLevel(logging.INFO)

handler = logging.FileHandler("solve.log", mode="w")
formatter = logging.Formatter("%(levelname)s -- %(name)s: %(message)s")
handler.setFormatter(formatter)

logger.addHandler(handler)
logger.propagate = False

# clingo
import clingo
from clingo.application import Application, clingo_main

# rendering visualizations
from flatland.utils.rendertools import RenderTool
import imageio.v2 as imageio
from PIL import Image, ImageDraw, ImageFont


class MalfunctionManager():
    def __init__(self, num_agents):
        self.num_agents = num_agents
        self.malfunctions = []

    def get(self) -> list:
        """ get the list of malfunctions """
        return(self.malfunctions)

    def deduct(self) -> None:
        """ decrease the duration of each malfunction by one and delete expired malfunctions """
        malfunctions_to_remove = []
        for i, malf in enumerate(self.malfunctions):
            self.malfunctions[i] = (self.malfunctions[i][0], self.malfunctions[i][1] - 1)
            if self.malfunctions[i][1] == 0:
                malfunctions_to_remove.append(i)
        
        # delete expired malfunctions
        for i in sorted(malfunctions_to_remove, reverse=True):
            del self.malfunctions[i]

    def check(self, info) -> set:
        """ check current state of the env for new malfunctions """
        malfunctioning_info = info['malfunction']
        malfunctioning_trains = {train for train, duration in malfunctioning_info.items() if duration > 0}
        existing = {malf[0] for malf in self.malfunctions}
        new = malfunctioning_trains.difference(existing)

        # add new ones to malfunctions
        for train in new:
            self.malfunctions.append((train, malfunctioning_info[train]))

        return(new)
    
class IncrementalSimulationManager():
    def __init__(self, env, primary, secondary=None, instance_lp=None):
        self.env = env
        self.primary = primary
        self.secondary = secondary if secondary is not None else primary
        self.instance_lp = instance_lp
        self.model = None
        self.stats = None

    def build_actions(self) -> list:
        """ create initial list of actions """
        # pass env, primary
        app = IncrementalFlatlandPlan(self.env, None, instance_lp=self.instance_lp)
        clingo_main(app, self.primary)
        self.stats = app.stats
        self.model = app.model
        return(app.action_list)

    def provide_context(self, actions, timestep, malfunctions) -> str:
        """ provide additional facts when updating list """
        # actions that have already been executed
        # wait actions that are enforced because of malfunctions
        # future actions that were previously planned
        past = convert_formers_to_clingo(actions[:timestep])
        present = convert_malfunctions_to_clingo(malfunctions, timestep)
        future = convert_futures_to_clingo(actions[timestep:])
        return(past + present + future)

    def update_actions(self, context) -> list:
        """ update list of actions following malfunction """
        # pass env, secondary, context
        app = FlatlandPlan(self.env, context, instance_lp=self.instance_lp)
        clingo_main(app, self.primary)
        return(app.action_list)


class SimulationManager():
    def __init__(self,env,primary,secondary=None):
        self.env = env
        self.primary = primary
        if secondary is None:
            self.secondary = primary 
        else:
            self.secondary = secondary
        self.model = None
        self.stats = None

    def build_actions(self) -> list:
        """ create initial list of actions """
        # pass env, primary
        app = FlatlandPlan(self.env, None)
        clingo_main(app, self.primary)
        self.stats = app.stats
        self.model = app.model
        return(app.action_list)

    def provide_context(self, actions, timestep, malfunctions) -> str:
        """ provide additional facts when updating list """
        # actions that have already been executed
        # wait actions that are enforced because of malfunctions
        # future actions that were previously planned
        past = convert_formers_to_clingo(actions[:timestep])
        present = convert_malfunctions_to_clingo(malfunctions, timestep)
        future = convert_futures_to_clingo(actions[timestep:])
        return(past + present + future)

    def update_actions(self, context) -> list:
        """ update list of actions following malfunction """
        # pass env, secondary, context
        app = FlatlandPlan(self.env, context)
        clingo_main(app, self.primary)
        return(app.action_list)


class OutputLogManager():
    def __init__(self) -> None:
        self.logs = []

    def add(self,info) -> None:
        """ add info from a timestep to the log """
        self.logs.append(info)

    def save(self,filename) -> None:
        """ save output log to local drive """
        #with open(f"output/{filename}/paths.json", "w") as f:
        #    f.write(json.dumps(self.logs))
        with open(f"output/{filename}/paths.csv", "w") as f:
            f.write("agent;timestep;position;direction;status;given_command\n")
            for log in self.logs:
                f.write(log)

def check_params(par):
    """
    verify that all parameters exist before proceedingd
    """
    required_params = {
        "primary": list
        #"secondary": list
    }

    # check that all required parameters exist and have the correct type
    for param, expected_type in required_params.items():
        if not hasattr(par, param):
            raise ValueError(f"Required parameter '{param}' is missing from the params module")
            
        else:
            # check for correct types
            value = getattr(par, param)
        
            if not isinstance(value, expected_type):
                raise TypeError(f"Parameter '{param}' should be of type {expected_type.__name__}, but got {type(value).__name__}")

    return True


def get_args():
    """ capture command line inputs """
    parser = ArgumentParser()
    parser.add_argument('env_pkl', type=str, help='Flatland environment (.pkl)')
    parser.add_argument('--lp', action='store_true', help='ASP instance (.lp)')
    parser.add_argument("--asp2env", action="store_true", help="Build RailEnv from ASP (.lp) and overwrite corresponding .pkl (requires call to .lp!)")
    parser.add_argument('--no-render', action='store_true', default=True, help='if included, run the Flatland simulation but do not render a GIF')
    return(parser.parse_args())


def main():
    # dev test main
    if check_params(params):
        args: Namespace = get_args()
        no_render = args.no_render
        instance_lp = None

        
        if args.asp2env:
            # --- LP → in-memory env (NOT pickled) ---
            lp_path = args.env_pkl
            assert lp_path.endswith(".lp"), "--asp2envs requires an .lp file"

            env = asp2railenv(lp_path)

            with open(lp_path) as f:
                instance_lp = f.read()

            env_name = os.path.basename(lp_path).replace(".lp", "")

        else:
            # ---------- PKL ----------
            pkl_path = args.env_pkl
            assert pkl_path.endswith(".pkl")

            with open(pkl_path, "rb") as f:
                env = pickle.load(f)

            env_name = os.path.basename(pkl_path).replace(".pkl", "")

            if args.lp:
                lp_path = pkl_path.replace("/pkl/", "/lp/").replace(".pkl", ".lp")
                with open(lp_path) as f:
                    instance_lp = f.read()

    start_time = time.time()
    # create manager objects
    mal = MalfunctionManager(env.get_num_agents())
    # sim = SimulationManager(env, params.primary, params.secondary)
    sim = IncrementalSimulationManager(env, params.primary, params.secondary, instance_lp=instance_lp)
    log = OutputLogManager()

    # envrionment rendering
    env_renderer = None
    if not no_render:
        env_renderer = RenderTool(env, gl="PILSVG")
        env_renderer.reset()
        images = []

    # create directory
    os.makedirs("tmp/frames", exist_ok=True)
    # i needed to change this: from integers to railways Env Actions 
    action_map = {RailEnvActions.MOVE_LEFT:'move_left',RailEnvActions.MOVE_FORWARD:'move_forward',RailEnvActions.MOVE_RIGHT:'move_right',RailEnvActions.STOP_MOVING:'wait'}
    state_map = {0:'waiting', 1:'ready to depart', 2:'malfunction (off map)', 3:'moving', 4:'stopped', 5:'malfunction (on map)', 6:'done'}
    dir_map = {0:'n', 1:'e', 2:'s', 3:'w'}

    actions = sim.build_actions()

    train_dict = train_info(env)

    sim_time = time.time() - start_time
    print(f"Initial plan computed in {sim_time:.2f} seconds.")

    timestep = 0

    while len(actions) > timestep:
        # add to the log
        for a in actions[timestep]:
            log.add(f'{a};{timestep};{env.agents[a].position};{dir_map[env.agents[a].direction]};{state_map[env.agents[a].state]};{action_map[actions[timestep][a]]}\n')
            train_dict[a]["path"][timestep] = {
                "position": {"x": int(env.agents[a].position[1]), "y": int(env.agents[a].position[0])} if env.agents[a].position is not None else None,
                "direction": dir_map[env.agents[a].direction],
                "status": env.agents[a].state.name,
                "action": action_map[actions[timestep][a]]
            }

        _, _, done, info = env.step(actions[timestep])

        # end if simulation is finished
        if done['__all__'] and timestep < len(actions)-1:
            warnings.warn('Simulation has reached its end before actions list has been exhausted.')
            break

        # check for new malfunctions
        new_malfs = mal.check(info)

        if len(new_malfs) > 0:
            context = sim.provide_context(actions, timestep, mal.get())
            actions = sim.update_actions(context)

        mal.deduct() #??? where in the loop should this go - before context?
        
        # render an image
        filename = 'tmp/frames/flatland_frame_{:04d}.png'.format(timestep)
        if env_renderer is not None:
            env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
            env_renderer.gl.save_image(filename)
            env_renderer.reset()

            # add red numbers in the corner
            with Image.open(filename) as img:
                draw = ImageDraw.Draw(img)
                padding = 10
                font_size = int(min(img.width, img.height) * 0.10)
                try:
                    font = ImageFont.truetype("modules/LiberationMono-Regular.ttf", font_size)
                except IOError:
                    font = ImageFont.load_default()
                
                # prepare text
                text = f"{timestep}"
                size = font.getbbox(text)
                text_width = size[2]-size[0]
                text_position = (img.width - text_width - padding, padding)
                
                # draw text borders
                x, y = text_position
                border_color = "black"
                for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]:
                    draw.text((x + dx, y + dy), text, fill=border_color, font=font)
                
                # draw text
                draw.text(text_position, text, fill="red", font=font)
                img.save(filename)

            images.append(imageio.imread(filename))
        # images.append(imageio.imread(filename))

        timestep = timestep + 1

    # get time stamp for gif and output log
    stamp = env_name + "_" + str(time.time())
    os.makedirs(f"output/{stamp}", exist_ok=True)
    base_dir = f"output/{stamp}"

    with open(os.path.join(base_dir, "train_info.json"), "w") as f:
        json.dump(train_dict, f, indent=4)

    with open(os.path.join(base_dir, "grid.json"), "w") as f:
        json.dump(grid_json(env), f, indent=4)

    # dump model to file
    with open(os.path.join(base_dir, "model.lp"), "w") as f:
        for symbol in sim.model:
            f.write(f"{symbol}.\n")

    car_dict = build_car_dict(sim.model)
    with open(os.path.join(base_dir, "car_info.json"), "w") as f:
        json.dump(car_dict, f, indent=4)

    additional_info = get_additional_info(sim.model)
    with open(os.path.join(base_dir, "additional_info.json"), "w") as f:
        json.dump(additional_info, f, indent=4)

    # dump stats to file
    with open(os.path.join(base_dir, "clingo_stats.txt"), "w") as f:
        f.write("Files loaded:\n")
        f.write(env_name + "\n")
        for file in params.primary + (params.secondary if params.secondary else []):
            f.write(f"{file}\n")
        f.write("\nStatistics:\n")
        f.write(f"Simulation time: {sim_time:.2f}s\n")
        f.write(json.dumps(sim.stats, indent=4))
    
    print("Generating HTML visualization...")
    # whole animation should last 30s, one step should not be longer than 120ms
    milliseconds_per_step = min(int(30000 / timestep), 120)
    landscape = LandscapeBuilder(base_dir, timestep, cell_size=20)
    html_file = generate_html(env_name, landscape, milliseconds_per_step=milliseconds_per_step)
    with open(os.path.join(base_dir, "visualization.html"), "w") as f:
        f.write(html_file)

    # combine images into gif
    if not no_render:
        imageio.mimsave(f"output/{stamp}/animation.gif", images, format='GIF', loop=0, duration=240)

    # save output log
    log.save(stamp)


if __name__ == "__main__":
    main()
