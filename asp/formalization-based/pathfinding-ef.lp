% work in progress!!!
#const global = 3.

{ step(Z,C,T) : edge(C,C') } = 1 :- T = 1..global, start(Z,_,_,_).

:- step(Z,C0,T-1), step(Z,C,T), step(Z,C',T+1), q(C0,C,D), not p(C,C',D).
:- step(Z,C,T), step(Z,C',T-1), q(C',C,D),
    step(Z,C,T'), step(Z,C'',T'-1), q(C'',C,D'), 
    not D=D'.  % no repetitions

#show step/3.   