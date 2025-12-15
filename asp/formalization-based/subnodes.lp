subnode(X,Y,D) :- cell((X,Y),T), transition(T, (_,D)).

edge((X,Y,D), (X',Y',D')) :-
    subnode(X,Y,D), subnode(X',Y',D'),
    connected((X,Y),D,(X',Y')),
    cell((X',Y'), T'), transition(T', (D,D')).
