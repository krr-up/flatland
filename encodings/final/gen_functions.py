"""
custom functions used by generator.py
"""

# Python libraries --
import os
import json
import pickle
import re
import numpy as np

# Flatland libraries --
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.utils.rendertools import RenderTool, AgentRenderVariant


def generate(width=30, height=30, nr_trains=2, cities_in_map=2, seed=1, grid_distribution_of_cities=True, max_rails_between_cities=2, max_rail_in_cities=2):
    """
    generate a rail environment using Flatland libraries
    """

    rail_generator = sparse_rail_generator(max_num_cities=cities_in_map,
                                        seed=seed, #omitting this for now
                                        grid_mode=grid_distribution_of_cities,
                                        max_rails_between_cities=max_rails_between_cities,
                                        max_rail_pairs_in_city=max_rail_in_cities,
                                        )

    speed_ration_map = {1: 1.0} # all speed profiles are identical
    line_generator = sparse_line_generator()

    # custom observation and environment
    observation_builder = GlobalObsForRailEnv()

    env = RailEnv(width=width,
                height=height,
                rail_generator=rail_generator,
                line_generator=line_generator,
                number_of_agents=nr_trains,
                obs_builder_object=observation_builder,
                remove_agents_at_target=True)
    env.reset()

    return(env)

def convert_rail_to_clingo(env, height):
    """
    convert Flatland map to Clingo facts (env.lp)
    """
    
    rail_map = env.rail.grid
    print(rail_map)
    clingo_str = ""
    mapping = {}

    # create the cell() atoms
    row_num = len(rail_map) - 1
    for row in rail_map:
        for col,cval in enumerate(row):
            clingo_str += "cell(({},{}), {}). ".format(col+0,row_num+0,cval)
            mapping[(col,row_num)] = cval
        row_num -= 1

    # create the agent(), start(), and end() positions for each agent
    dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
    agents = env.agents
    
    for agent_num, agent_info in enumerate(env.agents):
        init_y, init_x = agent_info.initial_position
        goal_y, goal_x = agent_info.target

        # flip the y-axis
        init_y = height - init_y - 1
        goal_y = height - goal_y - 1

        direction = dir_map[agent_info.initial_direction]
        clingo_str += "agent({}). ".format(agent_num+1)
        clingo_str += "start(agent({}),cell({},{}),dir({})). ".format(agent_num+1, init_x, init_y, direction)
        clingo_str += "end(agent({}),cell({},{})). ".format(agent_num+1, goal_x, goal_y)
        
    #print(mapping)
    return(clingo_str)

def save_render(env, env_num, file_location):
    """
    render a given environment and save image to file
    """

    DO_RENDERING = True    
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.reset()

    if env_renderer is not None:
        env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
        env_renderer.gl.save_image('{}env_{:01d}/env_{:01d}.png'.format(file_location, env_num, env_num))
        env_renderer.reset()

def save_env(env, env_num, file_location):
    """
    save a given rail environment metadata as a pickle file to be loaded later
    """

    pickle.dump(env, open("{}env_{:01d}/env_{}.p".format(file_location, env_num, env_num), "wb"))

def save_clingo(env, env_num, file_location):
    """
    save the clingo representation as an .lp file to be loaded later
    """

    f = open("{}env_{:01d}/env_{:01d}.lp".format(file_location, env_num, env_num), 'w')
    f.write(env)
    f.close()

convert_rail_to_clingo(generate(),30)