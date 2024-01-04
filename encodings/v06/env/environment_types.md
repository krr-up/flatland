# Environment generation
> [Documentation](https://gitlab.aicrowd.com/flatland/flatland/-/blob/master/flatland/envs/rail_generators.py)

When instantiating environment classes, there are several parameters available for users to specify:
*  `max_num_cities` : _Integer_, maximum number of cities to build—the generator tries to achieve this numbers given all the parameters
*  `grid_mode`: _Boolean_, how to distribute the cities in the path, either equally in a grid or random
*  `max_rails_between_cities`: _Integer_, maximum number of rails connecting to a city—this is only the number of connection points at city border, but the number of tracks drawn inbetween cities can still vary
*  `max_rail_pairs_in_city`: _Integer_, number of parallel tracks in the city, representing the number of tracks in the train stations

Then, when generating new environments in the given classes, there are additional parameters available for users to specify:
* `width`: _Integer_, width of the environment
* `height`: _Integer_, height of the environment
* `num_agents`: _Integer_, number of agents to be placed within the environment

---

When generating environments in batch for later testing, we can categorize them by various qualities for later analysis:
* the area of the grid: `width` × `height`
* the track density of the environment: `cells_with_track` ÷ `area`
* the switch density of the track network: `cells_with_switches` ÷ `cells_with_track`
* the agent density of the track network: `num_agents` ÷ `cells_with_track`

These can be calculated and saved into a separate reference file containing relevant metadata about the generated environments.  Later, these categorizations can be used to compare performance on similar (or contrast performance on different) environments.
