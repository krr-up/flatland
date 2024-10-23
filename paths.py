import sys
import os.path
import pickle
import io
from clingo.symbol import Number
from clingo.application import Application, clingo_main
from modules.convert import convert_to_clingo
from modules.visualize import render
from modules.actionlist import build_action_list

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
                ctl.add(env_lp)
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
        self.action_list = build_action_list(models)


if __name__ == "__main__":
    app = Flatland([], None)
    clingo_main(app, sys.argv[1:])
    print(app.action_list) #debug
    #render(app.env_pkl, app.action_list)