import pickle
import os
import sys
from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
import flatland

def convert_to_clingo(env_file) -> str:
    """
    converts Flatland environment to clingo facts
    """
    # environment properties
    env = pickle.load(open(env_file, "rb"))
    print(env)
    rail_map = env["grid"]
    agents = env["agents"]
    max_steps = env["max_episode_steps"]
    # clingo_str = f"% clingo representation of a Flatland environment\n% height: {height}, width: {width}, agents: {len(agents)}\n"
    clingo_str = ""
    clingo_str += f"\nglobal({max_steps}).\n"

    # save start and end positions for each agent
    dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
    
    for agent_num, agent_info in enumerate(env["agents"]):
        init_y, init_x = agent_info.initial_position
        goal_y, goal_x = agent_info.target
        min_start, max_end = agent_info.earliest_departure, agent_info.latest_arrival
        speed = int(1/agent_info.speed_counter.speed) # inverse, e.g. 1/2 --> 2, 1/4 --> 4 etc.

        direction = dir_map[agent_info.initial_direction]
        clingo_str += f"\ntrain({agent_num}). "
        clingo_str += f"start({agent_num},({init_y},{init_x}),{min_start},{direction}). "
        clingo_str += f"end({agent_num},({goal_y},{goal_x}),{max_end}). "
        clingo_str += f"speed({agent_num},{speed}).\n"

    clingo_str += "\n"

    # create an atom for each cell in the environment
    #row_num = len(rail_map) - 1
    for row, row_array in enumerate(rail_map):
        for col, cval in enumerate(row_array):
            clingo_str += f"cell(({row},{col}), {cval}).\n"
        #row_num -= 1
        clingo_str+="\n"

    print(clingo_str)
    return(clingo_str)


def save_lp(env, file_location):
    """ 
    save the clingo representation as an .lp file to be loaded later 
    """
    with open(f"{file_location}.lp", "w") as f:
        f.write(env)


env_file = sys.argv[1]
file_location = os.path.splitext(sys.argv[1])[0]

save_lp(convert_to_clingo(env_file), file_location)
