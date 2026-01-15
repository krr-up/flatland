#const h = 3.

{ path(Z,C,C',T) : edge(C,C') } = 1 :- start(Z,_,_,_), T = 1..h.

:- path(Z,C,_,T), not path(Z,_,C,T-1), T=2..h.
:- path(Z,C,C',T), path(Z,C,C',T'), T>T'.

:- start(Z,C,T,_), not path(Z,C,_,T+1).
%:- end(Z,C,_),     not path(Z,_,C,h).
:- end(Z,C,_),     not path(Z,_,C,_).

:- path(Z,C,C',T), path(Z,C',C'',T+1), d(C,C',D), not p(C',C'',D).

#show.
#show path(Z,C,T) : path(Z,C,_,T).
#show path(Z,C,T+1) : path(Z,_,C,T).
