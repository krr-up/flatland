#program base.
% ------PRELIMINARIES FOR SPEED HANDLING------
% action_duration(A, S, Dur): action A takes Dur timesteps at speed S
move_action(move_left;move_right;move_forward).
action_duration(wait, S, 1) :- speed(_, S).
action_duration(A, S, S) :- move_action(A), speed(_, S).

% Basic definitions: action, transition, and arrived
% action(train(ID), A, T): 
%           train ID performs action A at timestep T (needed for toolkit compatibility)
% transition(ID, T0, C0, A, T1, C1, OutD):
%           at timestep T0, train ID at cell C0 performs action A, reaching cell C1 exiting in direction OutD at timestep T1
% arrived(ID, T):          
%           train ID has arrived at its destination at timestep T

% toolkit ALWAYS requires a `wait` action at timestep 0 for each train, even if the departure time is 0
action(train(ID), wait, 0) :- train(ID).

% train "waits" before its departure time (even )
action(train(ID), wait, T) :- start(ID, _, Dep, _), T=0..Dep-1, Dep > 0.

% train "moves forward" onto starting cell at departure time. This takes 1 timestep regardless of speed.
transition(ID, Dep, C, move_forward, Dep+1, C, Dir) :-
    start(ID, C, Dep, Dir), Dep > 0.
transition(ID, 1, C, move_forward, 2, C, Dir) :-
    start(ID, C, 0, Dir).

#program check(t).

% if TrainID has arrived by t
train_arrived_by(TrainID, t) :-
    arrived(TrainID, Ta),
    Ta <= t.

% check if all trains have arrived by time t
%:- train(ID), not arrived(ID, _), query(t).

:- query(t),
   train(TrainID),
   not train_arrived_by(TrainID, t).


% :- train(ID), not arrived(ID).
% arrived(ID) :- arrived(ID, t), query(t).
%:- train(ID), not arrived(ID).
#external query(t).

#program step(t).
% ---------------ACTION CHOICE---------------
% after each speed action, choose exactly one valid action to perform next, unless the train has reached its destination
1 { transition(ID, t, C0, A, T1, C1, OutD) : 
        cell_conn(A, C0, Dir, C1, OutD), 
        action_duration(A, S, Dur),
        % T1 can exceed MaxT by 1, since it marks the timestep after the action ends
        T1 = t + Dur, global(MaxT), T1 <= MaxT + 1 } 1 :-
            % speed_action(train(ID), _, _, t),
            % state(ID, C, Dir, t),
            transition(ID, _, _, _, t, C0, Dir),
            speed(ID, S),
            not end(ID, C0, _).

% copy speed actions into regular actions (needed by toolkit)
action(train(ID), wait, t) :-
    % speed_action(train(ID), wait, t, _).
    transition(ID, t, _, wait, _, _, _).
% toolkit needs move_action at each timestep during the action
action(train(ID), A, t) :-
    % speed_action(train(ID), A, T0, T1), move_action(A),
    transition(ID, T0, _, A, T1, _, _), move_action(A),
    T = T0..T1-1,
    T0 <= t, t <= T1-1.

% if the train reaches its destination, mark it as arrived
% arrived(ID, t) :- state(ID, C, _, t), end(ID, C, _).
arrived(ID, t) :- 
    transition(ID, _, _, _, t, C, _), end(ID, C, _).

% ---------COLLISION AVOIDANCE---------
% occupies(ID, T, C): train ID occupies cell C at timestep T
% during movement, a train occupies both the starting and ending cell for the whole duration of the move
occupies(ID, t, C) :-
    transition(ID, T0, C, _, T1, _, _),
    T0 < t, t <= T1.

occupies(ID, t, C) :-
    transition(ID, T0, _, _, T1, C, _),
    T0 < t, t <= T1.

% -------------CONSTRAINTS-------------
% no two trains can occupy the same cell at the same time
:- occupies(ID0, T, C),
   occupies(ID1, T, C),
   ID0 < ID1.

% all trains must arrive at some point
%:- train(ID), not arrived(ID, _).

% trains must arrived at their designated arrival time
% :- arrived(ID, T), end(ID, (_, _), Arr), T != Arr.

% MINIMIZATION GOALS
% late(ID, Delta): If train ID is delayed Delta indicates difference between actual arrival and expected arrival
late(ID, Delta) :-
    arrived(ID, t),
    end(ID, (_, _), Arr),
    t > Arr,
    Delta = t - Arr.
#show late/2.

% early(ID, Delta): If train ID arrives early Delta indicates the difference between expected and actual arrival 
early(ID, Delta) :-
    arrived(ID, t),
    end(ID, (_, _), Arr),
    t < Arr,
    Delta = Arr - t.
#show early/2.

% action_count(ID, Count) :-
%     train(ID),
%     Count = #count { T : speed_action(train(ID), _, T, _) }.
% #show action_count/2.

% minimize wait actions
% #minimize { 2,ID,T : speed_action(train(ID), wait, T, _) }.
% #minimize { 1,ID,T : action(train(ID), _, T)}.

% minimize arrival times

%#minimize { T, ID : arrived(ID, T) }.

% minimize early and late arrivals
%#minimize { Delta, ID : late(ID, Delta) }.
%#minimize { Delta, ID : early(ID, Delta) }.

% #show speed_action/4.
% #show state/4.
% #show action/3.
#show arrived/2.