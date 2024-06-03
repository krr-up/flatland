%*
    Traverse the grid environment
*%


% choose first path based on starting location
%{ path(ID,A,B,D2,N+2) : starting(ID,A,N), edge(A,D1,B,D2) } = 1 :- agent(ID), start(agent(ID), _, _, dir(D)), facing(Da,Db,D).
path(ID,node(A1,B1),node(A2,B2),D,N+2) :- starting(ID,node(A1,B1),N), start(agent(ID), _, _, dir(D)), facing(Da,Db,D), A2=A1-(Da*2), B2=B1-(Db*2).

% choose path based on edges
{ path(ID,A,B,D2,T+1) : edge(A,D1,B,D2), agent(ID) } = 1 :- path(ID,_,A,D1,T), starting(ID,_,Start), ending(ID,_,End), T=Start+2..End, not finished(ID,T).

% path must finish at at least one of the ending locations
finished(ID,T) :- ending(ID,B,_), path(ID,_,B,_,T).
:- agent(ID), not finished(ID,_).

% for now: don't allow waiting
:- path(ID,A,B,_,T), A=B.

% do not allow backward movements
%backward(n,s). backward(s,n). backward(w,e). backward(e,w). 
:- path(ID,A,B,_,T-1), path(ID,B,A,_,T).

% avoid collisions
% traditional edge conflict (node conflict)
:- path(ID1,A,B,_,T), path(ID2,C,B,_,T), not (ID1,A)=(ID2,C).
:- path(ID1,A,B,_,T), path(ID2,C,B,_,T-1), not (ID1,A)=(ID2,C).

% traditional vertex conflict



%:- path(ID1,A1,B1,D1,T), path(ID2,A2,B2,D2,T), ID1!=ID2, node2cell(node(A1,B1),(Y1,X1),D1), node2cell(node(A2,B2),(Y2,X2),D2), (Y1,X1)=(Y2,X2).
%:- path(ID1,A1,B1,D1,T), path(ID2,A2,B2,D2,T-1), ID1!=ID2, node2cell(node(A1,B1),(Y1,X1),D1), node2cell(node(A2,B2),(Y2,X2),D2), (Y1,X1)=(Y2,X2).


%choiceat(T) :- path(ID,A,B,D,T), choice(A,D).

%#show path/5.