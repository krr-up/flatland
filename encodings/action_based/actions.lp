% flatland actions
action(agent(ID), move_forward, T) :- do(ID,spawn,T).
action(agent(ID), wait, T) :- do(ID,wait,T).
action(agent(ID), move_left, T) :- do(ID,l,T), at(ID,(X,Y),D,T), cell((X,Y),Type), choice(Type,D).
action(agent(ID), move_right, T) :- do(ID,r,T), at(ID,(X,Y),D,T), cell((X,Y),Type), choice(Type,D).
action(agent(ID), move_forward, T) :- do(ID,M,T), not action(agent(ID), move_left, T), not action(agent(ID), move_right, T), not action(agent(ID), wait, T).

%#show action/3.