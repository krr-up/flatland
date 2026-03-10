% predicate definitions
    % car_state(CarID, C, T): car ID is located at cell C at timestep T
    % linked(TrainID, CarID): car with identified 'CarID' is linked to train with identifier 'TrainID'
    % unlinked(CarID, T): car CarID is not linked to any train at timestep


#program base.
% initialize car states
car_state(CarID, C, 0) :- car_start(CarID, C).

% initialize all cars as unlinked
unlinked(CarID, 0) :- car(CarID).

% optimization goals: maximize delivered value and minimize delivery times
#maximize { V, CarID : car_arrived(CarID, T), car_value(CarID, V) }.
#minimize { T, CarID : car_arrived(CarID, T) }.

%#show car_state/3.
%#show linked/3.
%#show unlinked/2.
%#show car_arrived/2.


#program check(t).
% check if check if at least one car has arrived by time t
car_arrived_by(CarID, t) :-
    car_arrived(CarID, Tc),
    Tc <= t.

:- query(t),
   #count { CarID : car_arrived_by(CarID, t) } < 3.

delivered_value(Sum, t) :- Sum = #sum { V, CarID : car_arrived(CarID, _), car_value(CarID, V) }.

%#show delivered_value/2.
#program step(t).


% this will be used to effectively derive the car states and determine when linking and unlinking is valid
train_end_at(TrainID, t, C) :-
    transition(TrainID, _, _, _, t, C, _).

% choose 0 or 1 links per train per timestep
0 { linked(TrainID, CarID, t) :
        car_state(CarID, C, t-1),
        unlinked(CarID, t-1),
        not car_target(CarID, C)} 1 :-
    t > 0,
    transition(TrainID, _, _, wait, t, C, _),
    station(C).

% only choose one or 0 unlinking per train per timestep 
0 { opt_unlink(CarID, t) : stack_pos(TrainID, CarID, t-1, 1) } 1 :-
    t > 0,
    train_end_at(TrainID, t-1, C),
    station(C).

% force unlink at targets
forced_unlink(CarID, t) :-
    t > 0,
    linked(TrainID, CarID, t-1),
    train_end_at(TrainID, t-1, C),
    car_target(CarID, C).

will_unlink(CarID, t) :- opt_unlink(CarID, t).
will_unlink(CarID, t) :- forced_unlink(CarID, t).

unlinked(CarID, t) :- will_unlink(CarID, t).

% linking persists
linked(TrainID, CarID, t) :-
    t > 0,
    linked(TrainID, CarID, t-1),
    not will_unlink(CarID, t).

% cannot be linked to two trains at once
:- linked(T1, CarID, t), linked(T2, CarID, t), T1 < T2.

% unlinked persists if not relinked
unlinked(CarID, t) :-
    t > 0,
    unlinked(CarID, t-1),
    not linked(_, CarID, t).

% no car can be both linked and unlinked
:- linked(_, CarID, t), unlinked(CarID, t).

% no train can perform both linking and unlinking at t
:- linked(TrainID, CarIn, t),
   unlinked(CarIn, t-1),
   unlinked(CarOut, t),
   linked(TrainID, CarOut, t-1).


% car follows its train when linked
car_state(CarID, C, t) :-
    linked(TrainID, CarID, t),
    train_end_at(TrainID, t, C).

% car stays when unlinked
car_state(CarID, C, t) :-
    t > 0,
    car_state(CarID, C, t-1),
    unlinked(CarID, t-1).

% arrival detection
car_arrived(CarID, t) :-
    car_state(CarID, C, t),
    car_target(CarID, C).

% capacity constraint (NO time(T))
:- train(TrainID),
   train_capacity(TrainID, Cap),
   Cap < #sum { W, CarID : linked(TrainID, CarID, t), car_weight(CarID, W) }.
