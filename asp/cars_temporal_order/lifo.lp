%*
This script implements push and pop logic when cars are supposed to behave
like a stack, i.e. the follow a LIFO logic

predicate definitions:
    new_link(TrainID, CarID, t): car (CarID) was pushed onto train (TrainID) at timestep t.
    num_new(TrainID, t, N): train (TrainID) had N trains pushed onto its stack at timestep t.
    push_pos(TrainID, CarID, t, P): CarID is pushed onto TrainID as the Pth element.
    stack_pos(TrainID, CarID, t, P): CarID is sitting at position P on stack TrainID at timestep t.
                                     1 indicates top of stack
    pos(TrainID, t, P) :- at timestep t a newly linked car can be set to position P on TrainID.
    num_unlink(TrainID, t, K): there were K unlinkings chosen at timestep K
*%


#program step(t).

% ============== Pushing onto stack (linking) and linear ordering of a stack ===================

new_link(TrainID, CarID, t) :-
    linked(TrainID, CarID, t),
    unlinked(CarID, t-1).

pushed_to_train(TrainID, t) :-
    new_link(TrainID, _, t).

popped_from_train(TrainID, t) :-
    unlinked(CarID, t),
    linked(TrainID, CarID, t-1).

% P = 1 is considered the top of the stack, i.e. the lowest number gets popped first
stack_pos(TrainID, CarID, t, 1) :-
    new_link(TrainID, CarID, t).

% increment indices for cars already on the train
stack_pos(TrainID, OldCar, t, Pos+1) :-
    new_link(TrainID, _, t),
    stack_pos(TrainID, OldCar, t-1, Pos),
    not unlinked(OldCar, t-1).

% persistence of positions when there is no push or pop on this train at t
stack_pos(TrainID, CarID, t, Pos) :-
    stack_pos(TrainID, CarID, t-1, Pos),
    linked(TrainID, CarID, t),
    not pushed_to_train(TrainID, t),
    not popped_from_train(TrainID, t).

%=========== POPPING OFF STACK (unlinking) ============

% shift all positions once something was unlinked from this train
stack_pos(TrainID, CarID, t, Pos-1) :-
    stack_pos(TrainID, CarID, t-1, Pos),
    Pos > 1,
    popped_from_train(TrainID, t).

#show stack_pos/4.

% LIFO induced constraints (no waiting without linking at stations)
:- transition(TrainID, t-1, C, wait, t, C, _),
   station(C),
   not new_link(TrainID, _, t),
   not unlinked(_, t).

% do not allow unlinking before train has moved after linking car (to avoid endless waiting loop)
moved_after_link(TrainID, CarID, t) :-
    new_link(TrainID, CarID, Tlink),
    transition(TrainID, T0, _, A, T1, _, _),
    A < wait,
    Tlink < T0,
    T1 <= t.

:- unlinked(CarID, t),
   linked(TrainID, CarID, t-1),
   not moved_after_link(TrainID, CarID, t).