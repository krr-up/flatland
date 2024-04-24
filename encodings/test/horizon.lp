% the number of cells with tracks is the maximum time horizon without waits
tracks(T) :- T = #count{ 1,X,Y : cell((X,Y),Type), Type != 0}.

% the distance between start and end is the minimum time horizon for an agent
distance(D,ID) :- start(agent(ID), (X1,Y1), _), end(agent(ID), (X2,Y2)), DX=|X2-X1|, DY=|Y2-Y1|, D=DX+DY.

