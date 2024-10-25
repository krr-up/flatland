from envs import params
from argparse import ArgumentParser, Namespace

# custom modules
from modules.dirs import create_dirs, find_start
from modules.save import save_lp, save_png, save_pkl
from modules.convert import convert_to_clingo

# Flatland modules
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions # do we still need this?
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.envs.malfunction_generators import MalfunctionParameters, ParamMalfunctionGen


def check_params(par):
    """
    verify that all parameters exist before proceeding
    """
    required_params = {
        "width": int,
        "height": int,
        "number_of_agents": int,
        "max_num_cities": int,
        "seed": int,
        "grid_mode": bool,
        "max_rails_between_cities": int,
        "max_rail_pairs_in_city": int,
        "remove_agents_at_target": bool,
        "speed_ratio_map": dict,
        "malfunction_rate": float,
        "min_duration": int,
        "max_duration":  int
    }

    # check that all required parameters exist and have the correct type
    for param, expected_type in required_params.items():
        if not hasattr(par, param):
            raise ValueError(f"Required parameter '{param}' is missing from the params module")
            
        else:
            # check for correct types
            value = getattr(par, param)
            
            if expected_type is int and isinstance(value, bool):
                raise TypeError(f"Parameter '{param}' cannot be a boolean; it should be of type {expected_type.__name__}.")
        
            if not isinstance(value, expected_type):
                raise TypeError(f"Parameter '{param}' should be of type {expected_type.__name__}, but got {type(value).__name__}")

    return True


def get_args():
    """
    capture command line inputs
    """
    parser = ArgumentParser()
    parser.add_argument('num_envs', type=int, default=1, nargs='?', help='the number of environments to create according to the given parameters')

    return(parser.parse_args())


def main():
    if check_params(params):
        path = create_dirs()
        start_index = find_start(path)
        args: Namespace = get_args()

        for i in range(start_index, start_index + args.num_envs):
            rail_generator = sparse_rail_generator(
                        max_num_cities= params.max_num_cities,
                        #seed= params.seed,
                        grid_mode= params.grid_mode,
                        max_rails_between_cities= params.max_rails_between_cities,
                        max_rail_pairs_in_city= params.max_rail_pairs_in_city,
                        )

            stochastic_data = MalfunctionParameters(
                        malfunction_rate= params.malfunction_rate,
                        min_duration= params.min_duration,
                        max_duration= params.max_duration
                        )

            speed_ratio_map = params.speed_ratio_map
            line_generator = sparse_line_generator(speed_ratio_map)
            observation_builder = GlobalObsForRailEnv()

            env = RailEnv(
                        width= params.width,
                        height= params.height,
                        rail_generator= rail_generator,
                        line_generator= line_generator,
                        number_of_agents= params.number_of_agents,
                        obs_builder_object= observation_builder,
                        malfunction_generator=ParamMalfunctionGen(stochastic_data),
                        remove_agents_at_target= params.remove_agents_at_target
                        )
            env.reset()

            # save files
            file_name = f"env_{i:03d}--{params.number_of_agents}_{params.max_num_cities}"
            save_lp(convert_to_clingo(env), file_name, path)
            save_png(env, file_name, path)
            save_pkl(env, file_name, path)
            

if __name__ == "__main__":
    main()
