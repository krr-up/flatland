import sys
import pickle
import io
from clingo.symbol import Number
from clingo.application import Application, clingo_main
from modules.convert import convert_to_clingo
from modules.actionlist import build_action_list

class FlatlandPlan(Application):
    """ takes an environment and a set of primary encodings """
    program_name = "flatland"
    version = "1.0"

    def __init__(self, env, actions):
        self.env = env
        self.actions = actions
        self.action_list = None

    def main(self, ctl, files):
        # add encodings
        for f in files: 
            ctl.load(f)
        if not files:
            raise Exception('No file loaded into clingo.')
        
        # add env
        ctl.add(convert_to_clingo(self.env))
        
        # add actions
        if self.actions is not None:
            print(f".join(self.actions): {' '.join(self.actions)}")
            ctl.add('base', [], ' '.join(self.actions))
        
        # ground the program
        ctl.ground([("base", [])], context=self)
        ctl.configuration.solve.models="-1"

        # solve and save models
        models = []
        with ctl.solve(yield_=True) as handle:
            for model in handle:
                models.append(model.symbols(atoms=True))

        # capture output actions for renderer
        #return(build_action_list(models))
        self.action_list = build_action_list(models)


# let's see later whether we even need this
class FlatlandReplan(Application):
    """ takes an environment, a set of secondary encodings, and additional context """
    program_name = "flatland"
    version = "1.0"

