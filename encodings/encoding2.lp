% generate do() --> determine at() --> determine action()

%%% WAITING
% before the agent is ready, it has to choose wait
do(ID,wait,T) :- start(agent(ID), _, DepartureTime, _), T = 0..(DepartureTime-1).

%%% READY
% ready means it can start selecting an idle move: wait or spawn - once it spawns, it becomes active
ready(ID,T) :- start(agent(ID), _, T, _).
{ do(ID,M,Ready) : idle(M) } = 1 :- agent(ID), ready(ID,Ready).
{ do(ID,M,T) : idle(M) } = 1 :- do(ID,wait,T-1), ready(ID,Ready), T<Ready+10. %capping this at 10 timesteps

%%% ACTIVE
% active means it has selected forward and can then choose forward, left, or right
active(ID,T+1) :- do(ID,spawn,T).
at(ID,(X,Y),D,T) :- start(agent(ID), (X,Y), _, dir(D)), active(ID,T).
timeframe(Start,End) :- active(ID,Start), end(agent(ID),_,End).
{ do(ID,M,T) : move(M) } = 1 :- timeframe(Start,End), T=Start..End, at(ID, _, _, T), not done(ID,T-1).
at(ID,(X+Dx,Y+Dy),D,T) :- at(ID,(X,Y),D_old,T-1), do(ID,M,T-1), offset((D_old,M),(Dx,Dy),D).

%%% DONE
% done means it has reached its destination and can no longer make decision
done(ID,T) :- at(ID,(X,Y),_,T), end(agent(ID),(X,Y),_).


% CONSTRAINTS
%:- agent(ID), not done(ID,_).

#show do/3.
%#show active/2.
#show at/4.