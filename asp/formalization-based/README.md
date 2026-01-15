# How things work #

The running example from the paper is represented by facts in `example.lp`

## Graph translation #

### Directed graph with edge functions ###

```text
clingo directions.lp grid-functions.lp tracks.lp example.lp edge-functions.lp
```

### Directed graph with sub-nodes ###

```text
clingo directions.lp grid-functions.lp tracks.lp example.lp subnodes.lp
```

### Directed graph with hyper-edges ###
```text
clingo directions.lp grid-functions.lp tracks.lp example.lp hypergraph.lp
```

## Pathfinding on graph representations ##

### Directed graph with edge functions ###

```text
clingo1facts directions.lp grid-functions.lp tracks.lp example.lp edge-functions.lp | \
clingo2facts - pathfinding-functions.lp -c h=10
```

### Directed graph with sub-nodes ###

```text
clingo1facts directions.lp grid-functions.lp tracks.lp example.lp subnodes.lp | \
clingo2facts - pathfinding-subnodes.lp -c h=10
```

### Directed graph with hyper-edges ###

```text
clingo1facts directions.lp grid-functions.lp tracks.lp example.lp hypergraph.lp | \
clingo2facts - pathfinding-hyper-edges.lp -c h=9
```
