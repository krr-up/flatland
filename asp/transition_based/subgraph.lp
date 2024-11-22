% -- determine outgoing edges based on binary representation --

% perform a binary factorization
power_of_two(Exp,Dec) :- Exp = 0..15, Dec = 2**Exp.
powers(Vertex,Exp)    :- cell(Vertex,Track), power_of_two(Exp,Dec), Track & Dec > 0.

% determine the direction of outgoing edges from a vertex based on exponents
moving(w,(0;4;8;12)).
moving(s,(1;5;9;13)).
moving(e,(2;6;10;14)).
moving(n,(3;7;11;15)).
outgoing_edge(Vertex,D)  :- powers(Vertex,Exp), moving(D,Exp).

% directional offsets
offset(w,( 0,-1)).
offset(s,( 1, 0)).
offset(e,( 0, 1)).
offset(n,(-1, 0)).

% construct outgoing edges for each vertex
edge((X,Y),V2) :- 
    cell((X,Y),Track), 
    outgoing_edge(V1,D), 
    offset(D,(DX,DY)), 
    V2 = (X+DX,Y+DY).


% -- allow function : informs us which directions are permissible for traveling over a given edge

% determine the direction an agent had been facing
facing(w,(0;1;2;3)).
facing(s,(4;5;6;7)).
facing(e,(8;9;10;11)).
facing(n,(12;13;14;15)).

% given an edge, determine the possible starting directions
allow((X1,Y1),(X2,Y2),StartingDir) :- 
    edge((X1,Y1),(X2,Y2)), 
    DX=X2-X1, DY=Y2-Y1, 
    offset(MovingDir,(DX,DY)), 
    moving(MovingDir,Exp), 
    powers((X1,Y1),Exp), 
    facing(StartingDir,Exp).

% given an edge, determine the direction the agent is facing
direction((X1,Y1),(X2,Y2),D) :-
    DX=X2-X1, DY=Y2-Y1, 
    offset(D,(DX,DY)).