edge(C,C') :- connected(C,_,C').
node(C;C') :- edge(C,C').

d(C,C',D) :- connected(C,D,C').
p(C,C',D) :- connected(C,D',C'), cell(C,T), transition(T,(D,D')).
