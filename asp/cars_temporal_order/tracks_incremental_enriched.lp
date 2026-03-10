% There are four cardinal directions:
% 0 = North, 1 = West, 2 = South, 3 = East
% numeric directions
n_dir(0..3).
% alphabetic directions
dir(n;w;s;e).
% mapping between numeric and alphabetic directions
dirmap(0, n).
dirmap(1, w).
dirmap(2, s).
dirmap(3, e).
% Four increments for counterclockwise rotation: 0, 90, 180, 270 degrees
rotation(0..3).

% TRACK AND CONNECTION DEFINITION
% track(ID, T, V, Rot): track with id ID of Type T (and variant V), rotated Rot times by 90 degrees (counterclockwise)
% connection(ID, A, In, Out): track with identifier ID allows transitions for a train facing In to change direction to Out via action A

% IDs of straight tracks (type 1) for easy reference
straight(ID) :- track(ID, 1, _, _).

% Type 1 (variant 1): Straight track
track(32800, 1, 1, 0). connection(32800, move_forward, 0, 0).
                       connection(32800, move_forward, 2, 2).
track(1025,  1, 1, 1).

% Type 1 (variant 2): Bend
track(4608,  1, 2, 0). connection(4608, move_forward, 3, 2).
                      connection(4608, move_forward, 0, 1).
track(16386, 1, 2, 1).
track(72,    1, 2, 2).
track(2064,  1, 2, 3).

% Type 2 (variant 1): Simple switch 
track(37408, 2, 1, 0). connection(37408, move_left, 0, 1). connection(37408, move_forward, 2, 2). connection(37408, move_forward, 0, 0).
                       connection(37408, move_forward, 3, 2). connection(37408, move_forward, 0, 0).
track(17411, 2, 1, 1).
track(32872, 2, 1, 2).
track(3089, 2, 1, 3).

% Type 2 (variant 2): Simple switch
track(49186, 2, 2, 0). connection(49186, move_right, 0, 3). connection(49186, move_forward, 2, 2).
                       connection(49186, move_forward, 1, 2). connection(49186, move_forward, 0, 0).
track(1097, 2, 2, 1).
track(34864, 2, 2, 2).
track(5633, 2, 2, 3).

% Type 3: Diamond crossing
track(33825, 3, 1, 0).
connection(33825, move_forward, D, D) :- n_dir(D).

% Type 4: Single-slip switch
track(38433, 4, 1, 0).
connection(38433, move_forward, D, D) :- n_dir(D).
connection(38433, move_right, 3, 2). connection(38433, 0, 1, move_left).

track(50211, 4, 1, 1).
track(33897, 4, 1, 2).
track(35889, 4, 1, 3).

% Type 5: Double-slip switch
track(38505, 5, 1, 0).
connection(38505, move_forward, D, D) :- n_dir(D).
connection(38505, move_left, 0, 1). connection(38505, move_right, 3, 2).
connection(38505, move_right, 1, 0). connection(38505, move_left, 2, 3).

track(52275, 5, 1, 1).

% Type 6: Symmetrical Switch
track(20994, 6, 1, 0). connection(20994, move_left, 0, 1). connection(20994, move_right, 0, 3).
                       connection(20994, move_forward, 1, 2). connection(20994, move_forward, 3, 2).
track(16458, 6, 1, 1).
track(2136, 6, 1, 2).
track(6672, 6, 1, 3).

% rotate(RotD, Dir, Rot): direction RotD is obtained by rotating direction Dir counterclockwise by Rot × 90 degrees
rotate(RotD, Dir, Rot) :-
    n_dir(RotD), n_dir(Dir), rotation(Rot),
    RotD = (Dir + Rot) \ 4.

% infer all connections based on rotation of the 0 degree track ID for each type and variant cluster
connection(ID, A, In, Out) :- 
                        track(ID0, T, V, 0),
                        connection(ID0, A, In0, Out0),
                        track(ID, T, V, Rot),
                        rotate(In, In0, Rot),
                        rotate(Out, Out0, Rot).

% introduce new connections referring to alphabetic cardinal directions `n, w, s, e`
connection(ID, A, InV, OutV) :-
    connection(ID, A, In, Out),
    dirmap(In, InV),
    dirmap(Out, OutV).

% cell_conn(A, C0, In, C1, Out): Cell C0 allows action A when entering from direction In to reach cell C1 exiting in direction Out
cell_conn(A, C0, In, C1, Out) :- 
    cell(C0, Track), 
    connection(Track, A, In, Out),
    C1 = (Y1,X1),
    C0 = (Y0,X0),
    move(Out, DY, DX),
    Y1 = Y0 + DY,
    X1 = X0 + DX.

% introduce `wait` actions for cells were a non-straight track is in Out direction
cell_conn(wait, (Y,X), In, (Y,X), In) :-
    cell((Y,X), Track0),
    connection(Track0, move_forward, In, Out),
    straight(Track0),
    move(Out, DY, DX),
    Y1 = Y + DY, X1 = X + DX,
    cell((Y1,X1), Track1),
    not straight(Track1).

cell_conn(wait, C, In, C, In) :-
    station(C),
    cell(C, Track),
    connection(Track, _, In, _).

%wait_cell(C) :- cell_conn(C, wait, In, Out).

%#show wait_cell/1.

% -------------STATE PROPAGATION-------------
% move(D, Y, X): moving in direction D changes grid location by Y (row) and X (column)
move(s,  1,  0).
move(n, -1,  0).
move(w,  0, -1).
move(e,  0,  1).