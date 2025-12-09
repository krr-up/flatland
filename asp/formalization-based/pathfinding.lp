% pathfinding

% starting sub-node
start_node(ID,X,Y,D,Dep) :- start(ID, (X,Y), Dep, D).

{ spawn(ID,T) : T = Dep..Arr } = 1 :- train(ID), start(ID, _, Dep, D), end(ID,_,Arr).

at(ID,X,Y,D,T) :- spawn(ID,T), start_node(ID,X,Y,D,_).

{ select(ID,X',Y',D',T) : edge((X,Y,D),(X',Y',D')) } = 1 :- at(ID,X,Y,D,T-1).
at(ID,X,Y,D,T) :- select(ID,X,Y,D,T).


#show start_node/5.
#show spawn/2.