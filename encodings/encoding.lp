% generate do() --> determine at() --> determine action()

%%% WAITING
% before the agent is ready, it has to choose wait
do(ID,wait,0) :- agent(ID).
do(ID,wait,T) :- start(agent(ID), _, DepartureTime, _), T = 1..(DepartureTime-1), DepartureTime > 0.

%%% READY
% ready means it can start selecting an idle move: wait or spawn - once it spawns, it becomes active
ready(ID,T) :- start(agent(ID), _, T, _).
%{ do(ID,M,Ready) : idle(M) } = 1 :- agent(ID), ready(ID,Ready).
%{ do(ID,M,T) : idle(M) } = 1 :- do(ID,wait,T-1), ready(ID,Ready), T<Ready+10. %capping this at 10 timesteps
do(ID,spawn,Ready) :- ready(ID,Ready), Ready > 0.

% special case that Ready at 0 actually gets delayed by one time step
do(ID,spawn,1) :- ready(ID,0).


%%% ACTIVE
% active means it has selected forward and can then choose forward, left, or right
active(ID,T+1) :- do(ID,spawn,T).
at(ID,(X,Y),D,T) :- start(agent(ID), (X,Y), _, dir(D)), active(ID,T).
timeframe(Start,End) :- active(ID,Start), end(agent(ID),_,End).

% optional wait
%{ do(ID,wait,T) } :- timeframe(Start,End), T=Start..End, at(ID, (X,Y), _, T), cell((X,Y),(4608;16386;72;2064;1025;32800)), not done(ID,T-1).
%{ do(ID,wait,T) } :- timeframe(Start,End), T=Start..End, at(ID, (X,Y), _, T), cell((X,Y),_), start(agent(ID), (X,Y), _, _), not done(ID,T-1).

% choose moves
{ do(ID,M,T) : move(M) } = 1 :- timeframe(Start,End), T=Start..End, at(ID, _, _, T), not done(ID,T-1).
at(ID,(X+Dx,Y+Dy),D,T) :- at(ID,(X,Y),D_old,T-1), do(ID,M,T-1), offset((D_old,M),(Dx,Dy),D).


%%% DONE
% done means it has reached its destination and can no longer make decisions
done(ID,T) :- at(ID,(X,Y),_,T), end(agent(ID),(X,Y),_).

% calculate sum of steps
sos(S) :- S = #sum{ 1,ID,M,T: do(ID,M,T), not M = wait }.
makespan(MS) :- MS = #max{ T: do(ID,M,T) }.


% CONSTRAINTS
% every agent must reach its destination
:- agent(ID), not done(ID,_).

% must be a valid cell
:- at(_, (X,Y), _, _), not cell((X,Y), _).

% no illegal transition
:- do(ID,M,T), at(ID,(X,Y),D,T), cell((X,Y), Type), not transition(Type,(D,M)).

% no swap conflict
:- at(A, (X,Y), _, T), at(B, (X,Y), _, T+1), A!=B.

% no vertex conflict
:- at(A, (X,Y), _, T), at(B, (X,Y), _, T), A!=B.

#show do/3.
%#show active/2.
%#show at/4.
#show sos/1.
#show makespan/1.
%#show done/2.

%#minimize { M : makespan(M) }.
%#minimize { T : done(ID,T) }.