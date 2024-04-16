import sys
import os.path
import pickle
from clingo.symbol import Number
from clingo.application import Application, clingo_main
from create_environments.convert import convert_to_clingo

# env metadata
env_pkl = None

class Flatland(Application):
    program_name = "flatland"
    version = "1.0"

    def main(self, ctl, files):
        for f in files: 
            if os.path.splitext(f)[1] == '.lp':
                ctl.load(f)
            if os.path.splitext(f)[1] == '.pkl':
                env_pkl = pickle.load(open(f, "rb"))
                env_lp = convert_to_clingo(env_pkl)
                ctl.load(env_lp)
                ctl.load('generate_paths/test.lp')
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

if __name__ == "__main__":
    clingo_main(Flatland(), sys.argv[1:])