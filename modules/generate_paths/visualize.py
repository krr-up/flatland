# read clingo solution and convert the actions to a visualization
import json
import re
import pickle
import os
import sys
import imageio.v2 as imageio
import time
import shutil

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant


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
        current_action = [item[1] for item in self.action_list if item[0] == current_agent and item[2] == current_timestep][0]
        return mapping[current_action]
    

def render(env, actions):
    """
    render the visualization
    """
    # Initialize the agent with the parameters corresponding to the environment and observation_builder
    controller = ClingoAgent(env,actions)
    action_dict = dict()
    images = []

    action_map = {1:'move_left',2:'move_forward',3:'move_right',4:'wait'}

    # Reset the rendering system
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.reset()

    if env_renderer is not None:
        env_renderer.reset()

    # don't care about these
    score = 0
    frame_step = 0

    os.makedirs("tmp/frames", exist_ok=True)

    #max_actions = max([item[2] for item in controller.action_list]) + 1

    # determine and order all possible states
    all_states = [(x[0],x[2]) for x in controller.action_list]
    ordered_states = sorted(set(all_states), key=lambda x: (x[1], x[0]))
    
    max_agents = max([x[0] for x in ordered_states])
    print(max_agents)
    action_log = [""] * (max_agents+1)
    action_csv = [""] * (max_agents+1)

    print(env.agents)
    print(ordered_states)

    for a, step in ordered_states:
        action = controller.act((a,step))
        action_dict.update({(a): action})
        print(action_dict)
        #action_log += f"Agent #{a} at time {step} >>> {action_map[action]}\n"
        action_log[a] += f"Agent #{a} at time {step} >>> {action_map[action]} - {env.agents[a].position}\n"
        action_csv[a] += f"{a};{step};{action_map[action]};{env.agents[a].position};{env.agents[a].direction};{env.agents[a].state}\n"
        print(a,step,": ",action)
        print(f"state of agent {a}:", env.agents[a].state)

        if a == max_agents:
            print("step\n")
            next_obs, all_rewards, done, _ = env.step(action_dict)
            filename = 'tmp/frames/flatland_frame_{:04d}.png'.format(step)
            if env_renderer is not None:
                env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
                env_renderer.gl.save_image(filename)
                env_renderer.reset()

            images.append(imageio.imread(filename))
        
            done['__all__'] = False

   

    # combine images into gif
    stamp = time.time()
    os.makedirs(f"output/{stamp}", exist_ok=True)
    imageio.mimsave(f"output/{stamp}/animation.gif", images, format='GIF', loop=0, duration=5)

    # remove tmp folder after creating gif
    try:
        shutil.rmtree("tmp/frames")
        shutil.rmtree("tmp")
    except OSError as e:
        print("Error: %s - %s." % (e.filename, e.strerror))

    # save path plans as txt file
    with open(f"output/{stamp}/paths.txt", "w") as f:
        for log in action_log:
            f.write(log)

    # save path plans as csv file
    with open(f"output/{stamp}/paths.csv", "w") as f:
        f.write("agent;timestep;action;position;direction;status\n")
        for csv in action_csv:
            f.write(csv)

    # close the renderer / rendering window
    if env_renderer is not None:
        env_renderer.close_window()
