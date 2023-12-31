"""
Generate custom Flatland environments in batch
"""

# import libraries
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.rail_env import RailEnv
import numpy as np

# environment rendering
from flatland.utils.rendertools import RenderTool

# choose custom parameters
width = 24
height = 24
num_agents = 1
num_cities = 2
seed = 14
max_rails_between_cities = 2
max_rails_in_city = 2

parameters = width, height, num_agents, num_cities, max_rails_between_cities, max_rails_in_city

# build environment
def build_env(width, height, num_agents, num_cities, max_rails_between_cities, max_rails_in_city, seed=14):
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
    
    def __init__(self, env):
        rail_map = env.rail.grid
        self.clingo_str = ""
        self.mapping = {}
        
        row_num = len(rail_map) - 1
        for row in rail_map:
            for col,cval in enumerate(row):
                self.clingo_str += "cell(({},{}), {}). ".format(col,row_num,cval)
                self.mapping[(col,row_num)] = cval
            row_num -= 1

        dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
        self.clingo_str += "start(cell({},{}),dir({})). ".format(env.agents[0].initial_position[0], env.agents[0].initial_position[1], dir_map[env.agents[0].initial_direction])
        self.clingo_str += "end(cell({},{})). ".format(env.agents[0].target[0], env.agents[0].target[1])
	

# generate environments
num_environments = 1

for envir in range(num_environments):
    current_env = build_env(*parameters, envir) #set envir as seed value

    # save entire environment -- BUG
    # current_env.save('save_test')

    # render an image
    env_renderer = RenderTool(current_env, gl="PILSVG", )
    env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
    env_renderer.gl.save_image('./test_envs/env_{}.png'.format(envir))
    env_renderer.reset()

    # save rail grid
    #np.savetxt('./test_envs/env_'+str(envir), current_env, fmt = '% 4d')
    clingo = clingo_grid(current_env)
    f = open('./test_envs/env_'+str(envir), 'w')
    print("file has been opened")
    f.write(clingo.clingo_str)
    f.close()
    