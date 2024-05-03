% actions.lp - - -
% convert a path to a sequence of actions
% that Flatland can interpret

% ROTATION
map(0,n). map(1,e). map(2,s). map(3,w).
orient(Agent,T,Map) :- at(agent(Agent),_,Dir,T), map(Map,Dir).
rotation(Agent,R,T0) :- orient(Agent,T0,M0), orient(Agent,T1,M1), T1>T0, T1-T0=1, R=(M1-M0)\4.
    
% TRACK TYPE
track_type(Agent,T,switch)    :- at(agent(Agent),cell(X,Y),Dir,T), cell((X,Y),ID), not nochoice(ID, Dir), ID = (37408;17411;32872;3089;49186;1097;34864;5633;38433;50211;33897;35889;38505;52275;20994;16458;2136;6672).
track_type(Agent,T,deadend)   :- at(agent(Agent),cell(X,Y),_,T), cell((X,Y),ID), ID = (8192;4;128;256).
track_type(Agent,T,nonswitch) :- at(agent(Agent),cell(X,Y),_,T), not track_type(Agent,T,switch), not track_type(Agent,T,deadend).
    
% MOVEMENT
move_left(Agent,T) :- rotation(Agent,-1,T), track_type(Agent,T,switch).
move_left(Agent,T) :- rotation(Agent, 3,T), track_type(Agent,T,switch).
move_right(Agent,T):- rotation(Agent, 1,T), track_type(Agent,T,switch).
move_right(Agent,T):- rotation(Agent,-3,T), track_type(Agent,T,switch).
   
% WAIT
wait(Agent,T) :- at(agent(Agent),cell(X,Y),_,T), at(agent(Agent),cell(X,Y),_,T+1).
wait(Agent,T) :- at(agent(Agent),cell(X,Y),_,T), end(agent(Agent), cell(X,Y)).

#show.

#show stop_moving(Agent,T) : do(Agent,wait,T).
#show wait/2.
#show move_left/2.
#show move_right/2.
#show move_forward(Agent,T): track_type(Agent,T,Type), Type=nonswitch, not do(Agent,wait,T), not move_left(Agent,T), not move_right(Agent,T), not wait(Agent,T), agent(Agent).
%#show move_forward(T): rotation(R,T), |R|=2, track_type(T,deadend).