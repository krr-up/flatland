# Calling environments.py

## Information

Below is the help message when calling `python3 environments.py --help` in the command line:

```
usage: environments.py [-h]
                       [num_envs] [height] [width] [num_trains] [num_cities]
                       [grid_mode] [max_rails_between] [max_rails_within]

positional arguments:
  num_envs           the number of environments to create according to the
                     given parameters
  height             the height of each environment
  width              the width of each environment
  num_trains         the number of trains placed in each environment
  num_cities         the number of cities in each environment, where trains
                     can begin or end their journeys
  grid_mode          if 1, cities will be arranged in a grid-like fashion; if
                     0, cities will be arranged unevenly throughout
  max_rails_between  the maximum number of rails connecting any two cities
  max_rails_within   the maximum number of pairs of parallel tracks within one
                     city

optional arguments:
  -h, --help         show this help message and exit
```
<br>

Each of the positional arguments is optional, with predefined defaults for typical Flatland behavior.  Below are the default values:

| argument | default | | argument | default |
|:-:|:-:|:-:|:-:|:-:|
| `num_envs` | `1` | | `num_cities` | `2` |
| `height` | `30` | | `grid_mode` | `1` |
| `width` | `30` | | `max_rails_between` | `2` |
| `num_trains` | `2` | | `max_rails_within` | `2` |

**Note**: the minimum environment size is 30 x 30. 

<br>

## Example call

`:~/flatland/modules$` `python3 environments.py 1 45 45 2 4 1 2 3`

This would create a single Flatland environment of size 45 x 45, with 2 agents and 4 cities arranged according to a grid.  The output will be saved in the `~/flatland/envs` directory across three folders:
* `~/flatland/envs/lp` where an ASP fact format representation will be stored
* `~/flatland/envs/pkl` where a metadata encoding will be stored
* `~/flatland/envs/png` where an image will be stored

The `.lp` format can be used for developing an ASP encoding.  See more information regarding the consistent [fact formats](https://github.com/krr-up/flatland/blob/6f7d5c193b5c464a63d3d66fb7f191788257a291/doc/fact_formats.md).
The `.pkl` encoding stores all information about the environment that is necessary for interfacing with Flatland.  It can be passed as input to [paths.py]() when testing an encoding on an environment.
The `.png` is for human readability, to have a visual representation of what the environment looks like.
