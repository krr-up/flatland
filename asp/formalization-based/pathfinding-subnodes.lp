#const h = 3.

{ path(Z,C,C',T) : edge(C,C') } = 1 :- start(Z,_,_,_), T = 1..h.

:- path(Z,C,_,T), not path(Z,_,C,T-1), T=2..h.
:- path(Z,C,C',T), path(Z,C,C',T'), T>T'.

:- start(Z,(X,Y),T,D), not path(Z,(X,Y,D),_,T+1).
%:- end(Z,(X,Y),_),     not path(Z,_,(X,Y,_),h).
:- end(Z,(X,Y),_),     not path(Z,_,(X,Y,_),_).

#show.
#show path(Z,C,T) : path(Z,C,_,T).
#show path(Z,C,T+1) : path(Z,_,C,T).
