# Development Tips
Here are a few handy tips to help you while developing and debugging your code.  The following is information that Flatland provides during the simulation.  
These can be queried for debugging, or can be converted into facts for secondary ASP solving.

### step action

The step action is called once per time step and iterates the simulation.
When you call `_, rew, done, info = env.step(actions)`, if you print those four variables out, you will see something like the following:
``` 
rew:   {0: 0}
done:  {0: False, '__all__': False}
info:  {
        'action_required': {0: True},
        'malfunction': {0: 0},
        'speed': {0: 1},
        'state': {0: <TrainState.READY_TO_DEPART: 1>}
       }
```
* `rew` is a dictionary of the reward scores
  * the key represents the agent index
  * the value represents the score
* `done` is a dictionary of boolean statues marking whether the agents have reached their targets
  * the key represents the agent indices
  * the value represents whether the agent has reached its target
  * there is a special key called `__all__` which can be called to determine whether all agents have reached their targets
* `info` is a catch-all for other aspects of the simulation
  * `action_required` shopws whether an action is expected for a given agent
  * `malfunction` shows the number of remaining time steps an agent will be inactive (if it is 0, it is active)
  * `speed` shows the speed of each agent
  * `state` shows the state of each agent
    * `<TrainState.WAITING: 0>`
    * `<TrainState.READY_TO_DEPART: 1>`
    * malfunction (off map)
    * `<TrainState.MOVING: 3>`
    * `<TrainState.STOPPED: 4>`
    * malfunction (on map)
    * `<TrainState.DONE: 6>`
   
### agent information

At any given time step, you can call `env.agents` or `env.agents[x]` to return only agent `x` and find the following information:

```
[
EnvAgent(
  initial_position=(24, 6),
  initial_direction=0,
  direction=0,
  target=(6, 7),
  moving=False,
  earliest_departure=0,
  latest_arrival=30,
  handle=0,
  speed_counter=speed: 1
  max_count: 0
  is_cell_entry: True
  is_cell_exit: True
  counter: 0,
  action_saver=is_action_saved: False,
  saved_action: None,
  state_machine=
    state: TrainState.MOVING
    previous_state TrainState.MOVING 
    st_signals: StateTransitionSignals(
                  in_malfunction=False,
                  malfunction_counter_complete=True,
                  earliest_departure_reached=True,
                  stop_action_given=False,
                  valid_movement_action_given=True,
                  target_reached=False,
                  movement_conflict=False),
                  malfunction_handler=malfunction_down_counter: 0
                  in_malfunction: False
                  num_malfunctions: 0,
                  position=(15, 6),
                  arrival_time=None,
                  old_direction=0,
                  old_position=(16, 6))
] 
```

Any of those can be called directly, for example:
* `env.agents[0].target` would yield `(6, 7)`
* `env.agents[0].position` would yield `(15, 6)`

### environment information

To determine the layout of the environment, you can call `env.rail.grid`.  This will return a matrix of track ID values.  You can index it to find the track ID for a specific location, for instance of the current location of a train:
```
position = env.agents[0].position
env.rail.grid[position]

>>> 32800
```

