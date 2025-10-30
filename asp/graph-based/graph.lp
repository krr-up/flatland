% each track ID is given a set of connections
% connection(ID, N/S, W/E, N/E, E/S, S/W, W/N)

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

% connect nodes to one another
% N/S
edge(node(A+5,B), n, node(A-5,B), n) :- cell((Y,X), Track), connection(Track,  1, _, _, _, _, _), A=Y*10, B=X*10.   
edge(node(A-5,B), s, node(A+5,B), s) :- cell((Y,X), Track), connection(Track,  1, _, _, _, _, _), A=Y*10, B=X*10.

% W/E 
edge(node(A,B-5), e, node(A,B+5), e) :- cell((Y,X), Track), connection(Track,  _, 1, _, _, _, _), A=Y*10, B=X*10.
edge(node(A,B+5), w, node(A,B-5), w) :- cell((Y,X), Track), connection(Track,  _, 1, _, _, _, _), A=Y*10, B=X*10.

% N/E
edge(node(A-5,B), s, node(A,B+5), e) :- cell((Y,X), Track), connection(Track,  _, _, 1, _, _, _), A=Y*10, B=X*10.
edge(node(A,B+5), w, node(A-5,B), n) :- cell((Y,X), Track), connection(Track,  _, _, 1, _, _, _), A=Y*10, B=X*10.

% E/S
edge(node(A,B+5), w, node(A+5,B), s) :- cell((Y,X), Track), connection(Track,  _, _, _, 1, _, _), A=Y*10, B=X*10.
edge(node(A+5,B), n, node(A,B+5), e) :- cell((Y,X), Track), connection(Track,  _, _, _, 1, _, _), A=Y*10, B=X*10.

% S/W
edge(node(A+5,B), n, node(A,B-5), w) :- cell((Y,X), Track), connection(Track,  _, _, _, _, 1, _), A=Y*10, B=X*10.
edge(node(A,B-5), e, node(A+5,B), s) :- cell((Y,X), Track), connection(Track,  _, _, _, _, 1, _), A=Y*10, B=X*10.

% W/N
edge(node(A,B-5), e, node(A-5,B), n) :- cell((Y,X), Track), connection(Track,  _, _, _, _, _, 1), A=Y*10, B=X*10.
edge(node(A-5,B), s, node(A,B-5), w) :- cell((Y,X), Track), connection(Track,  _, _, _, _, _, 1), A=Y*10, B=X*10. 

% connect nodes to themselves
edge(node(A,B), D, node(A,B), D) :- edge(node(A,B), D, node(_,_), _).

% transform starting and ending locations
offset(Da,Db) :- Da=(-5;0;5), Db=(-5;0;5), |Da+Db|=5.
facing(5, 0, n).  facing(-5, 0, s).     
facing(0,-5, e).  facing( 0, 5, w).
starting(ID, node(A+Da,B+Db), N)   :- start(ID,(Y,X),N,D), A=Y*10, B=X*10, facing(Da,Db,D).
ending(ID, node(A+Da,B+Db), N)     :- end(ID,(Y,X),N), A=Y*10, B=X*10, offset(Da,Db).

% provide information about which nodes have two outgoing edges
choice(A,D) :- edge(A,D,_,_), #count{ B: edge(A,D,B,_), A!=B } > 1.
