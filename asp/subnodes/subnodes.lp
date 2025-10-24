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
connection(37408,   1, 0, 0, 0, 1, 0).  % etc.
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

%% -- CONNECTION PAIRS -- %%
pair(Type,D,D') :- pair(Type,D',D).
pair(Type,n,s)  :- connection(Type, 1, _, _, _, _, _).
pair(Type,w,e)  :- connection(Type, _, 1, _, _, _, _).
pair(Type,n,e)  :- connection(Type, _, _, 1, _, _, _).
pair(Type,e,s)  :- connection(Type, _, _, _, 1, _, _).
pair(Type,s,w)  :- connection(Type, _, _, _, _, 1, _).
pair(Type,w,n)  :- connection(Type, _, _, _, _, _, 1).

%% -- SUBNODES -- %%
subnode(X,Y,D) :- cell((X,Y),Type), connection(Type, _, _, _, _, _, _), pair(Type,D,_;Type,_,D).

%% -- EDGES -- %%
shift(n,-1, 0). shift(s, 1, 0). shift(w, 0,-1). shift(e, 0, 1).
flip(n,s).      flip(s,n).      flip(w,e).      flip(e,w).

edge((X+Dx,Y+Dy,F), (X,Y,To))   :-  cell((X,Y),Type), connection(Type, _, _, _, _, _, _), pair(Type,From,To), shift(From,Dx,Dy), flip(From,F). % N to N
decision(X,Y,D)                 :- subnode(X,Y,D), cell((X',Y'),_), #count{ D' : edge((X,Y,D),(X',Y',D')) } > 1.

%% -- PATH DEFINITION -- %%
:- step((X1,Y1),D1,T), step((X2,Y2),D2,T+1), not edge((X1,Y1,D1),(X2,Y2,D2)).
:- step((X,Y),D,T1), step((X,Y),D,T2), not T1=T2.

#show subnode/3.
#show edge/2.
#show decision/3.