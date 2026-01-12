# Using formalization encodings

## Background

We are currently writing a paper that formally defines the characteristics of the Flatland environment.
In order to verify that the formal definitions are correct, we have created encodings in clingo that mimic the written definitions.
Currently we have three approaches:
1. Edge functions
2. Subnodes
3. Hypergraphs

Simple graph structures do not work, as they do not sufficiently model the directional behavior of trains.
For example, a train cannot travel from cell A to cell B and then immeidately back to cell A, because this would require a train to move backward.
A simple directed or undirected graph without additional information cannot prevent such behavior.

The proposed solutions are to:
1. Encode information about permitted directions of travel over an edge based on the current direction of a train
2. Encode information about the direction of a train in the cell itself
3. Encode information about momentum by grouping cells together in an ordered fashion

## How to use

Depending on the desired approach, a combination of files must be used:
1. `aux.lp` is always required, as it provides auxiliary facts and rules that apply to all approaches
2. an environment that follows the standard fact format is required, but does not have to come from this repository
3. a translation of the environment must be used
    1. for edge functions use `edge-functions.lp`
    2. for subnodes use `subnodes.lp`
    3. for hypergraphs use `hypergraph.lp`
4. a pathfinding logic is also required to produce paths
    1. for edge functions use `pathfinding-ef.lp`
    2. for subnodes use `pathfinding-sub.lp`
    3. for hypergraphs use `pathfinding-hyper.lp`
  
## Example
```
$ clingo aux.lp env.lp edge-functions.lp pathfinding-ef.lp 1
```
