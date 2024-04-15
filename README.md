# Flatland

![Flatland animation](https://i.imgur.com/9cNtWjs.gif)

## Background
Flatland is a [railway scheduling challenge](https://flatland.aicrowd.com/intro.html) hosted by AICrowd that seeks to solve the problem of multi-agent pathfinding for trains in large railway networks.  Although approaches across all domains (e.g. reinforcement learning, operations research) are welcome, this repository focuses on integrating ASP-based solutions within the Flatland framework.

Since the Flatland framework was initially written in Python, a pipeline for:
- reading in and interpreting Flatland environments
- converting ASP output to a visualization-compatible format

is necessary to integrate Python and ASP.

## Getting started


### Prerequisites

Please refer to requirements.txt for information about necessary Python packages.

### Installation

### Front-end user interface

A friendly user interface has been created to simplify and expedite the process of creating environments and testing out encodings.  The **create tab** allows users to specify specific parameters about the desired environments, such as the height, width, and number of trains.  Several environments that adhere to the same set of parameters can be created simulatenously.  It outputs:
* an image, `.png`
* a clingo facts file, `.lp`
* a metadata file, `.pkl`

The **generate tab** allows users to test various encodings on existing environments.  The selected encodings will be processed through clingo, and their action outputs will be passed into the Flatland visualizer to render an animation of the trains in the environment.

The front-end was created using Streamlit, whose installation steps can be found in the [online documentation](https://docs.streamlit.io/get-started/installation).

## Project structure


- `doc` which contains thorough documentation about the framework
- `encodings` which contains examples of ASP encodings that can be used to generate paths in Flatland
- `envs` which contains pre-fabricated Flatland environments for development and testing
- `modules` which contains scripts that assist in bridging the gap between Python and clingo
