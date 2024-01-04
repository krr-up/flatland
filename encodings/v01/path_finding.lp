%possible actions and directions
move(forward). move(left). move(right).
dir(e). dir(w). dir(n). dir(s).

%offset movements
offset(( 1, 0), e, move(forward), e).   % facing east
    offset(( 0, 1), e, move(left), n).
    offset(( 0,-1), e, move(right), s).   
offset((-1, 0), w, move(forward), w).   % facing west
    offset(( 0,-1), w, move(left), s).
    offset(( 0, 1), w, move(right), n).
offset(( 0, 1), n, move(forward), n).   % facing north
    offset((-1, 0), n, move(left), w).
    offset(( 1, 0), n, move(right), e).
offset(( 0,-1), s, move(forward), s).   % facing south
    offset(( 1, 0), s, move(left), e).
    offset((-1, 0), s, move(right), w).

%define starting & ending position
maxTime(16).
start(cell(16,5), dir(w)).
end(cell(3,8)).

%build out possible paths
at(cell(X0,Y0), 0, D) :- start(cell(X0,Y0), dir(D)).
at(cell(X1,Y1), 1, D) :- at(cell(X0,Y0), 0, D), offset((DX,DY), D, move(forward), D), X1=X0+DX, Y1=Y0+DY.

{ do(A,T) : move(A) } = 1 :- maxTime(M), T=2..M.
at(cell(X,Y), T, D) :- do(A,T), at(cell(X0,Y0), T-1, D0), offset((DX,DY), D0, move(A), D), X=X0+DX, Y=Y0+DY.
    
%constraint - must follow a legal path
:- at(A, T0, _), at(B, T0+1, _), at(C, T0+2, _), not edge(A,B,C).
    
%we want the train to end at the goal
goal(T) :- at(cell(X,Y), T, _), end(cell(X,Y)).
:- not goal(T), maxTime(T).

%#minimize { T : at(cell(X,Y),T,_) }.
#show at/3.