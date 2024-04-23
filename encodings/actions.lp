% flatland actions
action(agent(A),move_forward,1) :- agent(A).
action(agent(A),move_forward,T+1) :- do(A,f,T).
action(agent(A),move_forward,T+1) :- do(A,M,T), at(agent(A),(X,Y),D,T), cell((X,Y),Type), Type=(4608;16386;72;2064).  %moving along a curve
action(agent(A),move_forward,T+1) :- do(A,M,T), at(agent(A),(X,Y),D,T), cell((X,Y),Type),                         M=(l;r), nochoice(Type,D), not action(agent(A),move_left,T), not action(agent(A),move_right,T).                             %moving along a switch, but with no decision
action(agent(A),move_left,   T+1) :- do(A,l,T), at(agent(A),(X,Y),D,T), cell((X,Y),Type), not action(agent(A),move_forward,T),      not nochoice(Type,D).          %moving along a switch
action(agent(A),move_right,  T+1) :- do(A,r,T), at(agent(A),(X,Y),D,T), cell((X,Y),Type), not action(agent(A),move_forward,T),      not nochoice(Type,D).          %moving along a switch
action(agent(A),wait,        T+1) :- do(A,wait,T).
