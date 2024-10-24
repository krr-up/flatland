import sys

from flatland.envs.rail_env import RailEnv
from flatland.envs.rail_env import RailEnvActions
from flatland.utils.rendertools import RenderTool, AgentRenderVariant

"""
run the simulation
"""


class SimulationManager():

    def __init__(self, env, primary, secondary=None):
        self.actions = []
        self.snapshots = []
        self.malfunctions = set()
        self.new_malfunctions = set()

        self.env = env
        self.primary = primary
        if secondary == None:
            self.secondary = primary
        else:
            self.secondary = secondary
        
    def _call_API(env, encoding, context=None) -> list:
        """
        calls the clingo API

        parameters
        ----------------
        env : str
            flatland environment
        encoding : str
            a pathfinding encoding
        context [optional]: str
            current state information (e.g. existing paths)

        returns -> list
        """
        pass

    def build_actions() -> None:
        """
        build self.actions for the first time by calling the clingo API

        parameters
        ----------------
        None

        returns -> None
        """
        self.actions = _call_API(self.env, self.primary)

    def _build_context() -> str:
        """
        when a malfunction occurs, convert the existing plans to alternative facts

        parameters
        ----------------
        
        returns -> str
        """
        pass

    def update_actions(timestep, actions) -> None:
        """
        update self.actions after receiving updated actions from subsequent calls to the clingo API

        parameters
        ----------------
        timestep : int
            the timestep where the actions are being changed  
        actions : list
            a list of updated action dictionaries

        returns -> None
        """
        context = _build_context()
        new_actions = _call_API(self.snapshots[-1], self.secondary, context)
        self.actions = self.actions[:timestep] # keep list up to current malfunction
        self.actions.append(new_actions)

    def add_new_malfunction(malf) -> None:
        """
        add a malfunction to the new_malfunction set

        parameters
        ----------------
        malf : int
            the index of the agent that is malfunctioning

        returns -> None
        """
        self.new_malfunctions.add(malf)
    
    def move_malfunction(malf) -> None:
        """
        remove a malfunction from the new_malfunction set and add it to the malfunctions set

        parameters
        ----------------
        malf : int
            the index of the agent that is malfunctioning

        returns -> None
        """
        self.new_malfunctions.remove(malf)
        self.malfunctions.add(malf)

    def remove_malfunction(malf) -> None:
        """
        remove a malfunction from the malfunctions set when the malfunction is expiring

        parameters
        ----------------
        malf : int
            the index of the agent that is done malfunctioning

        returns -> None
        """
        self.malfunctions.remove(malf)

    def convert_snapshot() -> str:
        """
        convert most recent snapshot to ASP facts
        
        parameters
        ----------------
        None

        returns -> str
        """
        pass

    
update_actions

#sys.argv[1:]

mgr = SimulationManager(env,primary,secondary)

actions = mgr.build_actions()

timestep = 0
while timestep < len(actions):
    """
    iterate through each set of actions in the list
    call env.step()
    for each agent, first determine whether there is a new malfunction
        if there is a new malfunction, add that agent to the new_malfunctions list
    """

    # call env.step() to execute the next step in the simulation
    obs, rew, done, info = env.step(mgr.actions[timestep])

    # check to see whether any agent is malfunctioning
    for a in range(env.get_num_agents()):
        if info['malfunction'][a] > 0: # if a is malfunctioning
            if a not in mgr.malfunctions: # if this is a new malfunction
                mgr.add_new_malfunction(a)
            
    # replan if there are new malfunctions
    if len(mgr.new_malfunctions) > 0:
        # move from new to existing malfunctions
        for train in mgr.new_malfunctions:
            mgr.move_malfunction(train)

        # capture context and call API to replan
        mgr.update_actions()

        # update actions list
        actions = mgr.actions

    # remove expiring malfunctions
    for a in range(env.get_num_agents()):
        if info['malfunction'][a] == 1:
            mgr.remove_malfunction(a)


# collect environment and encodings
    # environment
    # primary encoding
    # [optional] secondary encoding - if none use primary

