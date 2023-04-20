# flatland

## Goal: ASP and the flatland environment
`2023.03.30` The first goal of the project is to successfully work through the flatland environment and map it to ASP prior to the start of the project module classes.  There are three milestones:
1. Generative encoding
2. Solution encoding
3. Visualization module

### Generative encoding
Flatland creates environments by taking several parameters—the size of the environment, the number of trains, the number of cities, etc.  Our first goal should be to create an ASP encoding that takes the same parameters and creates a flatland environment as facts.  This will enable solution encodings to solve flatland problems.

### Solution encoding
The second encoding should analyze the facts that represent the environment and develop a solution.  Ideally the solution gets each train from its start point to its end point without crashing and in as quickly a manner as possible.  Initially, getting trains from start to finish will be the focus, then introducing constraints to provent collisions, and finally minimizing wait times will come last.

### Visualization module
A way to visualize the solution encoding (in a manner similar to what flatland has provided) will help both with troubleshooting and with understanding generally the approach that a solution encoding has taken.

>💡 Will this require mapping the solution output to Python, in such a way that the existing flatland visualization environment can understand it?

---

## Pre-class update
`2023.04.20`

### Retaining agent orientation
It is likely that we will need to retain at each time step the orientation of the train.  There are a few reasons for this:
1. This is consistent with the approach that flatland uses
2. The given actions are relative to the direction of the train (i.e. move forward, turn left, turn right), not absolute instructions (e.g. move west, move east)
3. There are many variations on the existing cases (type of track—switch, crossing, etc.) depending on their orientation, and this will be necessary for transitions (i.e. a path over the course of at least three time steps: where it comes from, where it is now, and where it's going)
