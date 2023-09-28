# Flatland encoding
> Week 5

## Progress
Really great work on redesigning your approach and also integrating it with the Flatland environment and the visualizer!

## Next steps for Week 6
1. Finish what you've started wit hthe collision constraints
    1. Maybe what we were seeing was some sort of scaling issue, so figure that out (make sure there's no bug wit hthe maxTime value)
    2. Do try it with several trains but also with the simple stuff (keeping all time steps)
2. What we would love to do as we get closer to wrapping up the project is to also have the option to retain the long edges for the purpose of avoiding the collisions
    1. If you just assume htat the speed of the trains is contant, maybe it's easy to avoid collisions, because you know when they enter and exit the edge (could it be possible to calculate that ahead of time? who knows)
3. Then, with these two separate approaches, generate several environments that we can use for benchmarking
    1. Have your two approaches and compare their times/performances against each other for each type of environment
    2. Organize it by the type of environment (size, number of agents, etc.)
4. Eventually, we would like to establish deadlines for the trains

### More advanced goals for the rest of the project this semester (same as last week)
1. Time limit for a train to reach its goal (maximum number of steps)
2. ~~Visualizing on the Flatland map~~
