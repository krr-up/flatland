from flatland.utils.rendertools import RenderTool
import imageio.v2 as imageio
import pickle

# load environment
env = pickle.load(open("/Users/ryanmurphy/git/flatland/envs/pkl/env_010--2_2.pkl", "rb"))

print(env.agents[0].speed_counter.speed)
env.agents[0].speed_counter.speed = 1
print(env.agents[0].speed_counter.speed)