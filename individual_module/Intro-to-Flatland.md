# Introduction to Flatland

## Their topics/workpackage proposals
<br>

---
---
---
---
---
---
---
---

## General
* competition (DB, SBB, SCNF)
* originally marketed as "reinforcement learning"
* many other approaches emerged; not much work from ASP

## Technical details
* MAPF
    * differs in terms of connectedness
    * not four-connected like a warehouse floor
* VRSP
    * ties in with *robust methods*
    * competition inflicts random breakdowns, which effectively are delays
    * all trains, including ones that have broken down, are expected to ultimately get to their end positions

## Long-term goal
* build up a competency here at the university—similar to how MAPF has been promoted
    * when I started my thesis, we grew our relationship with the developers of this competition
    * we now have the project module course in Railway Scheduling
    * we might have another bachelor/master thesis within the next two years
    * my PhD: bring in some additional industry professioals 

## Current issue
* for my thesis, the idea is to create a general framework that allows people to plug their Clingo encodings directly into the Flatland modules
    * we want students to right away start testing out their theories and implement new approaches without having to deal with the packages and the errors and all of that
* however, at the moment we don't have anything that could actually solve the Flatland problem
    * in addition to the general framework, I have a very inefficient MAPF solver, which doesn't account for breakdowns so there's no replanning that's going on at all
    * so I have this long list of things that I would like to explore in the coming years
        * mainly how to make it more efficient
        * also this paper `Routing and Scheduling in different ways` that talks about using partial orders and eliminates the need for an upper bound