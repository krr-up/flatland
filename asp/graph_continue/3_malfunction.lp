% malfunction(A,D,T)
%   A - Agent(TrainID)
%   D - Duration
%   T - Timestep

% auxillaries
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
% duration appears to be d+1
duration(A,1..D+1) :- malfunction(A,D,_).


% normal trains
% copy all timesteps if no malfunction occured
at(V,A,T) :- load(at(V,A,T)), not malfunction(A,_,_).


% malfunctionin trains
% copy all timesteps up to the malfunction
at(V,A,T') :- load(at(V,A,T')), malfunction(A,_,T), T'<=T.
% extend malfunction timestep for the duration
at(V,A,T+D) :- duration(A,D), load(at(V,A,T)), malfunction(A,_,T).
% shift later timesteps
at(V,A,T'+D+1) :- load(at(V,A,T')), malfunction(A,D,T), T'>T.


% just there for early error detection, in case I messed up
:- at(V1,A,T), at(V2,A,T), V1<V2.