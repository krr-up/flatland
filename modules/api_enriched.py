import sys
import pickle
import io
from clingo.symbol import Number, Function
from clingo.application import Application, clingo_main
from modules.convert_enriched import convert_to_clingo
from modules.convert import convert_to_clingo as convert_to_clingo_basic
from modules.actionlist import build_action_list
import logging
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO, format='%(levelname)s -- %(name)s: %(message)s', filename='flatland_api.log', filemode='w')

class IncrementalFlatlandPlan(Application):
    """ takes an environment and a set of primary encodings """
    program_name = "flatland_incremental"
    version = "1.0"

    def __init__(self, env, actions=None, instance_lp=False):
        self.env = env
        self.actions = actions
        self.instance_lp = instance_lp
        self.action_list = None
        self.model = None
        self.stats = None

    def main(self, ctl, files):
        # add encodings
        for f in files: 
            print(f"Loading file: {f}")
            ctl.load(f)
        if not files:
            raise Exception('No file loaded into clingo.')
        
        # add env
        # add instance (LP override if provided)
        if self.instance_lp:
            ctl.add(self.instance_lp)
        else:
            ctl.add(convert_to_clingo(self.env))

        
        # add actions
        if self.actions is not None:
            print(f".join(self.actions): {' '.join(self.actions)}")
            ctl.add('base', [], ' '.join(self.actions))
        

        # ground the program
        ctl.ground([("base", [])], context=self)
        # ctl.configuration.solve.models="-1"

        max_time = ctl.symbolic_atoms.by_signature("global", 1)
        print(max_time)
        while True:
            try:
                atom = next(max_time)
                max_time = atom.symbol.arguments[0].number
                break
            except StopIteration:
                break
        if not max_time:
            raise Exception('No max_time defined in the encoding.')

        models = []
        min_time = 0 # int(max_time / 2)
        step = min_time  # start from half of max_time
        result = None
        while (result == None or result.unsatisfiable) and step < max_time:
            print(f"Incremental step: {step}")
            parts = []
            parts.append(("check", [Number(step)]))
            if step > min_time:
                query = Function("query", [Number(step - 1)])
                ctl.release_external(query)
                parts.append(("step", [Number(step)]))
            ctl.ground(parts, context=self)
            query = Function("query", [Number(step)])
            ctl.assign_external(query, True)
            symbolic_atoms = ctl.symbolic_atoms
            print(f"number of symbolic atoms: {symbolic_atoms.__len__()}")
            # for atom in symbolic_atoms.by_signature("speed_action", 4):
            #     print(atom.symbol)
            # for atom in symbolic_atoms.by_signature("car_state", 3):
            #    print(atom.symbol)
            for atom in symbolic_atoms.by_signature("car_arrived_by", 2):
                print(atom.symbol)
            # for atom in symbolic_atoms.by_signature("unlinked", 2):
            #    print(atom.symbol)
            for atom in symbolic_atoms:
                if atom.symbol.name in ["action", "state", "speed_action", "arrived"]:
                    logger.info(f"Time step {step} -- Atom: {atom.literal} Symbol: {atom.symbol}")
            handle = ctl.solve(yield_=True)
            for model in handle:
                models.append(model.symbols(atoms=True))

            result = handle.get()
            # model = handle.model()
            print(result)
            # if model:
            #     models.append(model.symbols(atoms=True))
            #     self.action_list = build_action_list(models)
            step += 1

        # # solve and save models
        # models = []
        # with ctl.solve(yield_=True) as handle:
        #     for model in handle:
        #         models.append(model.symbols(atoms=True))
        
        self.model = models[-1] if models else None
        print(f"Final model has {len(self.model)} symbols." if self.model else "No model found.")
        # capture output actions for renderer
        #return(build_action_list(models))
        self.stats = ctl.statistics
        self.action_list = build_action_list(models)
        print(f"Action list built with {len(self.action_list)} steps.")

class FlatlandPlan(Application):
    """ takes an environment and a set of primary encodings """
    program_name = "flatland"
    version = "1.0"

    def __init__(self, env, actions=None, instance_lp=False):
        self.env = env
        self.actions = actions
        self.instance_lp = instance_lp
        self.action_list = None
        self.model = None
        self.stats = None

    def main(self, ctl, files):
        # add encodings
        for f in files: 
            ctl.load(f)
        if not files:
            raise Exception('No file loaded into clingo.')
        
        # add env
        # add instance (LP override if provided)
        if self.instance_lp:
            ctl.add(self.instance_lp)
        else:
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
        
        self.model = models[-1] if models else None
        # capture output actions for renderer
        #return(build_action_list(models))
        self.action_list = build_action_list(models)

        self.stats = ctl.statistics


# let's see later whether we even need this
class FlatlandReplan(Application):
    """ takes an environment, a set of secondary encodings, and additional context """
    program_name = "flatland"
    version = "1.0"

