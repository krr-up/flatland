# read clingo solution and convert the actions to a visualization
import json
import re
import pickle
import os
import sys

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

env_path, action_list = sys.argv[1:]

# arbitrary action list
action_list = [(1,'move_forward',0),(1,'move_forward',1),(1,'move_forward',2),(1,'move_forward',3),(2,'move_forward',0),(2,'move_forward',1),(2,'move_forward',2),(2,'move_forward',3),(1,'move_forward',4),(2,'move_forward',4),(1,'move_forward',5),(2,'move_forward',5),(1,'move_forward',6),(2,'move_forward',6),(1,'move_forward',7),(2,'move_forward',7),(1,'move_forward',8),(2,'move_forward',8)] # this needs to be input

# read in the environment file
#env = pickle.load(open("./env_7/env_7.p", "rb")) # this needs to be input
env = pickle.load(open("./{}".format(env_path), "rb"))


class ClingoAgent:
    """build a clingo agent"""
    def __init__(self, env, action_list):
        self.env = env
        self.action_list = action_list

    def act(self, state):
        mapping = {"move_forward":RailEnvActions.MOVE_FORWARD, "move_right":RailEnvActions.MOVE_RIGHT, "move_left":RailEnvActions.MOVE_LEFT, "wait":RailEnvActions.STOP_MOVING}
        current_agent, current_timestep = state
        current_action = [item[1] for item in action_list if item[0] == current_agent and item[2] == current_timestep][0]
        return mapping[current_action]
    

def main(env,actions):
    """render the visualization"""
    # Initialize the agent with the parameters corresponding to the environment and observation_builder
    controller = ClingoAgent(env,actions)
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
            print("a:", a, step)
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

if __name__ == "__main__":
    