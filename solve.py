# standard packages
import warnings
import os 
import time
import pickle
import json
from argparse import ArgumentParser, Namespace

# custom modules
from asp import params
from modules.api import FlatlandPlan, FlatlandReplan
from modules.convert import convert_malfunctions_to_clingo, convert_formers_to_clingo, convert_futures_to_clingo

# clingo
import clingo
from clingo.application import Application, clingo_main

# rendering visualizations
from flatland.utils.rendertools import RenderTool
import imageio.v2 as imageio


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


class SimulationManager():
    def __init__(self,env,primary,secondary=None):
        self.env = env
        self.primary = primary
        if secondary is None:
            self.secondary = primary 
        else:
            self.secondary = secondary

    def build_actions(self) -> list:
        """ create initial list of actions """
        # pass env, primary
        app = FlatlandPlan(self.env, None)
        clingo_main(app, self.primary)
        return(app.action_list)

    def provide_context(self, actions, timestep, malfunctions) -> str:
        """ provide additional facts when updating list """
        # actions that have already been executed
        # wait actions that are enforced because of malfunctions
        # future actions that were previously planned
        past = convert_formers_to_clingo(actions[:timestep+1])
        present = convert_malfunctions_to_clingo(malfunctions, timestep)
        future = convert_futures_to_clingo(actions[timestep+1:])
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
    parser.add_argument('env', type=str, default='', nargs=1, help='the flatland environment as a .pkl file')
    return(parser.parse_args())


def main():
    # dev test main
    if check_params(params):
        args: Namespace = get_args()
        env = pickle.load(open(args.env[0], "rb"))

    # create manager objects
    mal = MalfunctionManager(env.get_num_agents())
    sim = SimulationManager(env, params.primary, params.secondary)
    log = OutputLogManager()

    # envrionment rendering
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.reset()
    images = []

    # create directory
    os.makedirs("tmp/frames", exist_ok=True)
    action_map = {1:'move_left',2:'move_forward',3:'move_right',4:'wait'}
    state_map = {0:'waiting', 1:'ready to depart', 2:'malfunction (off map)', 3:'moving', 4:'stopped', 5:'malfunction (on map)', 6:'done'}
    dir_map = {0:'n', 1:'e', 2:'s', 3:'w'}

    actions = sim.build_actions()

    timestep = 0
    while len(actions) > timestep:
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
        images.append(imageio.imread(filename))

        # add to the log
        for a in actions[timestep]:
            log.add(f'{a};{timestep};{env.agents[a].position};{dir_map[env.agents[a].direction]};{state_map[env.agents[a].state]};{action_map[actions[timestep][a]]}\n')

        timestep = timestep + 1

    # combine images into gif
    stamp = time.time()
    os.makedirs(f"output/{stamp}", exist_ok=True)
    imageio.mimsave(f"output/{stamp}/animation.gif", images, format='GIF', loop=0, duration=240)

    # save output log
    log.save(stamp)


if __name__ == "__main__":
    main()
