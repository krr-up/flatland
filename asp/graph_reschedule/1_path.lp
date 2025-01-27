% initial state rules
time(0..T) :- end(_,_,T).

% movement
% a train can stay at the same place
{at( V, A, T)} :- at(V,A,T-1), time(T).

% a train may come to a diferent place if a vertex allows it to
{at( V2, A, T )} :- at( V1,A, T-1 ), edge(V1, V2), time(T). 
:- 2{at( V, A ,T):edge(V,_)}, train(A),time(T).

:- at(V1,A,T..T+1), at(V2,B,T..T+1), A<B, shared_resource(V1,V2), time(T).
:- at(V1,A,T), at(V2,A,T+1), at(V3,B,T), at(V4,B,T+1), A<B, shared_resource(edge(V1,V2),edge(V3,V4)).

% all trains must have ended their task
ended(A,T):- end(A,P,TLast), at(vertex(P,D),A,T), T<TLast.
:- train(A), not ended(A,_).
