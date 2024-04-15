# Generate Paths

This is the combination of two steps:
1. Calling pathfinding encodings
2. Rendering a visual animation

The encodings that are included must return a set of actions, corresponding to each time step for each agent.  This information is passed into Flatland and from there, an animation is produced.  Additionally, output messages are shared, which include:
* performance statistics, such as solving time and makespan
* error messages, if necessary
* a summary of the agents' plans
