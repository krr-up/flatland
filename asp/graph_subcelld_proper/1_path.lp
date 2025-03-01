%% Path-related work
%% Here the NP part of the problem is solved. 
%% All choice rules are here, and we will be saving
%% the "committed choices" as 
%% at/3: Agent, Time, Subcell(Position,Direction)
%% and base problem atoms that must be forwarded
#const imax=1.
#show at/3.

% Guess first_at
{first_at(A,T2,subcell(P,D)): time(T2), T2>T,T2>1 }=1 :- start(A,P,T,D).
% at/3 should use the direction within the cell 
% which is always the opposite of the direction faced
reverse(n,s).reverse(s,n).reverse(w,e).reverse(e,w).
at(A,T,subcell(P,Din)):- first_at(A,T,subcell(P,Dout)),reverse(Din,Dout).
:- at(A,1,_).
subcell(end).subcell(start).

% a train may come to a diferent place if a vertex allows it to 
% or stay in place; trains disappear upon completion
% edge(in_subcell,out_next_subcell)
% at(Agent, Timestamp, (Position, Direction within subcell) )
1={at(A,T,subcell(V1,D));
at(A,T,subcell(V2,Dnew)):edge(subcell(V2,Dnew),subcell(V1,D))
;at(A,T,subcell(end)):edge(subcell(V2,_),subcell(V1,D)),end(A,V2,_)} :- 
	at(A,T-1,subcell(V1,D)), time(T).

% and all trains must reach an end
end(A,T):- at(A,T,subcell(end)).
busy(A,T,V):- at(A,T,subcell(end)), end(A,V,_).
:- busy(A,T,V),busy(B,T,V),A<B.

end(A,T):- end(A,T-1),time(T).
:- train(A), not end(A,T), end(A,_,T).

% enforce vertex, edge and swap constraints
:- at(A,T,subcell(V,D)), at(B,T,subcell(V,D2)), A<B.
:- at(A,T,subcell(V1,D1)), at(B,T,subcell(V2,D2)),
	A<B,reverse(D1,D2),
	edge(subcell(V2,D2),subcell(V1,_)).

% choices + base problem
save(at(A,T,P)):- at(A,T,P).
save(end(A,B,C)):- end(A,B,C).
save(train(A)):- train(A).
save(start(A,P,T,D)):- start(A,P,T,D).
