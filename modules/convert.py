from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant


def convert_to_clingo(env) -> str:
    """
    converts Flatland environment to clingo facts
    """
    # environment properties
    rail_map = env.rail.grid
    height, width, agents = env.height, env.width, env.agents
    clingo_str = f"% clingo representation of a Flatland environment\n% height: {height}, width: {width}, agents: {len(agents)}\n"
    clingo_str += f"\nglobal({env._max_episode_steps}).\n"

    # save start and end positions for each agent
    dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
    
    for agent_num, agent_info in enumerate(env.agents):
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
        
    return(clingo_str)

def convert_formers_to_clingo(actions) -> str:
    # change back to the clingo names
    mapping = {RailEnvActions.MOVE_FORWARD:"move_forward", RailEnvActions.MOVE_RIGHT:"move_right", RailEnvActions.MOVE_LEFT:"move_left", RailEnvActions.STOP_MOVING:"wait"}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]

    facts = []
    # change from dictionary into facts
    for index, dict in enumerate(actions):
        for key in dict.keys():
            facts.append(f':- not action(train({key}),{actions[index][key]},{index}).\n') #remove: can this be a list of strings or should it be one long string?
    
    return(facts)


def convert_malfunctions_to_clingo(malfs, timestep) -> str:
    #mapping = {RailEnvActions.MOVE_FORWARD:"move_forward", RailEnvActions.MOVE_RIGHT:"move_right", RailEnvActions.MOVE_LEFT:"move_left", RailEnvActions.STOP_MOVING:"wait"}
    facts = []
    for m in malfs:
        train, duration = m[0], m[1]
        facts.append(f'malfunction({train},{duration},{timestep}).\n')
        for t in range(timestep+1, timestep+1+m[1]): # remove: make sure this duration should be included (aka remove +1 or keep it?)
            facts.append(f':- not action(train({train}),wait,{t}).\n') #remove: can this be a list of strings or should it be one long string?

    return(facts)


def convert_futures_to_clingo(actions) -> str:
    # change back to the clingo names
    mapping = {RailEnvActions.MOVE_FORWARD:"move_forward", RailEnvActions.MOVE_RIGHT:"move_right", RailEnvActions.MOVE_LEFT:"move_left", RailEnvActions.STOP_MOVING:"wait"}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]

    facts = []
    # change from dictionary into facts
    for index, dict in enumerate(actions):
        for key in dict.keys():
            facts.append(f'planned_action(train({key}),{actions[index][key]},{index}).\n') #remove: can this be a list of strings or should it be one long string?
    
    return(facts)

def convert_actions_to_flatland(actions) -> list:
    mapping = {"move_forward":RailEnvActions.MOVE_FORWARD, "move_right":RailEnvActions.MOVE_RIGHT, "move_left":RailEnvActions.MOVE_LEFT, "wait":RailEnvActions.STOP_MOVING}
    for index, dict in enumerate(actions):
        for key in dict.keys():
            actions[index][key] = mapping[actions[index][key]]
    return(actions)