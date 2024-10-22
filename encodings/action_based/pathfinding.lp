%%% WAITING
% before the train is READY, it has to choose wait
do(ID,wait,0) :- train(ID).
do(ID,wait,T) :- start(ID, _, DepartureTime, _), T = 1..(DepartureTime-1), DepartureTime > 0.

%%% READY
% select an idle move: wait or spawn - once it spawns, it becomes ACTIVE
ready(ID,T) :- start(ID, _, T, _).
do(ID,spawn,Ready) :- ready(ID,Ready), Ready > 0.

% special case that Ready at 0 gets delayed by one time step
do(ID,spawn,1) :- ready(ID,0).

%%% ACTIVE
% it has selected forward and can then choose forward, left, or right
active(ID,T+1) :- do(ID,spawn,T).
at(ID,(X,Y),D,T) :- start(ID, (X,Y), _, D), active(ID,T).
timeframe(Start,End) :- active(ID,Start), end(ID,_,End).

% choose cells
{ do(ID,M,T) : move(M) } = 1 :- timeframe(Start,End), T=Start..End, at(ID, _, _, T), not done(ID,T-1).
at(ID,(X+Dx,Y+Dy),D,T) :- at(ID,(X,Y),D_old,T-1), do(ID,M,T-1), offset((D_old,M),(Dx,Dy),D).

%%% DONE
% it has reached its destination and can no longer make decisions
done(ID,T) :- at(ID,(X,Y),_,T), end(ID,(X,Y),_).


% constraints
% every train must reach its destination
:- train(ID), not done(ID,_).

% must be a valid cell
:- at(_, (X,Y), _, _), not cell((X,Y), _).

% no illegal transition
:- do(ID,M,T), at(ID,(X,Y),D,T), cell((X,Y), Track), not transition(Track,(D,M)).

% no swap conflict
:- at(A, (X,Y), _, T), at(B, (X,Y), _, T+1), A!=B.

% no vertex conflict
:- at(A, (X,Y), _, T), at(B, (X,Y), _, T), A!=B.
