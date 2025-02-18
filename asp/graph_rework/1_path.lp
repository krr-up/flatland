% basic initialization
time(0..T) :- end(_,_,T).
at((X,Y),A,T2,D) :- start(A,(X,Y),T,D),time(T2), T2>=T.
% a train can stay at the same place
{at(V,A,T,D)} :- at(V,A,T-1,D), time(T).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T,Dnew)} :- at(V1,A, T-1,D), time(T),
	edge(V1,V2), trackpaths(V2,D,Dnew) . 
% if a train reaches its goal it leaves the map
at(end,A,T+1,n ) :- at(P,A,T,D), end(A,P,Tlast), Tlast>T.
% and all trains must reach an end
end(A):- at(end,A,_,_).
:- train(A), not end(A).

% do not exist twice
error(noend,A):- at(V,A,T,_), at(V2,A,T,_), V<V2.

% enforce vertex, edge and swap constraints
error(noend,A):- at(V,A,T,_), at(V,B,T,_), A<B.
error(noend,A):- at(V1,A,T,_), at(V2,B,T,_), A<B,
	at(V1,B,T+1,_), at(V2,A,T+1,_) .

#show error/2.
#show at/4.
