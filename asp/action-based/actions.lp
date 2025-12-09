% flatland actions
action(train(ID), move_forward, T) :- do(ID,spawn,T).
action(train(ID), wait, T) :- do(ID,wait,T).
action(train(ID), move_left, T) :- do(ID,l,T), at(ID,(X,Y),D,T), cell((X,Y),Track), choice(Track,D).
action(train(ID), move_right, T) :- do(ID,r,T), at(ID,(X,Y),D,T), cell((X,Y),Track), choice(Track,D).
action(train(ID), move_forward, T) :- do(ID,M,T), not action(train(ID), move_left, T), not action(train(ID), move_right, T), not action(train(ID), wait, T).

#show action/3.
