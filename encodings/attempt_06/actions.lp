%%clingo 0 test_env.lp -

% convert a path to a sequence of actions

% ROTATION
map(0,n). map(1,e). map(2,s). map(3,w).
orient(T,Map) :- at(_,Dir,T), map(Map,Dir).
rotation(R,T0) :- orient(T0,M0), orient(T1,M1), T1>T0, T1-T0=1, R=(M1-M0)\4.
    
% TRACK TYPE
track_type(T,switch) :- at(cell(X,Y),_,T), cell((X,Y),ID), ID = (37408;17411;32872;3089;49186;1097;34864;5633;38433;50211;33897;35889;38505;52275;20994;16458;2136;6672).
track_type(T,deadend) :- at(cell(X,Y),_,T), cell((X,Y),ID), ID = (8192;4;128;256).
track_type(T,nonswitch) :- at(cell(X,Y),_,T), not type(T,switch), not type(T,deadend). % may not need this
    
% MOVEMENT
move_left(T) :- rotation(-1,T), track_type(T,switch).
move_right(T):- rotation(1,T), track_type(T,switch).
   
#show.

%#show rotation/2.
#show stop_moving(T) : do(wait,T).
#show move_left/1.
#show move_right/1.
#show move_forward(T): track_type(T,Type), Type=nonswitch, not do(wait,T), not move_left(T), not move_right(T).
%#show move_forward(T): rotation(R,T), |R|=2, track_type(T,deadend).




%#show move_left(T) : do(l,T). 
%#show move_right(T) : do(r,T). 
%#show move_forward(T) : do(f,T). 

%#show stop_moving(T0) : at(C,T0,D), at(C,T1,D), T1-T0=1.

%.
%.

%