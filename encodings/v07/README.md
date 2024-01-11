# Version 07: multiple agents and simplifying the environment
> In this version, we include support for multiple agents.  We also introduce a new representation of the environment by eliminating groups of cells known as _straightaways_ which are long stretches of track, wherein no decision can be made by the agent because it is only permitted to move forward.

## Files
* `test_env.lp` a small environment for testing simple scenarios
* `transitions.lp` a reference file describing possible transitions per track type
* `class.lp` a reference file classifying track types and allowable moves (see below)
* `encoding.lp` computes valid paths
* `actions.lp` converts paths (solution from `encoding.lp`) into sequences of Flatland actions

## Track classes
Tracks can belong to one of three classes: **junction**, **wait**, or **simple**.


### Junction
`Possible actions: move forward, turn left, turn right`

A **junction** is any cell of type 2, 4, 5, or 6 that presents a choice for the agent from at least one direction.  Waiting is not allowed here, as this may interfere with other agents' paths.
<br>

### Wait
`Possible actions: wait, move forward`

A **wait** is any non-switch cell that precedes a **junction** or a diamond crossing.  This allows the agent to complete a partial path before reaching a **junction**, without blocking the **junction** and therefore potentially interfering with paths of other agents.  Furthermore, starting and ending cells are including in this class.  Because of this, the first and last cell of any complete path will be a **wait**.
<br>

### Simple
`Possible actions: move forward`

A **simple** is any remaining cell of the remaining track types which permits the agent to make no directional decision other than moving forward.
<br>

### State diagram
Here is diagram outlining the possible state changes between track classes:
```mermaid
---
title: State diagram
---
stateDiagram-v2
    direction LR
    [*] --> wait
    wait --> [*]
    junction --> simple

    junction --> wait
    simple --> wait

    wait --> junction
    wait --> simple


    wait --> wait
    junction --> junction
    simple --> simple
```

## Multiple agents

At the moment, support for multiple agents is introduced by including an `agent` predicate where applicable.  Additional constraints for swapping and vertex conflicts have been included to eliminate invalid moves.

---
---

## Meeting

`2024-01-11`

### What have I been working on?
* Multiple agents
* Eliminating straightaways

### What needs to happen with those?
* Support for multiple agents in the visualizer — should be done by next week
* Effective approach for handling MAPF

### What should be included when heading toward the finish line?
* Breakdowns?
* Custom environment builder (from the Flatland course)

---

### Multiple agents
Three changes were made:
* including additional `agent` predicate
* vertex conflict and swap conflict resolution
* wait actions

### Eliminating straightaways
Each track gets a class: `simple`, `wait`, `junction`

### Diagram
![Flatland test environment](https://github.com/krr-up/flatland/blob/7ad60d628be33f52cc1142cb14c88aa0ab2b399d/encodings/v07/test_env.png)
