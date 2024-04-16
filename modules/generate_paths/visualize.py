# read clingo solution and convert the actions to a visualization
import json
import re
import pickle
import os
import sys
import imageio.v2 as imageio
import time

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

# arbitrary action list and environment
#action_list = [(1,'move_forward',0),(1,'move_forward',1),(1,'move_forward',2),(1,'move_forward',3),(2,'move_forward',0),(2,'move_forward',1),(2,'move_forward',2),(2,'move_forward',3),(1,'move_forward',4),(2,'move_forward',4),(1,'move_forward',5),(2,'move_forward',5),(1,'move_forward',6),(2,'move_forward',6),(1,'move_forward',7),(2,'move_forward',7),(1,'move_forward',8),(2,'move_forward',8)] # this needs to be input
#action_list = [(1,'move_forward',0),(1,'move_forward',1),(1,'move_forward',2),(1,'move_forward',3),(1,'move_forward',4),(1,'move_forward',5),(1,'move_forward',6),(1,'move_forward',7),(1,'move_forward',8),(1,'move_forward',9),(1,'move_forward',10),(1,'move_forward',11),(1,'move_forward',12),(1,'move_forward',13),(1,'move_forward',14),(1,'move_forward',15),(1,'move_forward',16),(1,'move_forward',17),(1,'move_forward',18),(1,'move_forward',19),(1,'move_forward',20),(1,'move_forward',21),(1,'move_forward',22),(1,'move_forward',23),(1,'move_forward',24),(1,'move_forward',25),(1,'move_forward',26),(1,'move_forward',27),(1,'move_forward',28),(1,'move_forward',29),(1,'move_forward',30),(1,'move_forward',31),(1,'move_forward',32),(1,'move_forward',33),(1,'move_forward',34),(1,'move_forward',35),(1,'move_forward',36),(1,'move_forward',37),(1,'move_forward',38),(1,'move_forward',39),(1,'move_forward',40),(1,'move_forward',41),(1,'move_forward',42),(1,'move_forward',43),(1,'move_forward',44),(1,'move_right',45),(1,'move_forward',46),(1,'move_forward',47)] # this needs to be input up to 43
action_list = [(1,'move_forward',0),(1,'move_forward',1),(1,'move_forward',2),(1,'move_forward',3),(1,'move_forward',4),(1,'move_forward',5),(1,'move_left',6),(1,'move_forward',7),(1,'move_forward',8),(1,'move_right',9),(1,'move_forward',10),(1,'move_left',11),(1,'move_forward',12),(1,'move_forward',13),(1,'move_forward',14),(1,'move_forward',15),(1,'move_forward',16),(1,'move_forward',17),(1,'move_forward',18),(1,'move_forward',19),(1,'move_forward',20),(1,'move_forward',21),(1,'move_forward',22),(1,'move_forward',23),(1,'move_forward',24),(1,'move_forward',25),(1,'move_forward',26),(1,'move_forward',27),(1,'move_forward',28),(1,'move_forward',29),(1,'move_forward',30),(1,'move_forward',31),(1,'move_forward',32),(1,'move_forward',33),(1,'move_forward',34),(1,'move_forward',35),(1,'move_forward',36),(1,'move_forward',37),(1,'move_forward',38),(1,'move_forward',39),(1,'move_forward',40),(1,'move_forward',41),(1,'move_forward',42),(1,'move_forward',43),(1,'move_forward',44),(1,'move_right',45),(1,'move_forward',46),(1,'move_forward',47)] # this needs to be input up to 43
env = pickle.load(open("../../envs/pkl/env_10.pkl", "rb")) # this needs to be input

#env_path, action_list = sys.argv[1:]

# read in the environment file
#env = pickle.load(open("./{}".format(env_path), "rb"))


class ClingoAgent:
    """
    build a clingo agent
    """
    def __init__(self, env, action_list):
        self.env = env
        self.action_list = action_list

    def act(self, state):
        mapping = {"move_forward":RailEnvActions.MOVE_FORWARD, "move_right":RailEnvActions.MOVE_RIGHT, "move_left":RailEnvActions.MOVE_LEFT, "wait":RailEnvActions.STOP_MOVING}
        current_agent, current_timestep = state
        current_action = [item[1] for item in action_list if item[0] == current_agent and item[2] == current_timestep][0]
        return mapping[current_action]
    

def render(env,actions):
    """
    render the visualization
    """
    # Initialize the agent with the parameters corresponding to the environment and observation_builder
    controller = ClingoAgent(env,actions)
    action_dict = dict()
    images = []

    # Reset the rendering system
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.reset()

    if env_renderer is not None:
        env_renderer.reset()

    # don't care about these
    score = 0
    frame_step = 0

    os.makedirs("tmp/frames", exist_ok=True)
    os.makedirs("output", exist_ok=True)

    max_actions = max([item[2] for item in action_list]) + 1

    for step in range(max_actions):
        # Chose an action for each agent in the environment
        for a in range(env.get_num_agents()):
            print("a:", a+1, step)
            action = controller.act((a+1,step))
            action_dict.update({a: action})
            
        #print(action_dict)

        next_obs, all_rewards, done, _ = env.step(action_dict)

        filename = 'tmp/frames/flatland_frame_{:04d}.png'.format(step)

        #env_renderer = None

        if env_renderer is not None:
            env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
            env_renderer.gl.save_image(filename)
            env_renderer.reset()

        images.append(imageio.imread(filename))
        
        done['__all__'] = False
            
        #print('Episode: Steps {}\t Score = {}'.format(step, score))
   
    # combine images into gif
    imageio.mimsave(f"output/{time.time()}.gif", images, format='GIF', loop=0, duration=0.9)

    # close the renderer / rendering window
    if env_renderer is not None:
        env_renderer.close_window()


if __name__ == "__main__":
    #main(Flatland(), sys.argv[1:])
    render(env,action_list)