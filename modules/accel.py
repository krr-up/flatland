from flatland.utils.rendertools import RenderTool
# import imageio.v2 as imageio
import pickle

# load environment
env = pickle.load(open("./envs/pkl/env_001--2_4.pkl", "rb"))

print(env.agents[0].speed_counter._speed)
print(env.agents[0].speed_counter.speed)

env.agents[0].speed_counter._speed = 0.5
print(env.agents[0].speed_counter._speed)
print(env.agents[0].speed_counter.speed)