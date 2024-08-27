# 1. Read in environment facts
# 2. Load MAPF encoding and run to determine actions
# 3. Construct action dictionaries for the environment
# 4. Begin simulation
    # IF no breakdown, execute plan
    # ELSE pass breakdown information to secondary encoding, return to step 3


class Flatland(Application):
    """
    loads and stores the raw environment and encoding files, and leverages the 
    capabilities of clingo to combine, ground, and solve facts from within those files
    """
    program_name = "flatland"
    version = "1.0"

    def __init__(self, env, mapf, malf) -> None:
        pass

    def ground_mapf():
        """
        standard grounding procedure to determine the initial plan
        """
        models = []
        return models

    def ground_malf(snapshot):
        """
        modified grounding procedure following a malfunction
        follows different specified logic and considers the current
        state (snapshot) of the environment
        """
        models = []
        return models


class PlanHandler():
    """
    stores the current implementation of a plan and provides a
    translation to Flatland actions when it is time to execute the plan
    """
    def __init__(self) -> None:
        pass

    def act():
        pass


# Simulator Script
"""
controls the logic flow between the Application Class and
the Plan Handler

responsible for executing a plan, detecting malfunctions,
visualizing outputs, and logging activity

* the encodings and selected environment files are loaded
* solving provides an initial plan, which can be represented as a list of actions,
* and is stored in the Plan Handler
* the execution loop begins, and appropriate Flatland actions are identified 
  by the Plan Handler, depending on the agent and time step
* if a malfunction is detected, the current information is passed to the secondary
  malfunction resolution encoding
* a revised plan, which can be represented as a new list of actions, 
  replaces the plan stored in the Plan Handler
* the loop resumes at the current time step according to the revised plan
* if a new malfunction is detected, the process repeats itself
* the loop ends once all agents have reached DONE, or once time has run out
"""
def main():
    images = []
    log = []

    while not done['__all__']:
        obs, rewards, done, info = env.step(action_dict)

        if done['__all__'] == True:
            break 

if __name__ == "__main__":
    pass