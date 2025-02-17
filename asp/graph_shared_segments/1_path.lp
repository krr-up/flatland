% allow transition on map
{at(V,A,T+1): first_vertex(A,V), start(A,_,ST,_), T>=ST, T>=1, time(T+1)} :- at(vertex(start),A,T).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T), V!=vertex(end).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A, T-1), edge(V1,V2), time(T). 

% if a train reaches its goal it leaves the map
at(vertex(end),A,T+1) :- at(vertex(P,D),A,T), end(A,P,_).

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A),time(T).

% enforce vertex, edge and swap constraints
:- at(V1,A,T), at(V2,B,T), A<B, shared_resource(V1,V2).
:- at(V1,A,T), at(V2,A,T+1), at(V3,B,T), at(V4,B,T+1), A<B, shared_resource(edge(V1,V2),edge(V3,V4)).


% all trains must have ended their task
ended(A) :- end(A,_,ET), at(vertex(end),A,T).%, T<=ET.
:- train(A), not ended(A).
