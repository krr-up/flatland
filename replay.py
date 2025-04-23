import pickle
import time

from flatland.envs.persistence import RailEnvPersister
from flatland.envs.rail_env import RenderTool
from flatland.utils.rendertools import RenderTool
import random
from flatland.envs.rail_env import RailEnvActions

# Load the saved environment
env, stats = RailEnvPersister.load_new('saved_episode_2.pkl')

# Set up renderer
renderer = RenderTool(env, gl="PIL")  # or gl="QT" if you want real-time (but PIL is usually safer)
renderer.reset()

# Reset the environment
obs, info = env.reset()

# Step through the environment
done = {'__all__': False}

while not done['__all__']:
    # Choose random valid actions for all agents
    action_dict = {}
    for agent_handle in env.get_agent_handles():
        # action = env.action_space(agent_handle).sample()
        action = random.choice(list(RailEnvActions))
        action_dict[agent_handle] = action

    # Step the environment
    obs, rewards, done, info = env.step(action_dict)

    # Render the environment
    renderer.render_env(show=True, show_observations=False, show_predictions=False)

    # Slow down so you can see it
    time.sleep(0.2)

print("Episode finished!")
renderer.close_window()
