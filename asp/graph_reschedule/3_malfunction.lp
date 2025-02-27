% load map
vertex(A,B) :- load(vertex(A,B)).
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
shared_resource(A,B) :- load(shared_resource(A,B)).
global(T) :- load(global(T)).
% load train info
end(A,B,C+D) :- load(end(A,B,C)), D = #max{D': malfunction(_,D',_)}.
train(A) :- load(train(A)).
start(A,B,C,D) :- load(start(A,B,C,D)).
first_vertex(A,B) :- load(first_vertex(A,B)).
last_vertex(A,B) :- load(last_vertex(A,B)).


% if a malfunction affects the future this is saved as persist
save(persist(V,A,T)) :- persist(V,A,T).
persist(V,A,T) :- load(persist(V,A,T)).
at(V,A,T) :- persist(V,A,T).


% malfunction time
mt(T+1) :- malfunction(_,_,T).
time(T1..T2) :- mt(T1), end(_,_,T2).


% determine trains affected by the malfunction
affected(A) :- malfunction(A,_,_).
% mark a train which would ram into one affected by the malfunction
affected(A) :- affected(B), mt(T), load(at(V1,B,T-1)), load(at(V2,A,T)), shared_resource(V1,V2).


% copy previous states
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T, not affected(A).
% if the train is malfunctioning or affected by it copy one less and extend the last position to show the failure
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T-1, affected(A).
% extend state for the malfunctioning train
new_persist(V,A,T+(1..D+1)) :- load(at(V,A,T)), malfunction(A,D,T), not load(at(vertex(end),A,T+1)).

#show malfunction/3.