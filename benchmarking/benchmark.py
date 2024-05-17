import sys
import os.path
import io
from json import dumps
from clingo.symbol import Number
from clingo.application import Application, clingo_main
from clingo.control import Control

class Flatland(Application):
    program_name = "flatland"
    version = "1.0"

    def __init__(self, action_list, env):
        self.action_list = action_list
        self.env_pkl = env


    def main(self, ctl, files):
        # parse through files
        for f in files:
            ctl.load(f)
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
        with open(f"output.txt", "w") as f:
            f.write(dumps(ctl.statistics['summary']['times'], sort_keys=True, indent=4, separators=(',', ': ')))


if __name__ == "__main__":
    app = Flatland([], None)
    clingo_main(app, sys.argv[1:])