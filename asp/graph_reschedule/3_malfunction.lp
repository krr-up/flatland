% malfunction(A,D,T)
%   A - Agent(TrainID)
%   D - Duration
%   T - Timestep

% auxillaries
edge(U,V) :- load(edge(U,V)).
turn(E,O) :- load(turn(E,O)).
shared_resource(A,B) :- load(shared_resource(A,B)).
vertex(A,B) :- load(vertex(A,B)).
end(A,B,C+D) :- load(end(A,B,C)), D = #max{D': malfunction(_,D',_)}.
train(A) :- load(train(A)).
start(A,B,C,D) :- load(start(A,B,C,D)).
dir_move(A,B) :- load(dir_move(A,B)).

% duration appears to be d+1
duration(A,1..D+1) :- malfunction(A,D,_).

% copy previous ats
at(V,A,T') :- load(at(V,A,T')), malfunction(_,_,T), T'<=T.

% malfunctionin trains
% extend malfunction timestep for the duration
at(V,A,T+D) :- duration(A,D), load(at(V,A,T)), malfunction(A,_,T).

% new starts
1 {starttime(A,T'): time(T'), T'>=T, T'>=1, T'>TM, malfunction(_,_,TM)} 1 :- start(A,_,T,_), not load(at(_,A,N)):N=0..TM, malfunction(_,_,TM).
at(vertex((X,Y),(X-X',Y-Y')),A,T+1) :- start(A,(X,Y),_,D), dir_move(D,(X',Y')), starttime(A,T).