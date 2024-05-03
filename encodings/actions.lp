% wait factor
%action(agent(ID), wait, 0..Start-1) :- start(agent(ID),_,Start,_).

% flatland actions
%action(agent(ID), move_forward, Start-1) :- at(agent(ID),(X,Y),D,0+Start), factor(ID,Start,End).
action(agent(ID), move_forward, T) :- do(ID,spawn,T).
%action(agent(ID), move_forward, Start) :- at(ID,(X,Y),D,1+Start), factor(ID,Start,End).
action(agent(ID), wait, T) :- do(ID,wait,T).
action(agent(ID), move_left, T) :- do(ID,l,T), at(ID,(X,Y),D,T), cell((X,Y),Type), choice(Type,D).
action(agent(ID), move_right, T) :- do(ID,r,T), at(ID,(X,Y),D,T), cell((X,Y),Type), choice(Type,D).
action(agent(ID), move_forward, T) :- do(ID,M,T), not action(agent(ID), move_left, T), not action(agent(ID), move_right, T), not action(agent(ID), wait, T+1).

%#show action/3.