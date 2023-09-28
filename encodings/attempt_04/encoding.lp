% determine first two cells
at(Z, cell(X0,Y0), 0, D) :- start(train(Z), cell(X0,Y0), dir(D)), train(Z).
at(Z, cell(X1,Y1), 1, DD) :- at(Z, cell(X0,Y0), 0, D), swap(D,From), offset((From,f), (DX,DY), DD), X1=X0+DX, Y1=Y0+DY.




% determine all subsequent moves
{ do(A,T) : move(A) } = 2 :- maxTime(M), T=2..M-1.
at(Z, cell(X+DX,Y+DY), T, DD) :- do(A,T), at(Z, cell(X,Y), T-1, D), swap(D,From), cell((X,Y), (Type,Rotation)), offset((From,A), (DX,DY), DD), type((Type,Rotation), (From,A)), cell((X+DX,Y+DY), _).

% must reach the goal
:- end(train(Z), cell(X,Y)), train(Z), not at(Z, cell(X,Y), _, _).

% eliminate unused do()
% :- do(A,T), not at(_, _, T, _).

#show at/4.
% #show do/2.