# Python libraries --
import os
from argparse import ArgumentParser, Namespace

# Custom functions --
from save import save_lp, save_png, save_pkl
from generate import generate_env
from convert import convert_to_clingo

def get_args():
    """
    capture command line inputs
    """
    parser = ArgumentParser()

    parser.add_argument('num_envs', type=int, default=0, nargs='?', help='the number of environments to create according to the given parameters')
    parser.add_argument('height', type=int, default=30, nargs='?', help='the height of each environment')
    parser.add_argument('width', type=int, default=30, nargs='?', help='the width of each environment')
    parser.add_argument('num_trains', type=int, default=2, nargs='?', help='the number of trains placed in each environment')
    parser.add_argument('num_cities', type=int, default=2, nargs='?', help='the number of cities in each environment, where trains can begin or end their journeys')
    parser.add_argument('grid_mode', type=bool, default=True, nargs='?', help='if true, cities will be arranged in a grid-like fashion')
    parser.add_argument('max_rails_between', type=int, default=2, nargs='?', help='the maximum number of rails connecting any two cities')
    parser.add_argument('max_rails_within', type=int, default=2, nargs='?', help='the maximum number of parallel tracks within one city')

    return(parser.parse_args())


def main():
    # create directory
    file_location = '../envs/'
    os.makedirs(file_location, exist_ok=True)
    
    # capture arguments
    args: Namespace = get_args()

    # generate environments
    for idx in range(args.num_envs):
        env = generate_env(width=args.width, height=args.height, nr_trains=args.num_trains, 
                    cities_in_map=args.num_cities, seed=1, grid_distribution_of_cities=args.grid_mode, 
                    max_rails_between_cities=args.max_rails_between, max_rail_in_cities=args.max_rails_within)

        # save files
        save_lp(convert_to_clingo(env), idx, file_location)
        save_png(env, idx, file_location)
        save_pkl(env, idx, file_location)
