# functions for saving a Flatland environment as various file types

from flatland.utils.rendertools import RenderTool, AgentRenderVariant
import pickle

def save_lp(env, env_num, file_location):
    """ 
    save the clingo representation as an .lp file to be loaded later 
    """
    with open("{}env_{:01d}.lp".format(file_location, env_num), 'w') as f:
        f.write(env)


def save_png(env, env_num, file_location):
    """ 
    visually render a given environment and save image to file
    """
    DO_RENDERING = True    
    env_renderer = RenderTool(env, gl="PILSVG")
    env_renderer.reset()

    if env_renderer is not None:
        env_renderer.render_env(show=True, show_observations=False, show_predictions=False)
        env_renderer.gl.save_image("{}env_{:01d}.png" .format(file_location, env_num))
        env_renderer.reset()


def save_pkl(env, env_num, file_location):
    """ 
    save a given rail environment metadata as a pickle file to be loaded later 
    """
    pickle.dump(env, open("{}env_{:01d}.pkl".format(file_location, env_num), "wb"))