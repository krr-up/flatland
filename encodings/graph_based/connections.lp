%*
    When given an environment, represent it as a grid
    connecting nodes that exist on the borders of cells

    To be consistent with Flatland, Y coordinates are given first.

    edge((10,15),(10,5)).
*%

% First, each track ID is given a set of connections
% connection(ID, N↔S, W↔E, N↔E, E↔S, S↔W, W↔N)

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


% Second, connect internodes to one another
% edge(node(), Facing1, node(), Facing2)
    % N↔S
    edge(node(A+5,B), n, node(A-5,B), n) :- cell((Y,X), Type), connection(Type,  1, _, _, _, _, _), A=Y*10, B=X*10.   
    edge(node(A-5,B), s, node(A+5,B), s) :- cell((Y,X), Type), connection(Type,  1, _, _, _, _, _), A=Y*10, B=X*10.

    % W↔E 
    edge(node(A,B-5), e, node(A,B+5), e) :- cell((Y,X), Type), connection(Type,  _, 1, _, _, _, _), A=Y*10, B=X*10.
    edge(node(A,B+5), w, node(A,B-5), w) :- cell((Y,X), Type), connection(Type,  _, 1, _, _, _, _), A=Y*10, B=X*10.

    % N↔E
    edge(node(A-5,B), s, node(A,B+5), e) :- cell((Y,X), Type), connection(Type,  _, _, 1, _, _, _), A=Y*10, B=X*10.
    edge(node(A,B+5), w, node(A-5,B), n) :- cell((Y,X), Type), connection(Type,  _, _, 1, _, _, _), A=Y*10, B=X*10.

    % E↔S
    edge(node(A,B+5), w, node(A+5,B), s) :- cell((Y,X), Type), connection(Type,  _, _, _, 1, _, _), A=Y*10, B=X*10.
    edge(node(A+5,B), n, node(A,B+5), e) :- cell((Y,X), Type), connection(Type,  _, _, _, 1, _, _), A=Y*10, B=X*10.

    % S↔W
    edge(node(A+5,B), n, node(A,B-5), w) :- cell((Y,X), Type), connection(Type,  _, _, _, _, 1, _), A=Y*10, B=X*10.
    edge(node(A,B-5), e, node(A+5,B), s) :- cell((Y,X), Type), connection(Type,  _, _, _, _, 1, _), A=Y*10, B=X*10.

    % W↔N
    edge(node(A,B-5), e, node(A-5,B), n) :- cell((Y,X), Type), connection(Type,  _, _, _, _, _, 1), A=Y*10, B=X*10.
    edge(node(A-5,B), s, node(A,B-5), w) :- cell((Y,X), Type), connection(Type,  _, _, _, _, _, 1), A=Y*10, B=X*10.    

    % wait
    edge(node(A,B), node(A,B), D)     :- edge(_,node(A,B),D).


% Third, transform starting and ending locations
% starting(ID, (A,B))   ending(ID, (A,B))
    offset(Da,Db) :- Da=(-5;0;5), Db=(-5;0;5), |Da+Db|=5.
    facing(5, 0, n).  facing(-5, 0, s).     
    facing(0,-5, e).  facing( 0, 5, w).
    starting(ID, node(A+Da,B+Db), N)   :- start(agent(ID),(Y,X),N,dir(D)), A=Y*10, B=X*10, facing(Da,Db,D).
    ending(ID, node(A+Da,B+Db), N)     :- end(agent(ID),(Y,X),N), A=Y*10, B=X*10, offset(Da,Db).


% Fourth, provide ability to convert nodes into cells
% node2cell(node(A,B), (Y,X), D).
    node2cell(node(A,B),(Y,X),D) :- edge(_,node(A,B),D), facing(Da,Db,D), Y=(A-Da)/10, X=(B-Db)/10.
    % ? not sure whether this works


% Fifth, provide information about which nodes have two outgoing edges
    %choice(A,D,C) :- C= #count{B: edge(A,B,D), A!=B}, edge(A,_,D).
    %choice(A,C,D) :- edge(A,B,_), C = #count{ D : node2cell(A,(Y,X),D) }. 
    choice(A,D) :- edge(A,D,_,_), #count{ B: edge(A,D,B,_), A!=B } > 1.

%#show choice/1.

%#show edge/4.