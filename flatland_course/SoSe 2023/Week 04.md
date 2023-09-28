# Flatland encoding
> Week 4

## Progress
We have an encoding that produces a correct result for a multiple agents and avoids collisions.  Congrats!

## Next steps for Week 5
<u>Housekeeping</u>: Next week we will not meet.

1. For now, let's abandon the notion of *long edges*
2. Keep track of the position of the train at each time step
3. Add more trains into a larger environment and check for collisions
4. Later, reintroduce long edges and find a good method for tracking the position
5. If there is still time, think about whether it's possible to avoid collisions without actively tracking the position

### More advanced goals for the rest of the project this semester
1. Time limit for a train to reach its goal (maximum number of steps)
2. Visualizing on the Flatland map

This second goal would envision:
* using Flatland to generate a map
* converting this to ASP
* coming up with a solution in ASP
* translating the solution into Flatland-readable code to produce a visualized output