%% -- EXAMPLE ENVIRONMENT -- %%

% cell((0,0), 16386).
% cell((0,1), 1025).
% cell((0,2), 4608).

% cell((1,0), 32800).
% cell((1,1), 0).
% cell((1,2), 32800).

% cell((2,0), 32872).
% cell((2,1), 1025).
% cell((2,2), 34864).

% cell((3,0), 72).
% cell((3,1), 1025).
% cell((3,2), 2064).

% start(0, (1,0), s, 0).
% end(0, (0,1), 8).
% global(10).


%% -- transitions.lp -- %%

%                   NS WE NE ES SW WN

% Track Type 1 - Straight
connection(32800,   1, 0, 0, 0, 0, 0).  % north to south
connection(1025,    0, 1, 0, 0, 0, 0).  % west to east

% Track Type 8 - Curve
connection(4608,    0, 0, 0, 0, 1, 0).  % south to west    
connection(16386,   0, 0, 0, 1, 0, 0).  % east to south
connection(72,      0, 0, 1, 0, 0, 0).  % north to east
connection(2064,    0, 0, 0, 0, 0, 1).  % west to north

% Track Type 2 - Simple switch (left)
connection(37408,   1, 0, 0, 0, 1, 0).
connection(17411,   0, 1, 0, 1, 0, 0).
connection(32872,   1, 0, 1, 0, 0, 0).
connection(3089,    0, 1, 0, 0, 0, 1).

% Track Type 9 - Simple switch (right)
connection(49186,   1, 0, 0, 1, 0, 0).
connection(1097,    0, 1, 1, 0, 0, 0).
connection(34864,   1, 0, 0, 0, 0, 1).
connection(5633,    0, 1, 0, 0, 1, 0).

% Track Type 3 - Diamond crossing
connection(33825,   1, 1, 0, 0, 0, 0).

% Track Type 4 - Single-slip switch
connection(38433,   1, 1, 0, 0, 1, 0).
connection(50211,   1, 1, 0, 1, 0, 0).
connection(33897,   1, 1, 1, 0, 0, 0).
connection(35889,   1, 1, 0, 0, 0, 1).

% Track Type 5 - Double-slip switch
connection(38505,   1, 1, 1, 0, 1, 0).
connection(52275,   1, 1, 0, 1, 0, 1).

% Track Type 6 - Symmetrical switch
connection(20994,   0, 0, 0, 1, 1, 0).
connection(16458,   0, 0, 1, 1, 0, 0).
connection(2136,    0, 0, 1, 0, 0, 1).
connection(6672,    0, 0, 0, 0, 1, 1).



%% -- TRANSFORMATIONS -- %%

%% -- SUBNODES -- %%
subnode(X,Y,n) :- cell((X,Y),Type), connection(Type, 1, _, _, _, _, _; Type, _, _, _, 1, _, _; Type, _, _, _, _, 1, _).
subnode(X,Y,w) :- cell((X,Y),Type), connection(Type, _, 1, _, _, _, _; Type, _, _, _, 1, _, _; Type, _, _, 1, _, _, _).
subnode(X,Y,e) :- cell((X,Y),Type), connection(Type, _, 1, _, _, _, _; Type, _, _, _, _, 1, _; Type, _, _, _, _, _, 1).
subnode(X,Y,s) :- cell((X,Y),Type), connection(Type, 1, _, _, _, _, _; Type, _, _, 1, _, _, _; Type, _, _, _, _, _, 1).

%% -- EDGES -- %%
shift(n,-1, 0). shift(s, 1, 0). shift(w, 0,-1). shift(e, 0, 1).

edge((X,Y,n),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, 1, _, _, _, _, _), D=n, shift(D,Dx,Dy). % N to N
edge((X,Y,s),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, 1, _, _, _, _, _), D=s, shift(D,Dx,Dy). % S to S

edge((X,Y,w),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, 1, _, _, _, _), D=w, shift(D,Dx,Dy). % W to W
edge((X,Y,e),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, 1, _, _, _, _), D=e, shift(D,Dx,Dy). % E to E

edge((X,Y,w),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, 1, _, _, _), D=n, shift(D,Dx,Dy). % W to N
edge((X,Y,s),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, 1, _, _, _), D=e, shift(D,Dx,Dy). % S to E

edge((X,Y,w),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, 1, _, _), D=s, shift(D,Dx,Dy). % W to S
edge((X,Y,n),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, 1, _, _), D=e, shift(D,Dx,Dy). % N to E

edge((X,Y,e),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, _, 1, _), D=s, shift(D,Dx,Dy). % E to S
edge((X,Y,n),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, _, 1, _), D=w, shift(D,Dx,Dy). % N to W

edge((X,Y,e),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, _, _, 1), D=n, shift(D,Dx,Dy). % E to N
edge((X,Y,s),(X+Dx,Y+Dy,D)) :- cell((X,Y),Type), connection(Type, _, _, _, _, _, 1), D=w, shift(D,Dx,Dy). % S to W


decision(X,Y,D) :- subnode(X,Y,D), #count{ D' : edge((X,Y,D),(_,_,D')) } > 1.


% we should expect:
% subnode(0,2,s) and subnode(0,2,n) and subnode(0,2,w) but not subnode(0,2,e)


%% -- PATHFINDING -- %%
% { select(Z,X,Y,D,C) : C=(0;1) } = 1 :- start(Z,_,_,_), decision(X,Y,D).

% at(Z,X,Y,T) :- start(Z,(X,Y),_,T).                          % first position
% at(Z,X+Dx,Y+Dy,T+1) :- start(Z,(X,Y),D,T), shift(D,Dx,Dy).  % second position (deterministic)





% #show at/4.
% #show select/5.
#show subnode/3.
#show edge/2.
#show decision/3.
% #show connection/7.