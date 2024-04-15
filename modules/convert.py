# function for converting Flatland environment into a string of clingo-readable ASP facts

def flip_y(height, y) -> int:
    """
    flips the value of the y along the axis for a given environment
    """
    return(height - y - 1)


def convert_to_clingo(env) -> str:
    """
    converts Flatland environment to clingo facts
    """
    # environment properties
    rail_map = env.rail.grid
    height, width, agents = env.height, env.width, env.agents
    clingo_str = f"% clingo representation of a Flatland environment\n% height: {height}, width: {width}, agents {len(agents)}"

    # create an atom for each cell in the environment
    row_num = len(rail_map) - 1
    for row in rail_map:
        for col, cval in enumerate(row):
            clingo_str += f"cell(({col+0},{row_num+0}), {cval}). "
        row_num -= 1

    # save start and end positions for each agent
    dir_map = {0:"n", 1:"e", 2:"s", 3:"w"}
    
    for agent_num, agent_info in enumerate(env.agents):
        init_y, init_x = agent_info.initial_position
        goal_y, goal_x = agent_info.target

        # flip the y-axis
        init_y = flip_y(height, init_y)
        goal_y = flip_y(height, goal_y)

        direction = dir_map[agent_info.initial_direction]
        clingo_str += f"agent({agent_num+1}). "
        clingo_str += f"start(agent({agent_num+1}),cell({init_x},{init_y}),dir({direction})). "
        clingo_str += f"end(agent({agent_num+1}),cell({goal_x},{goal_y})). "
        
    return(clingo_str)