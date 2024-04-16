import sys
import os.path
import re
from subprocess import Popen, PIPE
from clingo.application import Application, clingo_main

class Flatland(Application):
    program_name = "flatland"
    version = "1.0"

    env_pkl = ""
    action_list = []

    def main(self, ctl, files):

        # load files
        for filepath in files: 
            if os.path.splitext(filepath)[1] == '.lp':
                ctl.load(filepath)
            if re.search('(env_\d+)', filepath):
                print(True)
                # find files within env folder
                x = re.search('(env_\d+)', filepath)
                env = filepath[x.start():x.end()]
                env_pkl = filepath + "/{}.p".format(env)
                env_lp = filepath + "/{}.lp".format(env)
                ctl.load(env_lp)

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

    Popen(['python', './visualize.py', env_pkl, action_list])
      

if __name__ == "__main__":
    clingo_main(Flatland(), sys.argv[1:])






 # ------------------------------------------------------------------------------   
    #@staticmethod
    # def render(self, env, actions):
    #     """ call render function from visualize.py """
    #     process = Popen(['python', './visualize.py', env_pkl, action_list], stdout=PIPE, stderr=PIPE)
    #     stdout, stderr = process.communicate()
    #     # input: action_list
    #     # input: env.p