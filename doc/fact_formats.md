# Fact formats

## Environment representation

### Cells
> Cells correspond to tiles in the Flatland grid.  Each has an (X,Y) coordinate and a track type, based on the internal Flatland ID representation, which captures both the cell type and orientation in a single value.

`cell((X,Y), Type).`

### Agents
> Agents are defined by where they start and where they end.  Their starting positions are also characterized by corresponding starting directions.  Agents have no specified direction they must face upon reaching their destinations.

`start(agent(A), (X,Y), dir(D)). end(agent(A), (X,Y)).`

The following directions for `D` are allowed:

`e` `w` `n` `s`

### Actions
> Since Flatland resolves environments using sets of actions at time points (as opposed to paths), the output must be agent-specific actions.

`action(agent(A), Action, Timestep).`

The possible values for `Action` correspond to the permissible actions in Flatland itself:

`move_forward` `move_left` `move_right` `wait`
