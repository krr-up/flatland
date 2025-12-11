#const global = 3.

{ step(Z,S,T) : edge(S,S') } = 1 :- T = 1..global, start(Z,_,_,_).

:- step(Z,S,T), step(Z,S,T'),  T>T'.            % no repetitions
:- step(Z,S,T), step(Z,S',T+1), not edge(S,S'). % subsequent steps must form an edge

% overloaded step for compatibility
step(Z,(X,Y),D,T) :- step(Z,(X,Y,D),T).

#show step/3.
#show subnode/3.