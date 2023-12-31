# Open questions

Terms:
* `action_dict`
* `observations`
* `next_obs`
* `action_space`

---

### `action_dict`
This appears to be a dictionary that sotres the `agent_id` as the key and a corresponding `action` numeral as the value. It is valid at one time step and should be updated for each time step.

**Apperances:**
```
 76 action_dict = dict()

 78 for agent_id in agents_with_same_start:
 79     action_dict[agent_id] = 1  # Try to move with the agents

 81 # Do a step in the environment to see what agents entered:
 82 env.step(action_dict)

125 # Chose an action for each agent
126 for a in range(env.get_num_agents()):
127     action = controller.act(0)
128     action_dict.update({a: action})

129 # Do the environment step
130 observations, rewards, dones, information = env.step(action_dict)
```

The valid actions in the environment are:

* `1`: turn left at switch and move to the next cell; if the agent was not moving, movement is started 
* `2`: move to the next cell in front of the agent; if the agent was not moving, movement is started
* `3`: turn right at switch and move to the next cell; if the agent was not moving, movement is started
* `4`: stop moving

---
### `observations`

```
130 observations, rewards, dones, information = env.step(action_dict)

157 for step in range(200):
158     # Chose an action for each agent in the environment
159     for a in range(env.get_num_agents()):
160         action = controller.act(observations[a])
161         action_dict.update({a: action})
        …
174     # Update replay buffer and train agent
175     for a in range(env.get_num_agents()):
176         controller.step((observations[a], action_dict[a], all_rewards[a], next_obs[a], done[a]))
        …
179     observations = next_obs.copy()
```

`controller.act()` is defined as such:
```
def act(self, state):
        """
        :param state: input is the observation of the agent
        :return: returns an action
        """
        return np.random.choice([RailEnvActions.MOVE_FORWARD, RailEnvActions.MOVE_RIGHT, RailEnvActions.MOVE_LEFT,
                                 RailEnvActions.STOP_MOVING])
```

---
### `next_obs`

```
166 next_obs, all_rewards, done, _ = env.step(action_dict)

174     # Update replay buffer and train agent
175     for a in range(env.get_num_agents()):
176         controller.step((observations[a], action_dict[a], all_rewards[a], next_obs[a], done[a]))
        …
179     observations = next_obs.copy()
```

---

* Is there any way to prevent a train from disappearing once it reaches its goal?
* How does `done['__all__']` work? — how does something get assigned done?

