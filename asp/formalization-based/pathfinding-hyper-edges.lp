#const h = 3.

{ path(Z,C,C',C'',T) : hyperedge(C,C',C'') } = 1 :- start(Z,_,_,_), T = 1..h.

:- path(Z,C,C',_,T), not path(Z,_,C,C',T-1), T=2..h.
:- path(Z,C,C',_,T), path(Z,C,C',_,T'), T>T'.

:- path(Z,C,C',_,1), not hyperedge(_,C,C').
:- path(Z,C,_ ,_,1), not hyperedge(_,_,C ).
:- path(Z,_,C,C',h), not hyperedge(C,C',_).
:- path(Z,_,_,C, h), not hyperedge(C,_,_ ).

:- start(Z,C,T,_), not path(Z,C,_,_,T+1).
:- end(Z,C,_),     not path(Z,_,_,C,h).

#show.
#show path(Z,C,T) : path(Z,C,_,_,T).
#show path(Z,C,T+1) : path(Z,_,C,_,T).
#show path(Z,C,T+2) : path(Z,_,_,C,T).
