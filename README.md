# KRR-Flatland

![Flatland animation](https://i.imgur.com/9cNtWjs.gif)

## Background
Flatland is a [railway scheduling challenge](https://flatland.aicrowd.com/intro.html) hosted by AICrowd that seeks to solve the problem of multi-agent pathfinding for trains in large railway networks.  Although approaches across all domains (e.g. reinforcement learning, operations research) are welcome, this repository focuses on integrating ASP-based solutions within the Flatland framework.

Since the Flatland framework was initially written in Python, a pipeline for:
- reading in and interpreting Flatland environments
- converting ASP output to a visualization-compatible format

is necessary to integrate Python and ASP.

<br>

## Repository structure

- 📁 `asp` which contains ASP encodings that can be used to handle path generation in Flatland
- 📁 `doc` which contains thorough documentation about the framework
- 📁 `envs` which contains pre-fabricated Flatland environments for development and testing
- 📁 `modules` which contains scripts that assist in bridging the gap between Python and clingo
- 📁 `output` which contains animated visualizations and performance statistics from generated paths
- 📝 `build.py` which is used to build user-specified environments
- 📝 `solve.py` which is used to ground and solve encodings, and produce an animated visualization of the resulting paths

<br>

## Getting started

### Prerequisites

In accordance with the Flatland competition, it is recommended to install [Anaconda](https://www.anaconda.com/distribution/) and create a new conda environment:
```
conda create python=3.7 --name flatland
conda activate flatland
```

📦 Then, install the stable release of Flatland:
```
pip install flatland-rl
```

📦 To have access to clingo, install the required package:
```
conda install -c potassco clingo
```

<br>

### Installation

Clone the repository with the following command to save the framework locally:
```
git clone https://github.com/krr-up/flatland.git
```

## Using the framework

From the command line, `cd` into `/flatland`.

### 🗺️ Creating environments

Environments can be created and stored for later use.  There is no limit to how many times a simulation may be performed on a single environment.

In the 📁 `envs` folder, there is a 📝 `params.py` file in which the parameters of the environment can be specified.  This includes attributes about the Flatland environment, such as height, width, number of agents, and number of stations.  This also includes attributes about how the simulation will function, such as the speeds of the trains, how frequently they will malfuncion, and whether the trains should be removed upon reaching their targets.  These attributes are then inehrent to the environment and cannot be changed later.  This means, for example, neither the number of trains nor whether they malfunction can be modified.

All of the parameters in the file are necessary for the successful generation of a Flatland environment, so they must remain, but their assigned values can be adjusted, so long as they remain the same data type as originally given (e.g. `int`, `bool`).

In order to build a new environment from the command line, call `python build.py` followed by the number of environments you would like to create.
```
python build.py 3
```

When this is called, the attributes of the environment will look to the 📝 `params.py` file to be determined.  Make the desired changes before executing the command line call.  The ensuing environments will be saved in the 📁 `envs` folder.  Each environment will be represented in three formats:
1. `lp` a file of clingo facts
2. `pkl` a serialization of the environment as a Python object
3. `png` an image of the environment

<br>

### 🧭 Generating paths

#### 🧑‍💻 Initial development
Individual developers are responsible for writing encodings in clingo that are capable of solving Flatland problems.  During the development phase, the `lp` representation of the environment may be beneficial for initial testing and debugging of the encoding or encodings.  Keep in mind that several encodings can be called simulatenously by clingo, for example:
```
clingo envs/lp/test.lp asp/graph_based/graph.lp asp/graph_based/traverse.lp asp/graph_based/actions.lp
```

The order is not important.  What will ultimately be necessary is that the output be appropriately formatted in the following manner:
`action(train(ID), Action, Time).` 

The `Action` variable must be one of the following:
- `move_forward`
- `move_left`
- `move_right`
- `wait`

Once an encoding or set of encodings has been developed that produces valid paths in the form of the appropriate `action(...)` output, developers can begin official testing using this framework.

---

#### 📋 Official testing

Since it is encouraged that developers explore several approaches to their encodings, the toolkit allows developers to specify which encodings should be testing.  This is controlled from within the 📁 `asp` folder in the 📝 `params.py` file.  There are two parameters:
- `primary`
- `secondary [optional]`

Each of them is a set of file paths to the desired encodings, for example:
```
primary=['asp/graph_based/actions.lp','asp/graph_based/graph.lp','asp/graph_based/traverse.lp']
secondary=['asp/vsrp/replan.lp']
```

The `primary` parameter is necessary, and is the standard suite of path planning encodings that return the appropriate `action(...)` output.  The `secondary` parameter is optional, and is primarily used when malfunctions are present in an environment.  Developers may choose to create a set of secondary encodings that help the replanning process necessary when faced with a train that has stalled.  For instance, it may be more efficient to consider the existing plan than to replan from the start.  More information about this is available in the 📁 `doc` folder.  If malfunctions are active and no `secondary` encoding is provided, the tooltik will call the `primary` set of encodings.

From the command line, call `python solve.py` along with a path to the `.pkl` form of the environment to test on, for example:
```
python solve.py envs/pkl/test.pkl
```

If successful, the output will be saved as a `.gif` (which by the way is pronounced [/dʒɪf/](https://www.abc.net.au/news/2018-08-10/is-it-pronounced-gif-or-jif/10102374) according to the creator of the format) animation, as well as a log file that details at each step what occurred in the simulation.

---

#### 🔧 Troubleshooting

If the run was unsuccessful, it may be due to any number of reasons.  Some popular reasons may be:
- **an invalid move was provided**, which could be the result of many causes
  - the sequence of actions is correct but is offset by some number of time steps
  - a train malfunctioned and the actions were provided during the incorrect time step
  - some aspect of the representation of the environment has been transformed, for instance by inverting the axes, and the given action is not valid for the Flatland representation
- **the simulation ran out of time steps**, and as Flatland sets a fairly large internal maximum number of time steps, this typically only happens under certain circumstances, such as when:
  - malfunctions of significant durations occur
  - the environment was initially set to **not** remove agents upon reaching their targets, and an agent is therefore inadvertantly blocking another agent from reaching the target station
- **the encoding doesn't actually provide valid paths**
  - realistically, it can be difficult to validate whether paths are valid by solely reading through the output alone -- that is why visualization is such an important tool
  - often this happens when the logic from Flatland is not properly mirrored and the encoding "loses track" of where a train actually is

Reading through the output log is a good place to start searching for the issue.  For more extreme cases, it might be worth calling attributes directly from the Flatland code.  There are some helpful tips provided in [Developer Tips](https://github.com/krr-up/flatland/blob/updates/doc/dev_tips.md) that show expected output for different function or attribute calls.  However, it is not recommended to include this modified Flatland code in the final version of the group's project.  Be sure to create a separate branch for debugging, and once the problem has been resolved, return to the primary working branch to resume testing the encodings.

<br>

## Working example

Want to try it out on a test environment first and see how it works?  
- In the  📁 `envs` folder, check out the environment `test.png` to see what it looks like
- In the 📁 `asp` folder, check out the 📝 `test.lp` list of actions, which is an example of output from an encoding

First, from within the 📁 `asp` folder, modify the 📝 `params.py` file to read `primary=['asp/test.lp']`. Then, from the `/flatland` directory, run the following command:
```
python solve.py envs/pkl/test.pkl
```

The resulting output will be saved as a `.gif` in the 📁 `output` folder.
