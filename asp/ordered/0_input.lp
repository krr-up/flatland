%% Auxilliary Atoms
agent(A) :- start(A,_,_,_).
time(0..T) :- end(_,_,T).

% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
trackparts(Pos,D1,D2) :- cell(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    T = (N / 16**N1) \ 16,
    1 = (T / 2**N2) \ 2.

% generate direction free nodes
vertex((X,Y),(X-X',Y-Y')) :- trackparts((X,Y),D,_), dir_move(D,(X',Y')).

% generate edges
edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))) :- vertex((X2,Y2),(X1,Y1)), vertex((X3,Y3),(X2,Y2)),
    trackparts((X2,Y2),D1,D2), dir_move(D1,(X1',Y1')), dir_move(D2,(X2',Y2')),
    X1+X1'=X2, Y1+Y1'=Y2,
    X2+X2'=X3, Y2+Y2'=Y3.

% check whether edges correspond to a turn
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),1) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 < (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),3) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 > (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).

% generate shared resources
shared_resource(vertex(At,From1),vertex(At,From2)) :- vertex(At,From1), vertex(At,From2).
shared_resource(edge(V1,V2),edge(V3,V4)) :- edge(V1,V2), edge(V3,V4),
    shared_resource(V1,V4), shared_resource(V2,V3).