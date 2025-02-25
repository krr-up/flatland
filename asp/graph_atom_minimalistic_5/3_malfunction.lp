% save map
save(edge(U,V)) :- edge(U,V).
save(cell_useful(U,V)) :- cell_useful(U,V).
save(trackparts(Pos,D1,D2)) :- trackparts(Pos,D1,D2).
save(subcell(Pos,D)) :- subcell(Pos,D).
save(global(T)) :- global(T).
save(first_at(A,T,P)) :- first_at(A,T,P).
save(time(T)):- time(T).
% train information
save(at(A,T,P)) :- at(A,T,P).
save(end(A)):- end(A).


% load map
edge(U,V):- load(edge(U,V)).
cell_useful(U,V) :- load(cell_useful(U,V)).
trackparts(Pos,D1,D2) :- load(trackparts(Pos,D1,D2)).
subcell(Pos,D) :- load(subcell(Pos,D)).
global(T):- load(global(T)).
first_at(A,T,P) :- load(first_at(A,T,P)).
time(T):- load(time(T)).
% train information
at(A,T,P):- load(at(A,T,P)),malfunction(_,_,TLast),T< TLast.
end(A):- load(end(A)).

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(A,T+1,P):- malfunction_custom(A,_,T),at(A,T,P) .


#show malfunction/3.
