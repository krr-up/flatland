"""
run the simulation
"""

# collect environment and encodings
    # environment
    # primary encoding
    # [optional] secondary encoding - if none use primary

# determine the initial proposed paths for all agents
    # list of dictionaries

# we iterate through each time step - saving a snapshot of the environment each time
    malfunctions = set()
    new_malfunctions = []
    timestep = 0

    while timestep < len(actions):
        """
        iterate through each set of actions in the list
        call env.step()
        for each agent, first determine whether there is a new malfunction
            if there is a new malfunction, add that agent to the new_malfunctions list
        """
        obs, rew, done, info = env.step(actions[timestep])

        for a in range(env.get_num_agents()):
            if info['malfunction'][a] > 0: # if a is malfunctioning
                if a not in malfunctions: # if this is a new malfunction
                    new_malfunctions.add(a)
                    new_actions = secondary_encoding(state) # what is the "state" --> same env, new locations of trains, new constraints for delays, facts for original plan elements
                    #actions = actions[:timestep]
                    #actions.append(new_actions)
                elif info['malfunction'][a] == 1: # last step of malfunction
                    malfunctions.remove(a)

        # when there are new malfunctions
        if len(new_malfunctions) > 0:
            for train in new_malfuntions:
                malfunctions.add(train)
            new_malfunctions = [] # reset this list
            # capture current state of the environment
            # capture remainder of current plan
            # call secondary encoding
            # update actions
        
            

        # save to output log



        


    # when a new malfunction occurs we call the secondary encoding
    # the secondary encoding updates the action list and we proceed with iteration

# when the simulation is finished (agents at target or max time) we render the images
        # for key, value in dictionary.items():
        #     pass