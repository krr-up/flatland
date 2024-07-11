# function for converting Flatland environment into a string of clingo-readable ASP facts

# def flip_y(height, y) -> int:
#     """
#     flips the value of the y along the axis for a given environment
#     """
#     return(height - y - 1)


def convert_to_clingo(env) -> str:
    """
    converts Flatland environment to clingo facts
    """
    # environment properties
    rail_map = env.rail.grid
    height, width, agents = env.height, env.width, env.agents
    clingo_str = f"% clingo representation of a Flatland environment\n% height: {height}, width: {width}, agents: {len(agents)}\n"

    # save start and end positions for each agent
    dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
    
    for agent_num, agent_info in enumerate(env.agents):
        init_y, init_x = agent_info.initial_position
        goal_y, goal_x = agent_info.target
        min_start, max_end = agent_info.earliest_departure, agent_info.latest_arrival

        # flip the y-axis
        # init_y = flip_y(height, init_y)
        # goal_y = flip_y(height, goal_y)

        direction = dir_map[agent_info.initial_direction]
        clingo_str += f"\ntrain({agent_num}). "
        clingo_str += f"start({agent_num},({init_y},{init_x}),{min_start},{direction}). "
        clingo_str += f"end({agent_num},({goal_y},{goal_x}),{max_end}).\n"

    # create an atom for each cell in the environment
    #row_num = len(rail_map) - 1
    for row, row_array in enumerate(rail_map):
        for col, cval in enumerate(row_array):
            clingo_str += f"cell(({row},{col}), {cval}).\n"
        #row_num -= 1
        clingo_str+="\n"
        
    return(clingo_str)
