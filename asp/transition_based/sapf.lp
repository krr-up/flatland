time(1).
maxTime(24).

% create initial step
step(((X1,Y1),(X2,Y2)),1) :- 
    start(A,(X1,Y1),_,D), 
    offset(D,(DX,DY)), 
    X2=X1+DX, Y2=Y1+DY.

% create subsequent steos
{ time(T+1) } :- time(T), maxTime(M), T < M.
{ step((V2,V3),T) : edge(V2,V3), allowable(V2,V3,D) } = 1 :-
    time(T),
    step((V1,V2),T-1),
    resulting(V1,V2,D).

% { step((V2,V3),T) : edge(V2,V3), allowable(V2,V3,D) } = 1 :-
%     T = 2..M, maxTime(M) 
%     , step((V1,V2),T-1)
%     , resulting(V1,V2,D). 

terminate(T) :- step((V1,V2),T), end(A,V2,_).
:- step((V1,V2),T), step((V1,V2),T'), T>T'. % do not make repeat moves
:- not terminate(_).

#minimize{ T: step(_,T) }.

#show step/2.
#show end/3.

