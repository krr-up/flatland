import sys
import os.path
import pickle
from clingo.symbol import Number
from clingo.application import Application, clingo_main
from modules.create_environments.convert import convert_to_clingo
from modules.generate_paths.visualize import render

class Flatland(Application):
    program_name = "flatland"
    version = "1.0"

    def __init__(self, action_list, env):
        self.action_list = action_list
        self.env_pkl = env


    def main(self, ctl, files):
        # parse through files
        for f in files: 
            if os.path.splitext(f)[1] == '.lp':
                ctl.load(f)
            if os.path.splitext(f)[1] == '.pkl':
                self.env_pkl = pickle.load(open(f, "rb"))
                env_lp = convert_to_clingo(self.env_pkl)
                #ctl.load(env_lp)
                #ctl.load('generate_paths/test.lp')
        if not files: ctl.load("-")
        
        # ground the program
        ctl.ground([("base", [])], context=self)
        ctl.configuration.solve.models="1"

        # solve and save models
        models = []
        with ctl.solve(yield_=True) as handle:
            for model in handle:
                models.append(model.symbols(atoms=True))

        # capture output actions for renderer
        action_list = []
        for func in models[0]: # only the first model
            prefix = func.name[:6]
            if prefix == "action":
                #action = func.name
                action = func.arguments[1].name
                #print("arguments: ", func.arguments)
                agent, timestep = func.arguments[0], func.arguments[2]
                self.action_list.append((agent.number,action,timestep.number))


if __name__ == "__main__":
    app = Flatland([], None)
    clingo_main(app, sys.argv[1:])
    render(app.env_pkl, app.action_list)