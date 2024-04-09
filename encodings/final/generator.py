# Python libraries --
import os
import json
import pickle
import re
import numpy as np
from argparse import ArgumentParser, Namespace
from gen_functions import *

# Flatland libraries --
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

# Command line inputs --
parser = ArgumentParser()

parser.add_argument('num_envs', type=int, default=0, nargs='?', help='the number of environments to create according to the given parameters')
parser.add_argument('height', type=int, default=30, nargs='?', help='the height of each environment')
parser.add_argument('width', type=int, default=30, nargs='?', help='the width of each environment')
parser.add_argument('num_trains', type=int, default=2, nargs='?', help='the number of trains placed in each environment')
parser.add_argument('num_cities', type=int, default=2, nargs='?', help='the number of cities in each environment, where trains can begin or end their journeys')
parser.add_argument('grid_mode', type=bool, default=True, nargs='?', help='if true, cities will be arranged in a grid-like fashion')
parser.add_argument('max_rails_between', type=int, default=2, nargs='?', help='the maximum number of rails connecting any two cities')
parser.add_argument('max_rails_within', type=int, default=2, nargs='?', help='the maximum number of parallel tracks within one city')

args: Namespace = parser.parse_args()

# Main program --
file_location = './envs/'

for idx in range(args.num_envs):
    # generate an environment
    env = generate(width=args.width, height=args.height, nr_trains=args.num_trains, 
                   cities_in_map=args.num_cities, seed=14, grid_distribution_of_cities=args.grid_mode, 
                   max_rails_between_cities=args.max_rails_between, max_rail_in_cities=args.max_rails_within)

    # create directory if does not yet exist
    try:
        os.makedirs(file_location)
    except FileExistsError:
        pass

    # create sub-directory for individual environment
    os.makedirs(file_location + "env_{:01d}/".format(idx), exist_ok=True)

    # (env.lp) save the clingo output
    clingo_env = convert_rail_to_clingo(env, args.height)
    save_clingo(clingo_env, idx, file_location)

    # (env.lp) save the image
    save_render(env, idx, file_location)

    # (env.p) save the env object
    save_env(env, idx, file_location)