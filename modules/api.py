import sys
import pickle
import io
# from clingo.symbol import Number
from clingo.application import Application, clingo_main
from modules.convert import convert_to_clingo
from modules.actionlist import build_action_list, build_context_from_save
from clingo import Number, String, Function

class FlatlandPlan(Application):
    """ takes an environment and a set of primary encodings """
    program_name = "flatland"
    version = "1.0"

    def __init__(self, env, actions, supress_env=False):
        self.env = env
        self.actions = actions
        self.action_list = None
        self.save_context = None
        self.supress_env = supress_env
        self.stats = None

    def get(self, val, default):
        return val if val != None else default

    def main(self, ctl, files):
        ctl.configuration.solve.models="-1"
        # add encodings
        for f in files: 
            ctl.load(f)
        if not files:
            raise Exception('No file loaded into clingo.')
        
        # add env
        if not self.supress_env:
            ctl.add(convert_to_clingo(self.env))
        
        # add actions
        if self.actions is not None:
            # print(f".join(self.actions): {' '.join(self.actions)}")
            ctl.add('base', [], ' '.join(self.actions))
        
        imin   = self.get(ctl.get_const("imin"), Number(0))
        imax   = ctl.get_const("imax")
        istop  = self.get(ctl.get_const("istop"), String("SAT"))

        step, ret = 0, None
        models = []
        while ((imax is None or step < imax.number) and
            (step == 0 or step < imin.number or (
                (istop.string == "SAT"     and not ret.satisfiable) or
                (istop.string == "UNSAT"   and not ret.unsatisfiable) or 
                (istop.string == "UNKNOWN" and not ret.unknown)))):
            parts = []
            parts.append(("check", [Number(step)]))
            if step > 0:
                ctl.release_external(Function("query", [Number(step-1)]))
                parts.append(("step", [Number(step)]))
            else:
                parts.append(("base", []))
            ctl.ground(parts)
            ctl.assign_external(Function("query", [Number(step)]), True)
            with ctl.solve(yield_=True) as handle:
                for model in handle:
                    models.append(model.symbols(atoms=True, terms=True))
                ret = handle.get()
            step += 1

        self.stats = ctl.statistics
        # capture output actions for renderer
        #return(build_action_list(models))
        self.action_list = build_action_list(models)
        self.save_context = build_context_from_save(models)


# let's see later whether we even need this
class FlatlandReplan(Application):
    """ takes an environment, a set of secondary encodings, and additional context """
    program_name = "flatland"
    version = "1.0"

