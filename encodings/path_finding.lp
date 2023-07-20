%%clingo 0 instances/potsdam.lp -

%possible actions and directions
move(forward). move(left). move(right).
dir(e). dir(w). dir(n). dir(s).

%offset movement - (∆X, ∆Y, current direction, action, resulting direction)
offset(( 1, 0), e, move(forward), e). % facing east
offset(( 0, 1), e, move(left), n).
offset(( 0,-1), e, move(right), s).
offset((-1, 0), w, move(forward), w). % facing west
offset(( 0,-1), w, move(left), s).
offset(( 0, 1), w, move(right), n).
offset(( 0, 1), n, move(forward), n). % facing north
offset((-1, 0), n, move(left), w).
offset(( 1, 0), n, move(right), e).
offset(( 0,-1), s, move(forward), s). % facing south
offset(( 1, 0), s, move(left), e).
offset((-1, 0), s, move(right), w).

%define starting & ending positions
maxTime(7).
start(cell(7,5), dir(w)).
end(cell(3,8)).

%the first two positions are determined
at(cell(X0,Y0), D, 0) :- start(cell(X0,Y0), dir(D)).
at(cell(X1,Y1), D, 1) :- at(cell(X0,Y0), D, 0), offset((DX,DY), D, move(forward), D), X1=X0+DX, Y1=Y0+DY.

%generate choice rules for each time step
{ do(A,T) : move(A) } = 1 :- maxTime(M), T=2..M.
at(cell(X+DX,Y+DY), D1, T) :- do(A,T), at(cell(X,Y), D, T-1), offset((DX,DY), D, move(A), D1).
    
%constraint - must follow a legal path
:- at(A, _, T0), at(B, _, T0+1), at(C, _, T0+2), not edge(A,B,C).
    
%constraint - train must end at goal
goal(T) :- at(cell(X,Y), _, T), end(cell(X,Y)).
:- not goal(T), maxTime(T).

#minimize { T : at(cell(X,Y),_,T) }.
#show step/3.
