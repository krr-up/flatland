# Creating Transition Functions
As part of the overall effort of representing the flatland environment in ASP, transition functions play an important role. Unlike in a 4-connected or 8-connected grid map, the path that an agent can take is determined by the type of track occupying a cell.

![Track types](https://i.imgur.com/Q72tAI8.png)

<br><br>

For instance,
[example]

<br><br>
The first approach is to define possible transitions by generating path atoms.  Path atoms contain three pairs of coordinates: the origin, the passthrough, and the destination.  An important note: an agent will never have more than two options.

The creation of transition functions must occur in such a way that it can be broadly applied to all cases.  The number of different types of tracks, coupled with the various orientations the tracks can take on, results in a complex set of possibilities.


This document is an attempt at describing the logic behind the transition logic for each type.  Transition functions are determined by placing the track type at location `(0, 0)` of an imaginary grid world.  The orientation of each track type is designed to be consistent with the orientation of the agent as defined by the competition—i.e. if the agent is "facing one direction," then so is the track:
* Facing north: 0
* Facing east: 1
* Facing south: 2
* Facing west: 3

## Case 0: Empty
> There is no transition.

Cells of this case are thought of as having no track at all and therefore are not assigned transition functions, as agents cannot pass through them.


## Case 1: Straight
> Each orientation has two possible paths.

Body.

### Case 1a: Curve left

Body.

### Case 1b: Curve right

Body.


## Case 2: Simple switch
> Each orientation has four possible paths. 
> A track with an orientation of 0 is defined as a track that is oriented in such a way that an agent facing north (0) would have the choice of proceeding straight or traveling along the curve.

Here are the following transitions for a simple switch placed at `(0, 0)`:
* Orientation 0
    * `(0,-1)` → `(0, 0)` → `(0, 1)` (straight)
    * `(0,-1)` → `(0, 0)` → `(-1,0)` (curve)
* Orientation 1
    * `(-1,0)` → `(0, 0)` → `(1, 0)` (straight)
    * `(-1,0)` → `(0, 0)` → `(0, 1)` (curve)
* Orientation 2
    * `(0, 1)` → `(0, 0)` → `(0,-1)` (straight)
    * `(0, 1)` → `(0, 0)` → `(1, 0)` (curve)
* Orientation 3
    * `(1, 0)` → `(0, 0)` → `(-1,0)` (straight)
    * `(1, 0)` → `(0, 0)` → `(0,-1)` (curve)

> Note that the reverses of each of these also apply, resulting in four transitions per orientation, as previously stated.  However, this is not important in determining the logic, as a final line of code can be included which posits that for each transition, its reverse is also true.


In determining a base case that applies to all orientations, since all agents pass through `(0, 0)` in the second position, we only need to consider three coordinates:
* The origin
* The destination after traveling straight
* The destination after traveling along the curve

### Determining the relative coordinates of the origin

|D|f(x)|f(y)|
:---:|:---:|:---: 
|`0`|`0`|`-1`|
|`1`|`-1`|`0`|
|`2`|`0`|`1`|
|`3`|`1`|`0`|

Each of these is at heart an absolute value function, with some translation applied to it.
* $f(x) = |D-1| - 1$
* $f(y) = -1 \times |D-2| + 1$

These two functions can be used to produce the `(X, Y)` _relative_ coordinates of the origin cell based solely on the orientation, $D$.  In practice, the values when then be added to the values of the _absolute_ coordinates to find the true location.

### Determining the relative coordinates of the straight path

Let's take another look at the transitions for the straight path in each orientation:
* Orientation 0
    * `(0,-1)` → `(0, 1)`
* Orientation 1
    * `(-1,0)` → `(0, 1)`
* Orientation 2
    * `(0, 1)` → `(0,-1)`
* Orientation 3
    * `(1, 0)` → `(-1,0)`

The logic in this case is relatively straightforward.  In all cases, both coordinates can be multiplied by $-1$.

### Determining the relative coordinates of the curved path

Let's take another look at the transitions for the curved path in each orientation:
* Orientation 0
    * `(0,-1)` → `(-1,0)`
* Orientation 1
    * `(-1,0)` → `(0, 1)`
* Orientation 2
    * `(0, 1)` → `(1, 0)`
* Orientation 3
    * `(1, 0)` → `(0,-1)`

At first glance, the logic appears a bit more complicated. In all cases, the $x$ and $y$ coordinate values can be swapped—and this gets us closer.  But for orientations 1 and 3, the sign must flip; for the other orientations, the sign stays the same.  This can be achieved by multiplying the new $y$ value by $-1$ to flip the sign, as this value is always $0$ in the case of the even orientations and therefore no change will occur.

### Accounting for the inverse of these track layouts
To be continued.


### What this looks like in Clingo
```
path(|D-1|-1, -1*(|D-2|+1),  X, Y,   |D-2|+1,     |D-1|-1)  :- track(X,Y, 2,D). % transition for straight path
path(|D-1|-1, -1*(|D-2|+1),  X, Y,   |D-2|+1, -1*(|D-1|-1)) :- track(X,Y, 2,D). % transition for curved path
path(X0,Y0, X1,Y1, X2,Y2) :- path(X2,Y2, X1,Y1, X0,Y0). % reverse transitions also apply
```



## Case 3: Diamond crossing
> Each orientation has four possible paths.  However, these paths are the same regardless of orientation.

Body.


## Case 4: Single slip switch

Body.


## Case 5: Double slip switch

Body.


## Case 6: Symmetrical switch
> Each orientation has four possible paths.  This is very similar to Case 2.

Body.


## Case 7: Deadend
> Each orientation has one possible path: back from where the agent came.

Body.
