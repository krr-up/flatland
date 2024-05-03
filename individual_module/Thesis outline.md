# Preparing for the thesis

* Make it more general
* For specific parts, specify "what is expected" (e.g. a `.json` file)
* Provide an example of an implementation

The pipeline comprises three levels:
1. The environment generation
2. The pathfinding
3. The visualization

Levels 1 and 3 use resources that are provided by Flatland, and for that reason, certain formats are expected and therefore non-negotiable.  Level 2, as well as the specific methods of bridging the levels together, is the prerogative of the end user.  Here, we provide a theoretical overview of what such a framework might be, and further provide a concrete implementation.  This implementation itself is free to be modified or expanded.

First question: what information does Flatland provide when we generate an environment?  Which pieces of information are necessary (subjective question, perhaps)?

Second question: how can this environment be represented:
* as a grid of cells, which is basically a one-to-one mapping from the environment
* as a graph where the cells are represented by vertices and the direction of the agent is always preserved
* as a hypergraph in which sets of three connected cells are represented by a single edge, which implicitly represents the direction of a traveling agent
    * show why combinatorially this was not ideal in my implementation of clingo
* ? another alternative, cited from a paper that actually moves the environment beneath it
* as a modification of the aforementioned approaches in which long straight edges are reduced to a single edge with a weight

---

Introduction
* Information about Flatland and MAPF
* What is the goal of this paper?
    * To create a generalized, modular, and expandable framework that connects Flatand to ASP in order to generate solutions to the problem

    
---

## How to

Flatland was written in Python and therefore works fairly seamlessly when writing solutions in Python.  **FlatlandASP** was written to provide a fluid interface between Flatland and Clingo.  Here's how it works!

Flatland can generate environments and visualize the movement of trains in those environments.  You are responsible for developing the pathfinding mechanism that determines how trains navigate each environment.

Overall, there are three steps:
1. Generation
2. Pathfinding
3. Visualization

In Step #1, Flatland generates environments.  You can specify certain parameters such as the size and density.  Those environments are saved offline so they can be used later.  The environments are saved in two formats: `.lp` and `.pkl`.  Additionally, an image of the environment is saved for your reference.

In Step #2, the developer takes as input the environment in the format of a `.lp` file.  This `.lp` file contains a fact-based representation of the environment that is compatible with Clingo.  Each cell in the environment is represented by a fact of the following format: `cell((X,Y), Type)`. For example, `cell((7,9), 32800)` indicates that at coordinate `(7,9)`, a cell of type `32800` is present.  These cell type numbers indicate both the cell type and the orientation, and are consistent with the internal identification scheme that Flatland uses.  A list of cell types can be found **here**.  Cell `(0,0)` starts in the lower lefthand side of the grid.

Also contained within the `.lp` file is information about the agents, their starting positions and directions, and their end positions (destinations).  An agent is identified by a numerical integer, such as `agent(1)`.  It's starting position is represented by a `start` fact, such as `start(agent(2), cell(6,17), dir(e))`, which indicates that agent #2 starts at cell `(6,17)` facing east.  Its end position is represented by an `end` fact, such as `end(agent(2), cell(8,5))`, which indicates that agent #2 should end at cell `(8,5)`.  There is no specification about which direction it should be facing when it reaches the destination.  At the moment, no maximum time horizon is provided.  This can be provided with a heuristic algorithm or manually, but is ultimately the responsibility of the developer.

In Step #3, the output that is generated in the previous step is combined with the `.pkl` file representation from the first step to produce an animation of the trains in the environment.  The output that the Flatland visualizer expects is a set of actions: one for each agent at each time step.  It expects these actions to be in a list with items that contain information about the agent, the action, and the time step.  For instance, `action(2,wait,25)` conveys the information that agent #2 is to wait in place at time step 25.  The visualizer will render an image of the current status of the environment at each time step and render them all together into a single video file.

It is worth noting that there is a quirky quality about Flatland, when it comes to assigning actions.  All agents start off "outside of" the environment—effectively their locations are set to `NULL`.  The first action, regardless of what it is, instantiates the agent at its starting location.  This means that a "dummy action" is required first, otherwise it will give the appearance that the train is running behind by one time step, and may in some cases lead to rendering issues if it encounters an illegal action.


Some things to do before finishing the writing for this section:
* Allow the user to specify all parameters for customizing the environment
* Allow the user to generate multiple environments at once
* Determine how the data flow is going to call the environment and sync it later on with its corresponding `.pkl` file
* Determine the most basic generalization for this data flow


## One implementation

Here is one example of an ASP-coded solution that determines paths for all agents in an environment.  The example is not designed for efficiency and, because of a swap conflict, is sub-optimal.  This is a design choice to mimic real-world safety regulations about minimal distance between two trains.

The implementation is separated into three components:
1. `transitions.lp` a reference file that provides information about which transitions are legal for given track types
2. `encoding.lp` a general Clingo encoding that generates possible paths and imposes constraints to eliminate illegal candidates such as plans in which two oncoming trains are set to collide
3. `actions.lp` a set of logic that observes the chosen plan and identifies the appropriate action for each agent that Flatland would accept at that time step


### transitions.lp

Flatland paths differ from other MAPF paths in that agents are bound to the existing track infrastructure.  This file serves as a reference for the encoding to enforce legal movements.  An illegal movement would be one in which, for example, the train is traveling along a straight track, yet it wants to make a left turn.

Primarily, this file encodes information about legal transitions for each possible track type.  Consider track type `32800`, a straight track that connects the cell to its north with the cell to its south.  The file contains the following information:
> `transition(32800, (s,f)).`	`transition(32800, (n,f)).`

In short, what this represents is that when an agent is present on a cell of this type:
* if it is facing south, it can move forward
* if it is facing north, it can move forward

Outside of waiting, no other legal movement is permitted.  This file is a critical bridge between the output from the environment generator and the primary encoding.  In the output from the environment generator, each cell is assigned a track type.  The `transitions.lp` file then informs the encoding of which transitions are legal at that location.  Information about legal transitions exists for every track type available in Flatland.

The file also provides a crucial reference for the resulting direction of an agent after choosing an action.
> `offset((e,r), ( 0,-1), s).`

This reads that if an agent is facing east and decides (legally) to move to the right, then its resulting position will change in units by 0 along the x-axis and by -1 along the y-axis, and will face south.  Information about offsets exists for every possible combination of direction and chosen action.

The file also provides ancilliary information about cardinal directions (north, south, east, west) and legal actions (forward, left, right, wait).