## Files

* `test_env.lp` a small environment for testing simple scenarios
* `types.lp` a reference file describing possible transitions per track type
* `encoding.lp` logic that computes valid paths
* `actions.lp` the new file that converts a path (solution from `encoding.lp`) into a sequence of Flatland actions

**Note**: the logic contained within `types.lp` has changed.  In former attempts, a cell was described by its type and rotation, e.g. `cell((1,0), (21,270))`, but is now described by its unique ID, e.g. `cell((1,0), 3089)`.  This is more consistent with how Flatland identifies its tracks.


# Attempt 6

`Attempt 5` had the goal of creating a full pipeline in which:
* environments could be generated using Flatland resources
* solutions could be calculated using Clingo
* paths could be visualized using Flatland resources

Although the full pipeline had not yet be completed, a few pieces of feedback were given on its entire structure:
1. More of the logic could be written in Clingo, leading to less reliance on Python
2. The environment generation could be handled in a separate flow—so a large batch of environments could be generated and saved for the encoding, and more could generated on-demand if needed
3. A back-end architecture could handle most of the performance, such as by saving outputs to `.lp` files and calling them through Clingo from the start, meaning Python would only be required near the end to call the Flatland visualizer
4. Troubleshoot through existing syntax errors that are preventing the pipeline from reaching completion
5. Successfully create a visualization using Flatland


## More Clingo logic
One specific piece that should first be transferred from Python to Clingo is the **subsequent action logic**.  The Clingo encoding returns as a solution a path through the environment, but Flatland requires a sequence of actions.

In order to do this conversion, the logic must first be well documented and understood.  In creating an exhaustive list of possible scenarios at any pair of time steps `T₀` and `T₁`, the following variables must be considered:
* the cell type at `T₀`, _{switch, non-switch}_
* whether the train is moving or stationary (whether the cell at `T₀` differs from the cell at `T₁`), _{stationary, moving}_
* the change in orientation from `T₀` to `T₁`, _{0º, 90º, 180º}_

This yields 12 possible combinations, of which 5 are invalid and can be immediately discarded.  The following table shows the appropriate action in each of the remaining valid scenarios:
| Type | Movement | Orientation | Action |
| ---- | -------- | ----------- | ------ |
| non-switch | stationary | 0º | `STOP_MOVING` |
| switch | stationary | 0º | `STOP_MOVING` |
| switch | moving | 90º | `MOVE_LEFT` / `MOVE_RIGHT` |
| non-switch | moving | 0º | `MOVE_FORWARD` |
| non-switch | moving | 90º | `MOVE_FORWARD` |
| non-switch | stationary | 180º | `MOVE_FORWARD` |
| switch | moving | 0º | `MOVE_FORWARD` |

Two notes:
1. `MOVE_LEFT` occurs when the rotation is -90º, whereas `MOVE_RIGHT` occurs when the rotation is +90º
2. `MOVE_FORWARD` only results in a 180º rotation when the cell at time step `T₀` is a dead end

### Examples in Clingo

`STOP_MOVING`
The atom fires for a time step if the location and orientation remain the same.  There is a provision for ensuring the time steps are consecutive.
```
% path
at(cell(0,0),0,e).
at(cell(1,0),1,e).
at(cell(1,1),2,n).
at(cell(1,1),3,n).
at(cell(2,1),4,e).

#show stop_moving(T0) : at(C,T0,D), at(C,T1,D), T1-T0=1.
```
Here we would see `stop_moving(2)` as this would be the appropriate action for the train to take, as the conditions during time step 3 are identical to those in time step 2.
