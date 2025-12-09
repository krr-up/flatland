shift(n,-1, 0). shift(s, 1, 0). shift(w, 0,-1). shift(e, 0, 1).
comp(n,s).      comp(s,n).      comp(w,e).      comp(e,w).
adjacent(C,D,C')    :-  cell(C,_), cell(C',_), 
                        C=(X1,Y1), C'=(X2,Y2),
                        shift(D,DX,DY),
                        X2=X1+DX, Y2=Y1+DY.


connected(tpair(C1,D1,T1),tpair(C2,D2,T1+1))  :-    tpair(C1,D1,T1),tpair(C2,D2,T1+1),
                                                    adjacent(C1,D2,C2),                                         % the two cells are adjacent
                                                    cell(C1,Type1), transition(Type1,(_,D2)),                   % there is a transition from the first cell to the second
                                                    cell(C2,Type2), transition(Type2,(_,Comp)), comp(D2,Comp).  % there is a transition from the second cell to the first