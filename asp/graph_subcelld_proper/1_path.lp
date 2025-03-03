%% Path-related work
%% Here the NP part of the problem is solved. 
%% All choice rules are here, and we will be saving
%% the "committed choices" as 
%% at/3: Agent, Time, Subcell(Position,Direction)
%% and base problem atoms that must be forwarded
#const imax=1.
%#show at/3.
#show malfunction/3.
%#show end_delay/3.

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(A,T+1,P):- malfunction_custom(A,_,T),at(A,T,P) .
:- malfunction_custom(A,_,T),not at(A,T,P),first_at(A,T+1,P).

% malfunction adjustments
delay_turn(T):- malfunction_custom(A,_,T).
delay(D):-D=#count{T:delay_turn(T)}.
% extend time upon malfunction
time_delay(1..T):-time(T),delay(0).
time_delay(Tmal..T+D+1):-time(T), delay(D), malfunction(A,_,Tmal).
% extend end upon malfunction
end_delay(A,V,D+T):-end(A,V,T),delay(D).


% Guess first_at
{first_at(A,T2,subcell(P,D)): time_delay(T2), T2>T,T2>0 }=1 :- start(A,P,T,D).
% at/3 should use the direction within the cell 
% which is always the opposite of the direction faced
reverse(n,s).reverse(s,n).reverse(w,e).reverse(e,w).
at(A,T,subcell(P,Din)):- first_at(A,T,subcell(P,Dout)),reverse(Din,Dout).
:- at(A,1,_).
subcell(start).

% a train may come to a diferent place if a vertex allows it to 
% or stay in place; trains disappear upon completion
% edge(in_subcell,out_next_subcell)
% at(Agent, Timestamp, (Position, Direction within subcell) )
1={at(A,T,subcell(V1,D));
at(A,T,subcell(V2,Dnew)):edge(subcell(V2,Dnew),subcell(V1,D))
;at(A,T,subcell(end)):edge(subcell(V2,_),subcell(V1,D)),end_delay(A,V2,_)} :- 
	at(A,T-1,subcell(V1,D)), time_delay(T).
% and all trains must reach an end
end(A,T):- at(A,T,subcell(end)).
busy(A,T,V):- at(A,T,subcell(end)), end_delay(A,V,_).
:- busy(A,T,V),busy(B,T,V),A<B.%no two trains ending at same time
end(A,T):- end(A,T-1),time_delay(T).
:- train(A), not end(A,T), end_delay(A,_,T).


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
