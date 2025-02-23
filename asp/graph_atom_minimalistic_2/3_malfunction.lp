% save map
save(edge(U,V)) :- edge(U,V).
save(trackparts(Pos,D1,D2)) :- trackparts(Pos,D1,D2).
save(global(T)) :- global(T).
save(first_at(P,A,T,D)) :- first_at(P,A,T,D).
save(time(T)):- time(T).
% train information
save(at(P,A,T,D)) :- at(P,A,T,D).
save(end(A)):- end(A).


% load map
edge(U,V):- load(edge(U,V)).
trackparts(Pos,D1,D2) :- load(trackparts(Pos,D1,D2)).
global(T):- load(global(T)).
first_at(P,A,T,D) :- load(first_at(P,A,T,D)).
time(T):- load(time(T)).
% train information
at(P,A,T,D):- load(at(P,A,T,D)),malfunction(_,_,TLast),T< TLast.
end(A):- load(end(A)).

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(P,A,T+1,D):- malfunction_custom(A,_,T),at(P,A,T,D) .


#show malfunction/3.
