% determine first two cells
at(Z, cell(X0,Y0), 0, D) :- start(Z, cell(X0,Y0), dir(D)).
at(Z, cell(X1,Y1), 1, DD) :- at(Z, cell(X0,Y0), 0, D), swap(D,From), offset((From,f), (DX,DY), DD), X1=X0+DX, Y1=Y0+DY.

% determine all subsequent moves
{ do(A,Z,T) : move(A) } = 1 :- train(Z), maxTime(M), T=2..M.
at(Z, cell(X+DX,Y+DY), T, DD) :- do(A,Z,T), at(Z, cell(X,Y), T-1, D), swap(D,From), cell((X,Y), (Type,Rotation)), offset((From,A), (DX,DY), DD), type((Type,Rotation), (From,A)).

% must reach the goal
:- end(Z, cell(X,Y)), train(Z), not at(Z, cell(X,Y), _, _).

#show at/4.