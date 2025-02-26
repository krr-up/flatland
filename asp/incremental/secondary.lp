#const imin = 1.
#const imax = 10000.
#program base.
%%% MALFUNCTION HANDLING %%%
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


% if a malfunction affects the future this is saved as persist
save(persist(A,B,C)) :- persist(A,B,C).
persist(A,B,C) :- load(persist(A,B,C)).
at(V,A,T) :- persist(V,A,T).


% malfunction time
mt(T+1) :- malfunction(_,_,T).
time(T..H) :- mt(T), load(horizon(H)).
time(T..T+D+1) :- mt(T), malfunction(_,D,_).
horizon(T) :- time(T), not time(T+1).


% determine trains affected by the malfunction
affected(A) :- malfunction(A,_,_).
% mark a train which would ram into one affected by the malfunction
affected(A) :- affected(B), mt(T), load(at(V1,B,T-1)), load(at(V2,A,T)), shared_resource(V1,V2).


% copy previous states
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T, not affected(A).
% if the train is malfunctioning or affected by it copy one less and extend the last position to show the failure
at(V,A,T') :- load(at(V,A,T')), mt(T), T'<=T-1, affected(A).
at(V,A,T) :- load(at(V,A,T-1)), mt(T), affected(A).
% extend state for the malfunctioning train
persist(V,A,T+(1..D+1)) :- load(at(V,A,T)), malfunction(A,D,T).


% somehow, whenever a malfunction ended for a non existent train it magically spawned right after that, if the starttime allows for it, but with a little more lenience than the actuat start condition ... anyway thats what the following line is for (it always uses persist)
persist(V,A,T+D+1) :- malfunction(A,D,T-1), load(at(vertex(start),A,T)), first_vertex(A,V), start(A,_,ST,_), T+D+1>=ST.



%%% PATH UP TO LIMIT %%%
% allow transition on map
{at(V,A,T): first_vertex(A,V), start(A,_,ST,_), T-1>=ST, T-1>=1, time(T)} :- at(vertex(start),A,T-1).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A, T-1), edge(V1,V2), time(T). 
% if a train reaches its goal it leaves the map
at(vertex(end),A,T) :- at(vertex(P,D),A,T-1), end(A,P,_), time(T).

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A),time(T).

% enforce vertex, edge and swap constraints
:- at(V1,A,T), at(V2,B,T), A<B, shared_resource(V1,V2), time(T).
:- at(V1,A,T-1), at(V2,A,T), at(V3,B,T-1), at(V4,B,T), A<B, shared_resource(edge(V1,V2),edge(V3,V4)), time(T).



#program step(t).
%%% PATH AFTER LIMIT %%%
% allow transition on map
{at(V,A,H+t): first_vertex(A,V), start(A,_,ST,_), H+t-1>=ST, H+t-1>=1} :- at(vertex(start),A,H+t-1), horizon(H).
% a train can stay at the same place
{at(V,A,H+t)} :- at(V,A,H+t-1), horizon(H).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,H+t)} :- at(V1,A,H+t-1), edge(V1,V2), horizon(H). 
% if a train reaches its goal it leaves the map
at(vertex(end),A,H+t) :- at(vertex(P,D),A,H+t-1), end(A,P,_), horizon(H).

% ensure no duplicate options are choosen
:- 2{at(V,A,H+t)}, train(A), horizon(H).

% enforce vertex, edge and swap constraints
:- at(V1,A,H+t), at(V2,B,H+t), A<B, shared_resource(V1,V2), horizon(H).
:- at(V1,A,H+t-1), at(V2,A,H+t), at(V3,B,H+t-1), at(V4,B,H+t), A<B, shared_resource(edge(V1,V2),edge(V3,V4)), horizon(H).

add(t).


#program check(t).
#external query(t).
%%% GOAL %%%
% all trains must have ended their task
:- train(A), not at(vertex(end),A,H+t), horizon(H), query(t).



%%% OUTPUT %%%
% action given to start
#show action(train(A),move_forward,T) : at(vertex(start),A,T), not at(vertex(start),A,T+1).
% stop action if an agent waits
#show action(train(A),wait,T) : at(V,A,T+1), at(V,A,T).
% generate turns if necessary
#show action(train(A),O,T) : at(V,A,T), at(V',A,T+1), turn(edge(V,V'),O).
% generate move action if a train continues moving
#show action(train(A),move_forward,T) : at(V,A,T), at(V',A,T+1), edge(V,V'), not turn(edge(V,V'),_).



% save map
#show save(vertex(P,Q)) : vertex(P,Q), query(t).
#show save(edge(U,V)) : edge(U,V), query(t).
#show save(turn(E,O)) : turn(E,O), query(t).
#show save(shared_resource(A,B)) : shared_resource(A,B), query(t).
#show save(global(T)) : global(T), query(t).
#show save(first_vertex(A,B)) : first_vertex(A,B), query(t).
#show save(horizon(H+T)) : horizon(H), add(T), not add(T+1).

% train information
#show save(end(A,B,C)) : end(A,B,C), query(t).
#show save(train(T)) : train(T), query(t).
#show save(start(A,B,C,D)) : start(A,B,C,D), query(t).
#show save(at(V,A,T)) : at(V,A,T), query(t).

#show.