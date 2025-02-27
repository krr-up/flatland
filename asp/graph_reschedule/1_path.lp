% allow transition on map
{at(V,A,T): first_vertex(A,V), start(A,_,ST,_), T-1>=ST, T-1>=1, time(T)} :- at(vertex(start),A,T-1).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T).
% a train may move to a different place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A,T-1), edge(V1,V2), time(T). 
% if a train reaches its goal it leaves the map
at(vertex(end),A,T) :- at(V,A,T-1), last_vertex(A,V), time(T). 

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A), time(T).

% enforce vertex, edge and swap constraints
:- at(V1,A,T), at(V2,B,T), A<B, shared_resource(V1,V2).
:- at(V1,A,T), at(V2,A,T+1), at(V3,B,T), at(V4,B,T+1), A<B, shared_resource(edge(V1,V2),edge(V3,V4)).

% all trains must have ended their task
:- train(A), not at(vertex(end),A,_).