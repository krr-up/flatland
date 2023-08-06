# Attempt №1

## Background
My initial thought was to find paths by stringing together edges that matched—kind of like a game of dominoes.  This may be an approach I come back to, but in early group discussions, a different approach was put forth.  This approach comes after defining the environment, and serves to test whether this definition is hollistic and all-encompassing—or whether there are additional factors that should be considered.

## Overview of the approach
In each version of the approach, the encoding provides properties for the environment and start states for the trains (agents).  At the moment, there is only a single agent.  In creating a path for the agent, the first two cell locations, represented by `at()`, are always predetermined.  This is because the first location (at time = 0) is given in the encoding, and the second location (at time = 1) can be derived, since we know the direction the train is facing.  Its first move must always be forward.  The following version differ in how they determine the paths starting from the third move (at time = 2).

They are tested on an environment called `potsdam.lp` which is based on the track paths and stations found in the Potsdam area—from Werder(Havel) to Wannsee.

### Approach Version №1
A choice rule on the four cardinal directions (north, east, south, west) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal 

### Approach Version №2 — *current version*
> The motivation behind this is narrowing the scope of conceivable paths.  Since trains can never move backward, there is always one cardinal direction that can be ignored.  The drawback is the computational resources it takes to then derive where the train is—and whether it abides by the constraints.

A choice rule on the three possible directions a train can move (forward, left, right) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal 



### Approach Version №3
> The motivation behind this is narrowing the scope of conceivable paths.  Trains will never be faced with more than two decisions, as there no such switch exists that offers three options.  In the future, this could be expanded upon by removing tracks that contain no decision (leaving only switches) during the pathfinding step.

A choice rule on the two possible decisions a train can make (continue forward or follow the switch) assigns a single outcome per time step.  All conceivable paths are created, then integrity constraints eliminate paths that:
1. do not follow legal paths (i.e. trains go off of the tracks)
2. do not reach the goal 

---
