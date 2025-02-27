%% File that is called when we want our solution to be malfunction-ready;
%% It does all the loading/saving and takes into 
%% account the waiting turns due to malfunction


% SAVING
% map
save(cell_useful(U,V)) :- cell_useful(U,V).
save(trackparts(Pos,D1,D2)) :- trackparts(Pos,D1,D2).
save(subcell(Pos,D)) :- subcell(Pos,D).
save(edge(U,V)) :- edge(U,V).
save(time(T)):- time(T).
% base problem
save(end(A,B,C)):- end(A,B,C).
save(train(A)):- train(A).
save(start(A,P,T,D)):- start(A,P,T,D).
% train information
save(at(A,T,P)) :- at(A,T,P).

% load map
cell_useful(U,V) :- load(cell_useful(U,V)).
trackparts(Pos,D1,D2) :- load(trackparts(Pos,D1,D2)).
subcell(Pos,D) :- load(subcell(Pos,D)).
edge(U,V):- load(edge(U,V)).
time(T):- load(time(T)).
% base problem
end(A,B,C):- load(end(A,B,C)).
train(A):- load(train(A)).
start(A,P,T,D):- load(start(A,P,T,D)).
% train information
at(A,T,P):- load(at(A,T,P)),malfunction(_,_,TLast),T< TLast.

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(A,T+1,P):- malfunction_custom(A,_,T),at(A,T,P) .
:- malfunction_custom(A,_,T),not at(A,T,P),first_at(A,T+1,P).

#show malfunction/3.
