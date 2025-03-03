%% File that is called when we want our solution to be malfunction-ready;
%% It does all the loading/saving (that does is not done 
%% in another file) and takes into account the waiting 
%% turns due to malfunction

% SAVING
% save map
save(cell_useful(U,V)) :- cell_useful(U,V).
save(trackparts(Pos,D1,D2)) :- trackparts(Pos,D1,D2).
save(subcell(Pos,D)) :- subcell(Pos,D).
save(edge(U,V)) :- edge(U,V).
save(time(T)):- time(T).
% malfunction-forwarding
save(malfunction_custom(A,D,T)):- malfunction_custom(A,D,T).

% LOADING
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
at(A,T,P):- load(at(A,T,P)),malfunction(_,_,TLast),T < TLast.
% malfunction-forwarding
malfunction_custom(A,D,T):-load(malfunction_custom(A,D,T)).
