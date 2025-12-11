#const global = 2.

{ path(Z,(C1,C2,C3),T) : hyperedge(C1,C2,C3) } = 1 :- T = 1..global, start(Z,_,_,_).

:- path(Z,(C1,C2,C3),T), path(Z,(C2',C3',C4'),T+1), not C2=C2', not C3=C3'.

#show path/3.