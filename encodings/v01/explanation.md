# Version 01: pathfinding with choice rules

## Background
My initial thought was to find paths by stringing together edges that matched—kind of like a game of dominoes.  This may be an approach I come back to, but in early group discussions, a different approach was put forth.  This approach comes after defining the environment, and serves to test whether this definition is hollistic and all-encompassing—or whether there are additional factors that should be considered.

## Overview of the approach
In each version of the approach, the encoding provides properties for the environment and start states for the trains (agents).  At the moment, there is only a single agent.  In creating a path for the agent, the first two cell locations, represented by `at()`, are always predetermined.  This is because the first location (at time = 0) is given in the encoding, and the second location (at time = 1) can be derived, since we know the direction the train is facing.  Its first move must always be forward.  The following version differ in how they determine the paths starting from the third move (at time = 2).

They are tested on an environment called `potsdam.lp` which is based on the track paths and stations found in the Potsdam area—from Werder(Havel) to Wannsee.

![Potsdam environment](potsdam.png)

### Version 01a
A choice rule on the four cardinal directions (north, east, south, west) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal 

### Version 01b (implemented)
> The motivation behind this is narrowing the scope of conceivable paths.  Since trains can never move backward, there is always one cardinal direction that can be ignored.  The drawback is the computational resources it takes to then derive where the train is—and whether it abides by the constraints.

A choice rule on the three possible directions a train can move (forward, left, right) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal

### Version 01c (theoretical)
> The motivation behind this is narrowing the scope of conceivable paths.  Trains will never be faced with more than two decisions, as there no such switch exists that offers three options.  In the future, this could be expanded upon by removing tracks that contain no decision (leaving only switches) during the pathfinding step.

A choice rule on the two possible decisions a train can make (continue forward or follow the switch) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal 

---

Notes from meeting on `2023.08.10`

* In the formalization, I've established G as a grid and C as a set of cells, but I haven't really used them so, do we need them?
* The Greek letters are probably not necessary in this first case — for orientation we could use o for orientation, d for direction, c for cardinal direction, etc.
* Maybe we don't need type × orientation × flip — can we just define separate types? 1a, 1b, 2a, 2b, 2c, etc.
* <u>Big point</u>: the cells (and therefore the edges) and edges as defined in the formalization are not the same as the instance of `potsdam.lp`
  * It's probably a good idea to have an instance that reflects how the cells are defined, and then a separate encoding (Python?) that creates the edges based on their track types and orientations, etc.
* We should dummy-proof the instances by defining certain things that they can't be
  * The cell cannot go off of the track
  * The goal/start points must be different
* Get rid of the optimization statement to see how things change
* We should split up the instance probably into multiple files (depending on how Flatland does it)
  * For instance the environment and then where the trains are, what the start/end points are
* If the constraint in Approach Ver. 2 is cubic and causing a big problem (negative edge), then we may need to abandon this action-choice-rule approach and guess on the edge to build out the paths
* Be curious in exploring other methods — Klaus? has a new method that simply guesses paths, and if an agent happened to be there, then it keeps it, which decouples it from some of the complexity
* We can choose recursive or non-recursive methods
  * Problem with recursive is cyclic paths are forbidden (will this be a problem for us?) but we can use waypoints to solve this
