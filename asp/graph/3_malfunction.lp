% malfunction(A,D,T)
%   A - Agent(TrainID)
%   D - Duration
%   T - Timestep

% auxillaries
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
duration(0..D) :- malfunction(_,D,_).
max_duration(D) :- D = #max{D':malfunction(_,D',_)}.

% copy all previous timesteps
at(V,A,T') :- load(at(V,A,T')), malfunction(_,_,T), T'<T.

% extend current timestep
at(V,A,T+D) :- duration(D), load(at(V,A,T)), malfunction(_,_,T).

% shift later timesteps
at(V,A,T'+D) :- load(at(V,A,T')), malfunction(_,_,T), T'>T, max_duration(D).