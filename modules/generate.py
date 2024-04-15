# function for generating an environment given a set of user-defined parameters

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.envs.rail_generators import sparse_rail_generator
from flatland.envs.line_generators import sparse_line_generator
from flatland.envs.observations import GlobalObsForRailEnv
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

def generate_env(width=30, height=30, nr_trains=2, cities_in_map=2, seed=1, grid_distribution_of_cities=True, max_rails_between_cities=2, max_rail_in_cities=2):
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