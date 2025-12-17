transition(T,(D,D')) :- connection(T,(D',D'')), inverse(D'',D).
transition(T,(D,D')) :- connection(T,(D'',D')), inverse(D'',D).

adjacent((X,Y),D,(X',Y')) :- cell((X,Y),_),
    offset(D,Dx,Dy), X'=X+Dx, Y'=Y+Dy, cell((X',Y'),_).

connected((X,Y),D,(X',Y')) :- cell((X,Y),T), cell((X',Y'),T'),
    adjacent((X,Y),D,(X',Y')),
    transition(T,(D',D)), transition(T',(D,D'')).
