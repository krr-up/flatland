# read clingo solution and convert the actions to a visualization
import json
import re
import pickle
import os

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

# read in the file to build action_list
with open('./model.json', 'r') as f:
    file = json.load(f)
try:
    actions = file['Call'][0]['Witnesses'][0]['Value']
except KeyError as e:
    print('\n\nError:\n\nThe model is unsatisfiable.  Try increasing the maximum number of steps.\n\n')

action_list = []
for action in actions:
    regex = re.match("action\((\d+),(\w+),(\d+)\)", action)
    agent = int(regex.group(1))
    action = regex.group(2)
    timestep = int(regex.group(3))
    
    # append to the action list
    action_list.append((agent,action,timestep))


# read in the environment file
env = pickle.load(open("./envs/env_0.p", "rb"))


# build a clingo agent
class ClingoAgent:
    def __init__(self):
        return

    def act(self, state):
        mapping = {"forward":RailEnvActions.MOVE_FORWARD, "turn_right":RailEnvActions.MOVE_RIGHT, "turn_left":RailEnvActions.MOVE_LEFT, "wait":RailEnvActions.STOP_MOVING}
        current_agent = state[0]
        current_timestep = state[1]
        current_action = [item[1] for item in action_list if item[0] == current_agent and item[2] == current_timestep][0]
        return mapping[current_action]
    

# render the visualization
# Initialize the agent with the parameters corresponding to the environment and observation_builder
controller = ClingoAgent()
action_dict = dict()

# Reset the rendering system
env_renderer = RenderTool(env, gl="PILSVG")
env_renderer.reset()

if env_renderer is not None:
    env_renderer.reset()

# don't care about these
score = 0
frame_step = 0

os.makedirs("tmp/frames", exist_ok=True)

max_actions = max([item[2] for item in action_list])

for step in range(max_actions+1):
    # Chose an action for each agent in the environment
    for a in range(env.get_num_agents()):
        action = controller.act((a+1,step))
        action_dict.update({a: action})
        
    #print(action_dict)

    next_obs, all_rewards, done, _ = env.step(action_dict)

    #env_renderer = None

    if env_renderer is not None:
        env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
        env_renderer.gl.save_image('tmp/frames/flatland_frame_{:04d}.png'.format(step))
        env_renderer.reset()
    
    done['__all__'] = False
        
    #print('Episode: Steps {}\t Score = {}'.format(step, score))

# close the renderer / rendering window
if env_renderer is not None:
    env_renderer.close_window()