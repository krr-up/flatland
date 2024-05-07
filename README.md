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

In accordance with the Flatland competition, it is recommended to install [Anaconda](https://www.anaconda.com/distribution/) and create a new conda environment:
```
$ conda create python=3.7 --name flatland
$ conda activate flatland
```

📦 Then, install the stable release of Flatland:
```
$ pip install flatland-rl
```

<br>

### Installation

Clone the repository with the following command to save the framework locally:
```
$ git clone https://github.com/krr-up/flatland.git
```

📦 To have access to clingo, install the required package:
```
$ conda install -c potassco clingo
```

<br>

### Front-end user interface

⚠️ The front-end interface is still undergoing testing. For now, please use the command line.

A friendly user interface has been created to simplify and expedite the process of creating environments and testing out encodings.  The **create tab** allows users to specify specific parameters about the desired environments, such as the height, width, and number of trains.  Several environments that adhere to the same set of parameters can be created simulatenously.  It outputs:
* an image, `.png`
* a clingo facts file, `.lp`
* a metadata file, `.pkl`

The **generate tab** allows users to test various encodings on existing environments.  The selected encodings will be processed through clingo, and their action outputs will be passed into the Flatland visualizer to render an animation of the trains in the environment.

📦 The front-end was created using Streamlit, whose installation steps can be found in the [online documentation](https://docs.streamlit.io/get-started/installation).  In order to use it locally, install the package using the following command:
```
$ pip install streamlit
```

<br>

## Using the framework

<details>

<summary><h3>🖱️ Frontend</h3></summary>

⚠️ The front-end interface is still undergoing testing. For now, please use the command line.

In order to open the frontend in the browser, first activate the the command line, `cd` into `~/flatland`, and then call `streamlit run frontend.py`.
```
$ streamlit run frontend.py
```

The frontend should open automatically in the browser.  Created environments will be saved in the `~/flatland/envs` directory. Generated paths will be saved in the `~/flatland/output` directory.

</details>

<details open>

<summary><h3>⌨️ Command line</h3></summary>

#### Creating environments

From the command line, `cd` into `~/flatland`, and then call `python3 environments.py` with the [desired parameters](https://github.com/krr-up/flatland/blob/f7c8829c4b95b73e8f43504698d0d9b35c9e2b5c/doc/environments.md).
```
$ python environments.py 1 45 45 2 4 1 2 3
```
> Note: if calling `python` doesn't work, try calling `python3`.

The ensuing environments will be saved in the `~/flatland/envs` directory.

<br>

#### Generating paths

From the command line, `cd` into `~/flatland`, and then call `python3 paths.py` with [two (or more) necessary parameters](): the environment and at least one encoding.
```
$ python paths.py envs/pkl/env.pkl encodings/encoding.lp 
```
> Note: if calling `python` doesn't work, try calling `python3`.

Further `.lp` encodings may be passed in; all will be grounded and solved via the `clingo.application` feature.  our encoding may only produce one valid path per agent. The `paths.py` file will in any case only produce a single model. Ensuing outputs will be saved in the `~/flatland/output` directory.  

</details>

<br>

## Working example

Want to try it out on a test environment first and see how it works?  Check out the environment `test.png` in `~/flatland/envs/png`.  The action list, which is an example of output from an encoding that ultimately gets passed into Flatland, demonstrates the expected output format.

Then, from the `~/flatland` directory, run the following command:
```
$ paths.py envs/pkl/test.pkl encodings/test.lp 
```

The resulting output will be saved as a GIF in the `~/flatland/output` directory.
