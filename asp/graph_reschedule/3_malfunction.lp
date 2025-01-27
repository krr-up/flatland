% malfunction(A,D,T)
%   A - Agent(TrainID)
%   D - Duration
%   T - Timestep

% auxillaries
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
shared_resource(A,B) :- load(shared_resource(A,B)).
vertex(A,B) :- load(vertex(A,B)).
time(T') :- load(time(T')).
time(T+D) :- time(T), malfunction(_,D,_).

% duration appears to be d+1
duration(A,1..D+1) :- malfunction(A,D,_).

% copy previous ats
at(V,A,T') :- load(at(V,A,T')), malfunction(_,_,T), T'<T.

% malfunctionin trains
% extend malfunction timestep for the duration
at(V,A,T+D) :- duration(A,D), load(at(V,A,T)), malfunction(A,_,T).