import sys
import os.path
import re
from subprocess import Popen, PIPE
from clingo.application import Application, clingo_main
import pickle
from create_environments.convert import convert_to_clingo
import generate_paths.visualize

class Flatland(Application):
    program_name = "flatland"
    version = "1.0"

    env_pkl = ""
    action_list = []

    def main(self, ctl, files):

        # load files
        # for filepath in files: 
        #     if os.path.splitext(filepath)[1] == '.lp':
        #         ctl.load(filepath)
        #     if re.search('(env_\d+)', filepath):
        #         print(True)
        #         # find files within env folder              
        #         env_pkl = pickle.load(open(filepath, "rb"))
        #         env_lp = convert_to_clingo(env_pkl)
        #         ctl.load(env_lp)

        if not files: ctl.load("-")

        # ground the program
        ctl.ground([("base", [])], context=self)
        ctl.configuration.solve.models="0"

        # solve and save models
        models = []
        with ctl.solve(yield_=True) as handle:
            for model in handle:
                models.append(model.symbols(atoms=True))

        # capture output actions for renderer
        #action_list = []
        for func in models[0]: # only the first model
            prefix = func.name[:4]
            if prefix == "move" or prefix == "wait":
                action = func.name
                agent, timestep = func.arguments
                action_list.append((agent.number,action,timestep.number))

    #Popen(['python', './visualize.py', env_pkl, action_list])
    # call visualize - pass in env and action list

def dummy(self, env, actions):
    """
    a dummy method to mimic the behavior of main but with predefined actions
    """
    visualize.render(env,actions)


if __name__ == "__main__":
    #main(Flatland(), sys.argv[1:])
    print(sys.argv[1:])
    dummy(sys.argv[1:])





 # ------------------------------------------------------------------------------   
    #@staticmethod
    # def render(self, env, actions):
    #     """ call render function from visualize.py """
    #     process = Popen(['python', './visualize.py', env_pkl, action_list], stdout=PIPE, stderr=PIPE)
    #     stdout, stderr = process.communicate()
    #     # input: action_list
    #     # input: env.p