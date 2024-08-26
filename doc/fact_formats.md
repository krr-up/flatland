# Fact formats

Although individual ASP developers are free to follow approaches of their choosing, certain consistencies must be maintained in order to be compatible with this framework.  Namely, a representation of the environment will have facts about cells and agents as shown below in the **environment representation**.  The output of pathfinding encodings must match the corresponding **behavior representation** in order to operate as expected with the Flatland visualizer.

<br>

## Environment representation
Input from Flatland environments into ASP encodings.

### Cells
> Cells correspond to tiles in the Flatland grid.  Each has an (X,Y) coordinate and a track type, based on the internal Flatland ID representation, which captures both the cell type and orientation in a single value.

`cell((Y,X), Track).`

**Allowable values** for `Track` correspond to the ID values found in [this file](https://github.com/krr-up/flatland/blob/0f07de90ce56c90ea9b9ae8fb02f1b2ea1d417eb/doc/track_types.pdf).

### Agents
> Agents are defined by where they start and where they end.  Their starting positions are also characterized by corresponding starting directions.  Agents have no specified direction they must face upon reaching their destinations.

`start(ID, (Y,X), D). end(ID, (Y,X)).`

**Allowable values** for `D` are the cardinal directions—east, west, north, south:
`e` `w` `n` `s`

<br>

## Behavior representation
Output from ASP encodings into the Flatland visualizer.

### Actions
> Since Flatland resolves environments using sets of actions at time points (as opposed to paths), the output must be agent-specific actions.

`action(train(ID), Action, Timestep).`

**Allowable values** for `Action` correspond to the permissible actions in Flatland itself:
`move_forward` `move_left` `move_right` `wait`
