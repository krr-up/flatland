%%clingo 0 test_env.lp -

% convert a path to a sequence of actions

% path             Expected results:
at(cell(0,0),0,e). %MOVE_FORWARD
at(cell(1,0),1,e). %MOVE_LEFT
at(cell(1,1),2,n). %STOP_MOVING
at(cell(1,1),3,n). %MOVE_FORWARD
at(cell(2,1),4,e). % --> move_forward(0) move_left(1) stop_moving(2) move_forward(3)

% ROTATION
map(0,n). map(1,e). map(2,s). map(3,w).
orient(T,Map) :- at(_,T,Dir), map(Map,Dir).
rotation(T0,R) :- orient(T0,M0), orient(T1,M1), T1>T0, T1-T0=1, R=M1-M0\4.
    
% TRACK TYPE
type(T,switch) :- at(cell(X,Y),T,_), cell((X,Y),ID), ID = (37408;17411;32872;3089;49186;1097;34864;5633;38433;50211;33897;35889;38505;52275;20994;16458;2136;6672).
type(T,deadend) :- at(cell(X,Y),T,_), cell((X,Y),ID), ID = (8192;4;128;256).
type(T,nonswitch) :- at(cell(X,Y),T,_), not type(T,switch), not type(T,deadend). % may not need this
    
% MOVEMENT
movement(T0,M) :- at(cell(X0,Y0), T0, _), at(cell(X1,Y1), T1, _), T1>T0, T1-T0=1, M=|(X1+Y1)-(X0+Y0)|.
   
#show.
#show stop_moving(T0) : at(C,T0,D), at(C,T1,D), T1-T0=1.

#show move_left(T) : rotation(T,-1), type(T,switch).
#show move_right(T): rotation(T,1), type(T,switch).

#show move_forward(T): movement(T,1), not type(T,switch).
#show move_forward(T): rotation(T,R), |R|=2, type(T,deadend).
