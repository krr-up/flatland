% determine first two cells
at(cell(X0,Y0), 0, D) :- start(cell(X0,Y0), dir(D)).
at(cell(X1,Y1), 1, DD) :- at(cell(X0,Y0), 0, D), swap(D,From), offset((From,f), (DX,DY), DD), X1=X0+DX, Y1=Y0+DY.

% determine all subsequent moves
{ do(A,T) : move(A) } = 1 :- maxTime(M), T=2..M.
at(cell(X+DX,Y+DY), T, DD) :- do(A,T), at(cell(X,Y), T-1, D), swap(D,From), cell((X,Y), Type), offset((From,A), (DX,DY), DD), type(Type, (From,A)).

% must reach the goal
:- end(cell(X,Y)), not at(cell(X,Y), _, _).

% must be a valid cell
invalid(X,Y) :- at(cell(X,Y), T, D), not cell((X,Y), _).
:- invalid(X,Y).

#show at/3.
#show invalid/2.