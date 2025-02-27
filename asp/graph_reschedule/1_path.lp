% allow transition on map
{at(V,A,T+1): first_vertex(A,V), start(A,_,ST,_), T>=ST, T>=1, time(T+1)} :- at(vertex(start),A,T).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A,T-1), edge(V1,V2), not last_vertex(A,V2), time(T). 
% if a train reaches its goal it leaves the map
{at(vertex(end),A,T)} :- at(V1,A,T-1), edge(V1,V2), last_vertex(A,V2), time(T). 

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A), time(T).
% two agents can't end at the same time
:- at(vertex(end),A,T), at(vertex(end),B,T), A<B, {at(vertex(end),A,T-1);at(vertex(end),B,T-1)} 0.

% enforce vertex, edge and swap constraints
:- at(V1,A,T), at(V2,B,T), A<B, shared_resource(V1,V2).
:- at(V1,A,T), at(V2,A,T+1), at(V3,B,T), at(V4,B,T+1), A<B, shared_resource(edge(V1,V2),edge(V3,V4)).

% all trains must have ended their task
:- train(A), not at(vertex(end),A,_).
