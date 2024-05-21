%*
    Traverse the grid environment
*%


% choose first path based on starting location
{ path(ID,A,B,D,N+2) : starting(ID,A,N), edge(A,B,D) } = 1 :- agent(ID).

% choose path based on edges
{ path(ID,A,B,D,T+1) : edge(A,B,D), agent(ID) } = 1 :- path(ID,_,A,_,T), starting(ID,_,Start), ending(ID,_,End), T=Start+2..End, not finished(ID,T).

% path must finish at at least one of the ending locations
finished(ID,T) :- ending(ID,B,_), path(ID,_,B,_,T).
:- agent(ID), not finished(ID,_).

% for now: don't allow waiting
:- path(ID,A,B,_,T), A=B.

% avoid vertex conflicts
:- path(ID1,A1,B1,D1,T), path(ID2,A2,B2,D2,T), ID1!=ID2, node2cell(node(A1,B1),(Y1,X1),D1), node2cell(node(A2,B2),(Y2,X2),D2), (Y1,X1)=(Y2,X2).
:- path(ID1,A1,B1,D1,T), path(ID2,A2,B2,D2,T-1), ID1!=ID2, node2cell(node(A1,B1),(Y1,X1),D1), node2cell(node(A2,B2),(Y2,X2),D2), (Y1,X1)=(Y2,X2).

#show path/5.