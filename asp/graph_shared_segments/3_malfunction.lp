% save map
save(vertex(P,Q)) :- vertex(P,Q).
save(edge(U,V)) :- edge(U,V).
save(turn(E,O)) :- turn(E,O).
save(shared_resource(A,B)) :- shared_resource(A,B).
save(global(T)) :- global(T).
save(first_vertex(A,B)) :- first_vertex(A,B).

% train information
save(end(A,B,C)) :- end(A,B,C).
save(train(T)) :- train(T).
save(start(A,B,C,D)) :- start(A,B,C,D).
save(at(V,A,T)) :- at(V,A,T).


% load map
vertex(A,B) :- load(vertex(A,B)).
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
shared_resource(A,B) :- load(shared_resource(A,B)).
global(T) :- load(global(T)).
first_vertex(A,B) :- load(first_vertex(A,B)).

% load train info
train(A) :- load(train(A)).
start(A,B,C,D) :- load(start(A,B,C,D)).
end(A,B,C) :- load(end(A,B,C)).


% malfunction time
at(V,A,T):- load(at(V,A,T)),malfunction(_,_,TLast),T< TLast.
malfunction_custom(A,D-1,T+1):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(V,A,T+1):- malfunction_custom(A,_,T),at(V,A,T) .
%efficiency rule, adding it here because it takes into account malfuntions
at(vertex(P,D),A,T+1):-
	at(vertex(_,P),A,T),
	vertex(P,D),
	not malfunction_custom(A,_,T),
	{vertex(P,_)}==1.


#show malfunction/3.
