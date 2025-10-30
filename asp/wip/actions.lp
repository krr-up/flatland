connected(tpair(C1,D1,T1),tpair(C2,D2,T1+1))  :-    tpair(C1,D1,T1),tpair(C2,D2,T1+1),
                                                    adjacent(C1,D2,C2),                                         % the two cells are adjacent
                                                    cell(C1,Type1), transition(Type1,(_,D2)),                   % there is a transition from the first cell to the second
                                                    cell(C2,Type2), transition(Type2,(_,Comp)), comp(D2,Comp).  % there is a transition from the second cell to the first


action(T1,forward) :-   tpair(C1,D1,T1), tpair(C2,D2,T1+1),
                        cell(C1,Type), #count{ Transition : transition(Type,Transition)} = 2.

action(T1,forward) :-   tpair(C1,D1,T1), tpair(C2,D2,T1+1),
                        cell(C1,Type), #count{ Transition : transition(Type,Transition)} > 2,
                        D2=D1.

shiftleft(n,w). shiftleft(w,s). shiftleft(s,e), shiftleft(e,n).
action(T1,left) :-  tpair(C1,D1,T1), tpair(C2,D2,T1+1),
                    cell(C1,Type), #count{ Transition : transition(Type,Transition)} > 2,
                    shiftleft(D1,Left), D2=Left.

shiftright(n,e).    shiftright(w,n).    shiftright(s,w),    shiftright(e,s).
action(T1,right) :- tpair(C1,D1,T1), tpair(C2,D2,T1+1),
                    cell(C1,Type), #count{ Transition : transition(Type,Transition)} > 2,
                    shiftright(D1,Right), D2=Right.

#show action/2.