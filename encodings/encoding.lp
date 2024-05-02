%maxTime(42).
%maxTime(T) :- tracks(T).

factor(ID,Start,End) :- start(agent(ID), _, Start, _), end(agent(ID), _, End).

% RULES - - -
% starting moves
at(agent(ID), (X,Y), D, 0+Start) :- start(agent(ID), (X,Y), Start, dir(D)).
at(agent(ID), (X1,Y1), D1, 1+Start) :- at(agent(ID), (X,Y), D, 0), offset((D,f), (DX,DY), D1), factor(ID,Start,_), X1=X+DX, Y1=Y+DY.

% has an agent reached the goal
goal(ID,T) :- at(agent(ID),(X,Y),_,T), end(agent(ID),(X,Y),_).

% following moves
do(ID,f,Start) :- factor(ID,Start,_).
{ do(ID,M,T) : move(M) } = 1 :- agent(ID), factor(ID,Start,End), T=Start..End, at(agent(ID), _, _, T-1), not goal(ID,T-1).
at(agent(ID), (X1,Y1), D1, T+1) :- at(agent(ID), (X,Y), D0, T), do(ID,M,T), offset((D0,M), (DX,DY), D1), X1=X+DX, Y1=Y+DY, end(agent(ID), (EndX,EndY),_), (X,Y) != (EndX,EndY).


% CONSTRAINTS ---
% each agent must reach its destination
:- end(agent(ID), (X,Y), _), not at(agent(ID), (X,Y), _, _).

% no illegal transition
:- do(ID,M,T), at(agent(ID),(X,Y),D,T), cell((X,Y), Type), not transition(Type,(D,M)).

% may only wait in its start position
%:- do(ID,wait,T), at(agent(ID),(X,Y),_,T), not start(agent(ID),(X,Y),_,_).

% must be a valid cell
:- at(_, (X,Y), _, _), not cell((X,Y), _).

% no swap conflict
:- at(agent(A), (X,Y), _, T), at(agent(B), (X,Y), _, T+1), A!=B.

% no vertex conflict
vertex(T) :- at(agent(A), (X,Y), _, T), at(agent(B), (X,Y), _, T), A!=B.
%:- vertex(T), at(_,_,_,T).

% SHOW STATEMENTS ---
#show at/4.
%#show action/3.
%#show do/3.
%#show vertex/1.