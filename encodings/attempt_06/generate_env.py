"""
Generate custom Flatland environments in batch
"""

# import libraries
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.rail_env import RailEnv
import numpy as np

# choose custom parameters
width = 30
height = 20
num_agents = 1
num_cities = 2
max_rails_between_cities = 2
max_rails_in_city = 4

parameters = width, height, num_agents, num_cities, max_rails_between_cities, max_rails_in_city

# build environment
def build_env(width, height, num_agents, num_cities, max_rails_between_cities, max_rails_in_city, seed):
    """build out and save environment according to specified parameters"""

    # define sparse rail generator
    gen = sparse_rail_generator(
        max_num_cities=num_cities,
        seed=seed,
        grid_mode=True,
        max_rails_between_cities=max_rails_between_cities,
        max_rail_pairs_in_city=max_rails_in_city
    )

    # define environment
    env = RailEnv(
        width=width,
        height=height,
        rail_generator=gen,
        line_generator=sparse_line_generator(),
        number_of_agents=num_agents
    )

    _, _ = env.reset()
    print()
    return env

# convert rail grid array to Clingo string
class clingo_grid():
    """representing the array of a Flatland map in a way that clingo can process"""
    
    def __init__(self, rail_map):
        self.clingo_str = ""
        self.mapping = {}
        
        row_num = len(rail_map) - 1
        for row in rail_map:
            for col,cval in enumerate(row):
                self.clingo_str += "cell(({},{}), {}). ".format(col,row_num,cval)
                self.mapping[(col,row_num)] = cval
            row_num -= 1

# generate environments
num_environments = 3

for envir in range(num_environments):
    current_env = build_env(*parameters, envir) #set envir as seed value

    # save entire environment -- BUG
    # current_env.save('save_test')

    # save rail grid
    #np.savetxt('./test_envs/env_'+str(envir), current_env.rail.grid, fmt = '% 4d')
    clingo = clingo_grid(current_env.rail.grid)
    f = open('./test_envs/env_'+str(envir), 'w')
    f.write(clingo.clingo_str)
    f.close()
    