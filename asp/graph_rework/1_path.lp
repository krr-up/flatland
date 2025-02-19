% basic initialization
time(0..T) :- end(_,_,T).
%time(0..4).
{first_at(P,A,T2,D): time(T2), T2>=T}=1  :- start(A,P,T,D).
%at((8,29),1,3,e).
%:- first_at(P,A,T,D),first_at(P,A,T2,D).
at(P,A,T,D):- first_at(P,A,T,D).

% a train may come to a diferent place if a vertex allows it to 
1={at(V2,A,T,Dnew):trackparts(V2,D,Dnew),edge(V1,V2)
	%; at(V1,A,T,D)
	} :- at(V1,A, T-1,D), time(T), V1!=end. 
:- at(X,A,T+1,D),at(X,A,T,D),X!=end.
% if a train reaches its goal it leaves the map
at(end,A,T+1,n ) :- at(P,A,T,D), end(A,P,Tlast), Tlast>T.
% and all trains must reach an end
end(A):- at(end,A,_,_).
:- train(A), not end(A), A=1.

% do not exist twice
%:- at(V,A,T,_), at(V2,A,T,_), V!=V2.

% enforce vertex, edge and swap constraints
%error(2,A):- at(V,A,T,_), at(V,B,T,_), A<B.
%error(3,A):- at(V1,A,T,_), at(V2,B,T,_), A<B,
%	at(V1,B,T+1,_), at(V2,A,T+1,_) .

%#show error/2.
%#show trackparts/3.#show edge/2.
#show at/4.
#show first_at/4.
