# File documentation

Below are details of the files necessary for running an instance of Flatland in Clingo, as well as an explanation of each type of atom that appears in the files.

## `test_env.lp`
> the file that defines an enviroment instance and its associated parameters

* `cell((X,Y), Type)` the location of a cell in the environment and its type
* `maxTime(T)` the maximum number of time steps allowed in the sequence
* `agent(1..N)` the agents in the environment
* `start(agent(A), cell(X,Y), dir(D))` the starting position and direction for an agent
* `end(agent(A), cell(X,Y))` the goal position for an agent

## `transitions.lp`
> the reference file that controls allowable movement of agents within the environment

* `move(M)` all allowable moves by an agent (i.e. forward, left, right, wait)
* `dir(D)` all possible directions (i.e. north, east, south, west)
* `type(Type, (D,M))` all possible transitions for a given track type and an agent direction
* ? `nochoice(Type, D)`
* `offset((D,M), (Dx,Dy), D')` the resulting one-cell offset for any transition (e.g. one cell to the right is `(1,0)`) and its resulting direction

## `class.lp`
> the file that provides an abstracted view of the environment by assigning classes to tracks, and reduces the possible choices for a given class

* `class((X,Y), Class)` the class of track at a given cell
* `class_action(Class, M)` the allowable actions for a given class

## `actions.lp`
> !


## `encoding.lp`
> !
