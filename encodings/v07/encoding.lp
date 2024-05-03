% encoding - - -
% this file provides the logic for determining paths
% inside of a Flatland environment

% determine first two cells
at(agent(A), cell(X0,Y0), D, 0) :- start(agent(A), cell(X0,Y0), dir(D)).
at(agent(A), cell(X1,Y1), DD, 1) :- at(agent(A), cell(X0,Y0), D, 0), swap(D,From), offset((From,f), (DX,DY), DD), X1=X0+DX, Y1=Y0+DY.

% determine all subsequent moves
{ do(Agent,A,T) : move(A) } = 1 :- maxTime(M), agent(Agent), T=2..M.
at(agent(Agent), cell(X+DX,Y+DY), DD, T) :- do(Agent, A,T), at(agent(Agent), cell(X,Y), D, T-1), swap(D,From), cell((X,Y), Type), offset((From,A), (DX,DY), DD), type(Type, (From,A)).

% must reach the goal
:- end(agent(A), cell(X,Y)), not at(agent(A), cell(X,Y), _, _).

% must be a valid cell
:- at(_, cell(X,Y), D, T), not cell((X,Y), _).

% trains cannot crash
:- at(agent(A), cell(X,Y), _, T), at(agent(B), cell(X,Y), _, T), A<B.

% trains cannot swap
:- at(agent(A), cell(X,Y), _, T), at(agent(B), cell(X',Y'), _, T), at(agent(A), cell(X',Y'), _, T+1), at(agent(B), cell(X,Y), _, T+1), A<B.

%#show at/4.
%#show do/3.
%#show invalid/2.
