%% Path-related work
%% Here the NP part of the problem is solved. 
%% All choice rules are here, and we will be saving
%% the "committed choices" as 
%% at/3: Agent, Time, Subcell(Position,Direction)
%% and base problem atoms that must be forwarded

% Guess first_at
{first_at(A,T2,subcell(P,D)): time(T2), T2>T}=1 :- start(A,P,T,D).
at(A,T,P):- first_at(A,T,P).
subcell(end).

% a train may come to a diferent place if a vertex allows it to 
% or stay in place; trains disappear upon completion
1={at(A,T,subcell(V1,D))
;at(A,T,subcell(V2,Dnew)):edge(subcell(V1,D),subcell(V2,Dnew))
;at(A,T,subcell(end)):edge(subcell(V1,D),subcell(V2,_)),end(A,V2,_)} :- 
	at(A,T-1,subcell(V1,D)), time(T).

% and all trains must reach an end
end(A,T):- at(A,T,subcell(end)).
end(A,T):- end(A,T-1),time(T).
:- train(A), not end(A,T), end(A,_,T).

% enforce vertex, edge and swap constraints
:- at(A,T,subcell(V,D)), at(B,T,(V,D2)), A<B.
reverse(n,s).reverse(s,n).reverse(w,e).reverse(e,w).
:- at(A,T,subcell(V1,D1)), at(B,T,subcell(V2,D2)), A<B,
	edge(subcell(V1,D1),subcell(V2,_)),reverse(D1,D2).

% choices + base problem
save(at(A,T,P)):- at(A,T,P).
save(end(A,B,C)):- end(A,B,C).
save(train(A)):- train(A).
save(start(A,P,T,D)):- start(A,P,T,D).
