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



% malfunction time
mt(T+1) :- malfunction(_,_,T).

% determine trains affected by the malfunction
affected(A) :- malfunction(A,_,_).
% mark a train which would ram into one affected by the malfunction
affected(A) :- affected(B), mt(T), load(at(V1,B,T-1)), load(at(V2,A,T)), shared_resource(V1,V2).


% copy previous states
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T, not affected(A).
% if the train is malfunctioning or affected by it copy one less as the last action failed
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T-1, affected(A).
% extend state for the malfunctioning train
at(V,A,T+(1..D+1)) :- load(at(V,A,T)), malfunction(A,D,T).


% somehow, whenever a malfunction ended for a non existent train it magically spawned right after that, if the starttime allows for it, but with a little more lenience than the actuat start condition ... anyway thats what the following line is for
at(V,A,T+D+1) :- malfunction(A,D,T-1), load(at(vertex(start),A,T)), first_vertex(A,V), start(A,_,ST,_), T+D+1>=ST.


#show malfunction/3.
