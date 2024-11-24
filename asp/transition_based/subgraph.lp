% Directional offsets
offset(w, ( 0,-1)).
offset(s, ( 1, 0)).
offset(e, ( 0, 1)).
offset(n, (-1, 0)).

%%% Find all outgoing edges for a cell

    % Binary factorization
    binary_factors(Exp,Dec) :- Exp = 0..15, Dec = 2**Exp.
    powers(Track,Bin) :- 
        cell(Vertex,Track), 
        binary_factors(Bin,Dec), 
        Track & Dec > 0.

    % Binary offsets
    bin_offset((0;4;8;12), w). % offset facing west
    bin_offset((1;5;9;13), s). % offset facing south
    bin_offset((2;6;10;14),e). % offset facing east
    bin_offset((3;7;11;15),n). % offset facing north

    % Outgoing edges per cell
    edge((X1,Y1),(X2,Y2)) :- 
        cell((X1,Y1),Track),
        powers(Track,Bin), 
        bin_offset(Bin,Offset), 
        offset(Offset, (DX,DY)), 
        X2 = DX+X1, Y2 = DY+Y1.

%%% Find resulting direction after traversing over edge

    resulting((X1,Y1),(X2,Y2),D) :- 
        edge((X1,Y1),(X2,Y2)),
        DX = X2-X1, DY= Y2-Y1,
        offset(D,(DX,DY)).

%%% Find which direction train must face to traverse edge
    origin_offset((0;1;2;3),w).
    origin_offset((4;5;6;7),s).
    origin_offset((8;9;10;11),e).
    origin_offset((12;13;14;15),n).

    allowable((X1,Y1),(X2,Y2),D) :-
        edge((X1,Y1),(X2,Y2)), resulting((X1,Y1),(X2,Y2),R),
        cell((X1,Y1),Track), powers(Track,Bin),
        bin_offset(Bin,R), origin_offset(Bin,D).
