% choose first path based on starting location
path(ID,node(A1,B1),node(A2,B2),D,N+2) :- starting(ID,node(A1,B1),N), start(ID, _, _, D), facing(Da,Db,D), A2=A1-(Da*2), B2=B1-(Db*2).

% % choose path based on edges
{ path(ID,A,B,D2,T+1) : edge(A,D1,B,D2), train(ID) } = 1 :- path(ID,_,A,D1,T), starting(ID,_,Start), ending(ID,_,End), T=Start+2..End, not finished(ID,T).

% path must finish at at least one of the ending locations
finished(ID,T) :- ending(ID,B,_), path(ID,_,B,_,T).
% :- train(ID), not finished(ID,_).

% don't allow waiting
:- path(ID,A,B,_,T), A=B.

% do not allow backward movements
:- path(ID,A,B,_,T-1), path(ID,B,A,_,T).

% avoid collisions
:- path(ID1,_,B,_,T), path(ID2,_,B,_,T), not ID1=ID2.
:- path(ID1,A,B,_,T), path(ID2,C,B,_,T-1), not (ID1,A)=(ID2,C).

% :- not finished(0,_).
% :- not finished(1,_).
:- not finished(2,_).

% :- not	path(0,_,_,n,7).
% :- not	path(0,_,_,n,8).
% :- not	path(0,_,_,e,9).

% #show ending/3.
% #show path/5.
#show finished/2.