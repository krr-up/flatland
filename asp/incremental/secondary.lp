#const imax = 100.
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
last_vertex(A,B) :- load(last_vertex(A,B)).


% if a malfunction affects the future this is saved as persist
save(persist(V,A,T)) :- persist(V,A,T).
persist(V,A,T) :- load(persist(V,A,T)), not new_persist(_,A,T).
persist(V,A,T) :- new_persist(V,A,T).
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
% if not already at the end
new_persist(V,A,T+(1..D+1)) :- load(at(V,A,T)), malfunction(A,D,T).


% somehow, whenever a malfunction ended for a non existent train it magically spawned right after that, if the starttime allows for it, but with a little more lenience than the actuat start condition ... anyway thats what the following line is for (it always uses persist)
% this is also the reason this is encapsulated as new_persit as information from this persist can, by right of a follow up malfunction, be negated (aka pushed back)
new_persist(V,A,T+D+1) :- malfunction(A,D,T-1), load(at(vertex(start),A,T)), first_vertex(A,V), start(A,_,ST,_), T+D+1>=ST.



%%% PATH UP TO LIMIT %%%
% allow transition on map
{at(V,A,T): first_vertex(A,V), start(A,_,ST,_), T-1>=ST, T-1>=1, time(T)} :- at(vertex(start),A,T-1).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A,T-1), edge(V1,V2), not last_vertex(A,V2), time(T). 
% if a train reaches its goal it leaves the map
{at(vertex(end),A,T)} :- at(V1,A,T-1), edge(V1,V2), last_vertex(A,V2), time(T). 

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A), time(T), mt(T').

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
{at(V2,A,H+t)} :- at(V1,A,H+t-1), edge(V1,V2), not last_vertex(A,V2), horizon(H). 
% if a train reaches its goal it leaves the map
{at(vertex(end),A,H+t)} :- at(V1,A,H+t-1), edge(V1,V2), last_vertex(A,V2), horizon(H). 

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
:- train(A), not at(vertex(end),A,H+t-1), horizon(H), query(t).



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
#show save(vertex(P,Q)) : vertex(P,Q).
#show save(edge(U,V)) : edge(U,V).
#show save(turn(E,O)) : turn(E,O).
#show save(shared_resource(A,B)) : shared_resource(A,B).
#show save(global(T)) : global(T).
#show save(first_vertex(A,B)) : first_vertex(A,B).
#show save(last_vertex(A,B)) : last_vertex(A,B).
#show save(horizon(H+M)) : horizon(H), M = #max{0; T: add(T)}.

% train information
#show save(end(A,B,C)) : end(A,B,C).
#show save(train(T)) : train(T).
#show save(start(A,B,C,D)) : start(A,B,C,D).
#show save(at(V,A,T)) : at(V,A,T).

#show.