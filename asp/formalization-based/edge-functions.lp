edge(C,C') :- connected(C,_,C').
node(C;C') :- edge(C,C').

p(C,C',D) :- connected(C,D,C'),
    cell(C,Type),
    transition(Type,(D,D')).
q(C,C',D) :- connected(C,D,C').

:- step(C,D,T), step(C',D',T+1), not edge(C,C').
:- step(C0,D0,T-1), step(C1,D1,T), step(C2,D2,T+1),
    q(C0,C1,D), not p(C1,C2,D).
:- step(C,D,T), step(C',D',T'), T!=T',
    step(C1,D1,T+1), step(C1',D1',T'+1),
    C1 = C1'.