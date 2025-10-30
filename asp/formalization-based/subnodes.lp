% -- SUBNODES & EDGES -- %
subnode(X,Y,D)                  :-  cell((X,Y),Type), htc(Type, (D,_); Type, (_,D)).
edge((X1,Y1,D1), (X2,Y2,D2))    :-  subnode(X1,Y1,D1), subnode(X2,Y2,D2),               % (c,d) and (c',d')
                                    connected((X1,Y1),D1,(X2,Y2)),                      % connectedness rule
                                    cell((X2,Y2), Type2), htc(Type2, (D1,D2)).          % (d,d") in Htc' and d" is fixed

decision(X,Y,D)                 :-  subnode(X,Y,D), cell((X',Y'),_), #count{ D' : edge((X,Y,D),(X',Y',D')) } > 1.

% -- PATH DEFINITION -- %
:- step((X1,Y1),D1,T), step((X2,Y2),D2,T+1), not edge((X1,Y1,D1),(X2,Y2,D2)).
:- step((X,Y),D,T1), step((X,Y),D,T2), not T1=T2.

#show edge/2.