# Flatland
## 2024 Goals and ambitions

Brainstorming:
* Improvements to the pipeline, including shell scripting
* Support for multiple agents
* Adoption of custom environment builder
* Support for breakdowns
* Abstraction (ignoring long edges; including only decision points)

These are the first five things I could think of.  If I had to order them by priority, they would be:
1. **Pipeline improvements**—no matter what the end result is, having a solid foundation is important to build upon
2. **Abstraction**—this seems to be a promising way to reduce the size of the search space, and simplify the problem to tackle more complex approaches
3. **Multiple agents**—with just a single agent, this is simply a pathfinding problem and not a conflict-resolution problem
4. **Breakdowns**—this brings us to a live, iterable, and workable approach that is cloesr to what Flatland actually calls for
5. **Custom environment builder**—this is a nice-to-have, but could come in handy for building out enviroments for testing specific edge cases; we can still create custom enviroments, however, without a dedicated UI


---

### Abstraction

How can we incorporate abstraction into this approach

* We consider only key decision points
    * Starting and ending cells
    * Switches and crossings
    * Marker: cells immediately prior to switches and crossings (relative to the agent)

Thoughts—defining "markers" is challenging, because if it were done globally, this would just be any cell adjacent to switches and crossings.  However, if an agent is approaching a switch, we only one the cell prior to be considered a marker, not the one after.