# How the `solve.py` file works

The solve file contains a simulation manager, which is responsible for bridging the gap between clingo and Flatland, as well as for executing the steps of the Flatland simulation.

In short, the file:
* takes as input
  * an environment
  * a primary encoding
  * (optionally) a secondary encoding
* calls the encoding on the given environment via the clingo API
  * receives a list of actions as output
* iterates over the list of actions
  * checks whether a new malfunction has occurred
  * calls the clingo API again if necessary to determine a new set of actions
* renders a visualization of the solution
* outputs a log file

---

## Simulation Manager

The `SimulationManager()` class has the following global attributes:
* `env`, the Flatland environment which is given as input
* `primary`, the primary encoding which is given as input
* `secondary`, the secondary encoding which is optionally given as input
  * if no input is given, it defaults to `primary`
* `actions`, a list of action dictionaries
* `snapshots`, a list of chronologically-saved instances of the environment
* `malfunctions`, a list of current malfunctions
* `new_malfunctions`, a list of malfunctions that have occurred in the current time step

---

## Procedure
1. A `mgr = SimulationManager()` object is created, in which an environment and encodings are given as inputs
2. The `mgr` object calls `actions = build_actions()` to construct the initial list of action dictionaries based on `env` and `primary`
3. A `while` loop iterates through each item in the `actions` list and calls the Flatland function `env.step()`
    1. Information is collected about the new state of `env` after incrementing the simulation by one time step
    2. The information is checked for malfunctions
        1. If a new malfunction has occurred, it will be added to the `new_malfunctions` list as a tuple `(train, duration)`
        2. If there are items in the `new_malfunctions` list
            1. the `mgr.update_actions()` function is called, which invokes the clingo API again, calling the `env` and `secondary`, as well as some additional constraints to receive a new list of actions
            2. the malfunctions in `new_malfunctions` are moved over to the `malfunctions` list
    3. The duration of each malfunction in `malfunctions` is decreased by one
4. Once the simulation is finished (when all trains reach their targets or the time limit has been reached), a `.gif` file is rendered and an output file is saved
