# Attempt 03

## Summary
In the previous attempt, every possible arrangement of all track types was given a unique matrix representation that describes possible movements.  These matrices were fed into an algorithm that builds out all possible connections, forming a hypergraph comprised edges with three vertices each.  However, including hypergraphs in our constraint-checking step led to a loss of performance.

To address that problem in this attempt, we abandon the notion of constructing a graph altogether.

## Cell definitions
Prior the last attempt, in addition to their locations `(x,y)`, cells could be described by their:
* track type {0,1,2,3,4,5,6,7}
* orientation {N,W,S,E}
* flip {0,1}

During the last attempt, the orientation and the flip were combined such that all track types could be described just by their track type and orientation.  Resulting derivative track types were then considered to be new track types, for a total of eleven {0,1,1C,1D,2L,2R,3,4,5,6,7}.

## Legal paths
Despite the five-tuple definition of the cells, the representation (in Clingo) for our test environment `potsdam.lp` was not described in terms of cells, but rather as the hyper-edges.  Effectively, I skipped a step.  It was suggested that the environment be described in a manner consistent with the cell definitions—that is, a list of cells.  From there, the edges could be systematically derived.  For Attempt 02, I developed a Python script that explicitly writes out all possible edges based on the cell types, orientations, and coordinates.

This algorithm worked by assigning each possible cell track arrangement a unique matrix that describes possible paths.  It has four rows which correspond to the four origin cardinal directions (coming from the north, west, south, east), and the three possible destination relative directions (left, forward, right).  A straight track that goes between north and south would have the following matrix:
`.	L F R`
`N	0 1 0`
`W	0 0 0`
`S	0 1 0`
`E 	0 0 0`

## Changes for this attempt
One suggestion that Professor Schaub made was in how to represent this notation.  For instance, for this type of cell located at (5,5), this could be described as:
`cell(5,5,{(N,F),(S,F)})`

The idea would be that since we have a limited (and rather small) number of unique track arrangements, we could represent these as facts.  And with these facts, we could use a series of offsets (present in previous attempts) to determine on a case-by-case basis, which moves are legal.  For instance, if we know that cell `(5,5)` has a legal move of `(S,F)` then we know that cell must be one above it, namely `(5,6)`.  If this works efficiently, then we don't need to build out the legal paths ahead of time.

In theory, this should work because each matrix (or its corresponding set notation) contains a lot of information.  Inherent to the Flatland problem is the agent orientation influencing possible transitions, despite neighboring cells.  In the last two attempts, this was solved by creating edges of three cells each, but this has posed a problem in enforcing integrity constraints.