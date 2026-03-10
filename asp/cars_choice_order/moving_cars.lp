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
%#show delivered_value/2.


#program check(t).
% check if check if at least one car has arrived by time t
car_arrived_by(CarID, t) :-
    car_arrived(CarID, Tc),
    Tc <= t.

:- query(t),
   #count { CarID : car_arrived_by(CarID, t) } < 2.

delivered_value(Sum, t) :- Sum = #sum { V, CarID : car_arrived(CarID, _), car_value(CarID, V) }.

#program step(t).

% this will be used to effectively derive the car states and determine when linking and unlinking is valid
train_end_at(TrainID, t, C) :-
    transition(TrainID, _, _, _, t, C, _).

% ---------------- LINK CHOICE (at time t, based on positions at t-1) ----------------
{ linked(TrainID, CarID, t) } :-
    t > 0,
    train_end_at(TrainID, t-1, C),
    car_state(CarID, C, t-1),
    unlinked(CarID, t-1),
    not car_target(CarID, C).

% ---------------- UNLINK EVENTS (at time t, based on state at t-1) ----------------
% optional unlink at stations
{ opt_unlink(CarID, t) } :-
    t > 0,
    linked(TrainID, CarID, t-1),
    train_end_at(TrainID, t-1, C),
    station(C).

% forced unlink at target (when the train was at target at t-1 while car was linked)
forced_unlink(CarID, t) :-
    t > 0,
    linked(TrainID, CarID, t-1),
    train_end_at(TrainID, t-1, C),
    car_target(CarID, C).

% unify unlink causes
will_unlink(CarID, t) :- opt_unlink(CarID, t).
will_unlink(CarID, t) :- forced_unlink(CarID, t).

% unlink holds at time t if we unlink now
unlinked(CarID, t) :- will_unlink(CarID, t).

% ---------------- LINK PERSISTENCE ----------------
linked(TrainID, CarID, t) :-
    t > 0,
    linked(TrainID, CarID, t-1),
    not will_unlink(CarID, t).

% cannot be linked to two trains at once
:- linked(T1, CarID, t), linked(T2, CarID, t), T1 < T2.

% ---------------- UNLINK PERSISTENCE ----------------
unlinked(CarID, t) :-
    t > 0,
    unlinked(CarID, t-1),
    not linked(_, CarID, t).

% no car can be both linked and unlinked
:- linked(_, CarID, t), unlinked(CarID, t).

% ---------------- CAR STATE PROPAGATION ----------------
% car follows its train when linked
car_state(CarID, C, t) :-
    linked(TrainID, CarID, t),
    train_end_at(TrainID, t, C).

% car stays where it was when it was unlinked at t-1
car_state(CarID, C, t) :-
    t > 0,
    car_state(CarID, C, t-1),
    unlinked(CarID, t-1).

% ---------------- ARRIVAL / SERVED ----------------
car_arrived(CarID, t) :-
    car_state(CarID, C, t),
    car_target(CarID, C).

served(CarID, t) :-
    unlinked(CarID, t),
    car_arrived(CarID, _).

% ---------------- CAPACITY ----------------
:- train(TrainID),
   train_capacity(TrainID, Cap),
   Cap < #sum { W, CarID : linked(TrainID, CarID, t), car_weight(CarID, W) }.