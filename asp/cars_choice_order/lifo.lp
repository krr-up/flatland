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
    not linked(TrainID, CarID, t-1).

num_new(TrainID, t, N) :-
    linked(TrainID, _, t),
    N = #count { CarID : new_link(TrainID, CarID, t) }.

pos(TrainID, t, P) :-
    num_new(TrainID, t, N),
    P = 1..N.

% choose an order in which cars are added to the stack
1 { push_pos(TrainID, CarID, t, P) : pos(TrainID, t, P) } 1 :-
    new_link(TrainID, CarID, t).

% two cars cannot have the same index in a stack
:- push_pos(T, C1, t, P),
   push_pos(T, C2, t, P),
   C1 < C2.

% P = 1 is considered the top of the stack, i.e. the lowest number gets popped first
stack_pos(TrainID, CarID, t, P) :-
    push_pos(TrainID, CarID, t, P).


%=========== POPPING OFF STACK (unlinking) ============
num_unlink(TrainID, t, K) :-
    linked(TrainID, _, t-1),
    K = #count { CarID : unlinked(CarID, t), linked(TrainID, CarID, t-1) }.


%=========== SHIFTING STACK POSITIONS ===========
% carry-over cars: apply pop shift and push shift in ONE step
% Pos' = Pos - K + N, and only survivors Pos > K remain on stack
stack_pos(TrainID, CarID, t, PosNew) :-
    stack_pos(TrainID, CarID, t-1, Pos),
    linked(TrainID, CarID, t),              % still linked after this timestep
    not new_link(TrainID, CarID, t),        % not a freshly pushed car (handled by push_pos rule)
    num_unlink(TrainID, t, K),
    num_new(TrainID, t, N),
    Pos > K,
    PosNew = Pos - K + N.



#show stack_pos/4.


% additional constraint regulating popping of stack, i.e. unlinking:
% if you chose K cars to unlink then unlinking a car at stack ID > K is invalid
:- unlinked(CarID, t),
   linked(TrainID, CarID, t-1),
   stack_pos(TrainID, CarID, t-1, Pos),
   num_unlink(TrainID, t, K),
   Pos > K.