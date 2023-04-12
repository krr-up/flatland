# How to encode tracks in ASP

## Types of tracks
The rules of the flatland competition allow for eight types of cells:
![track possibilities](https://i.imgur.com/Q72tAI8.png)

## Possible paths
There is a larger space of possibile sets of paths, depending on the orientation of the cell.  In **Case 6**, for example, an agent (train) can travel
> * from down to the left
> * from down to the right

If this track is rotated 90º clockwise, then the possibilities become
> * from left to the top
> * from left to the bottom

There are two more unique rotations, leading to a total of four possible sets of paths.  **Case 3**, by contrast, only has one because regardless of the number of rotations, the set of paths will always be the same.

* **Case 0**: no path
* **Case 1**: 2 sets of paths
* **Case 2**: 4 sets of paths
* **Case 3**: 1 set of paths
* **Case 4**: 4 sets of paths
* **Case 5**: 2 sets of paths
* **Case 6**: 4 sets of paths
* **Case 7**: 4 sets of paths


## Possible approaches
Because of this complexity, there are several approaches to consider for how to encode this in ASP.  Agreeing on the most ideal approach would allow a generate to develop consistently-encoded environments.

<br>

### Case references
One potential approach would be to encode the location, track type (case), and orientation when defining the environment.
> `track(2,2, case(6,0))`

The above atom would represent a track at location `(2,2)` with a symmetrical switch oriented the same way as in the picture above.  The key is the case reference, which means that predefined offset paths would need to be included in every encoding.  Although, an intelligent generator might only choose to include relevant offset paths to reduce the grounding size—this is open for debate.

#### Reference atoms

`case(6,0)` might be referenced by the following
```
case(6,0) :- offset(-1,0, 0,-1)
case(6,0) :- offset(0,-1, 1,0)
offset(X1,Y1, X2,Y2) :- offset(X2,Y2, X1,Y1)
```
This would mean that a train currently at location `(2,1)` would have an eligible move to `(1,2)` or to `(3,2)`.

<br>

### Explicit paths
Another approach would be to explicitly define every set of paths—although for large environments this has the potential to become quite a large space.
