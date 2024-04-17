# Flatland

![Flatland animation](https://i.imgur.com/9cNtWjs.gif)

## Background
Flatland is a [railway scheduling challenge](https://flatland.aicrowd.com/intro.html) hosted by AICrowd that seeks to solve the problem of multi-agent pathfinding for trains in large railway networks.  Although approaches across all domains (e.g. reinforcement learning, operations research) are welcome, this repository focuses on integrating ASP-based solutions within the Flatland framework.

Since the Flatland framework was initially written in Python, a pipeline for:
- reading in and interpreting Flatland environments
- converting ASP output to a visualization-compatible format

is necessary to integrate Python and ASP.

<br>

## Repository structure


- 📁 `doc` which contains thorough documentation about the framework
- 📁 `encodings` which contains examples of ASP encodings that can be used to generate paths in Flatland
- 📁 `envs` which contains pre-fabricated Flatland environments for development and testing
- 📁 `modules` which contains scripts that assist in bridging the gap between Python and clingo</summary></details>
- 📁 `output` which contains animated visualizations and performance statistics from generated paths
- 📝 `environments.py` which is used to generate user-specified environments
- 📝 `frontend.py` which is a frontend interface for using the tools in this framework
- 📝 `paths.py` which is used to ground and solve encodings, and produce an animated visualization of the resulting paths

<br>

## Getting started

### Prerequisites

Please refer to [requirements.txt]() for information about necessary Python packages.

### Installation

[Under construction]

### Front-end user interface

A friendly user interface has been created to simplify and expedite the process of creating environments and testing out encodings.  The **create tab** allows users to specify specific parameters about the desired environments, such as the height, width, and number of trains.  Several environments that adhere to the same set of parameters can be created simulatenously.  It outputs:
* an image, `.png`
* a clingo facts file, `.lp`
* a metadata file, `.pkl`

The **generate tab** allows users to test various encodings on existing environments.  The selected encodings will be processed through clingo, and their action outputs will be passed into the Flatland visualizer to render an animation of the trains in the environment.

The front-end was created using Streamlit, whose installation steps can be found in the [online documentation](https://docs.streamlit.io/get-started/installation).

<br>

## Using the framework

### Creating environments

From the command line, `cd` into `~/flatland/modules`, and then call `python3 environments.py` with the [desired parameters](https://github.com/krr-up/flatland/blob/f7c8829c4b95b73e8f43504698d0d9b35c9e2b5c/doc/environments.md).
```
$ python3 environments.py 1 45 45 2 4 1 2 3
```

The ensuing environments will be saved in the `~/flatland/envs` directory.

<br>

### Generating paths

From the command line, `cd` into `~/flatland/modules`, and then call `python3 paths.py` with [two (or more) necessary parameters](): the environment and at least one encoding.
```
$ python3 paths.py envs/pkl/env.pkl encodings/encoding.lp 
```
Further `.lp` encodings may be passed in; all will be grounded and solved via the `clingo.application` feature.  (! Return) Your encoding may only output one valid path per agent.  Ensuing outputs will be saved in the `~/flatland/output` directory.  
