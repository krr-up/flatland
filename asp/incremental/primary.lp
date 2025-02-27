#const imax = 10000.
#program base.
%%% INPUT %%%
%% Auxilliary Atoms
% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
trackparts(Pos,D1,D2) :- cell(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate direction free nodes
vertex((X,Y),(X-X',Y-Y')) :- trackparts((X,Y),D,_), dir_move(D,(X',Y')).
vertex(start).vertex(end).

% generate edges
edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))) :- vertex((X2,Y2),(X1,Y1)), vertex((X3,Y3),(X2,Y2)),
    trackparts((X2,Y2),D1,D2), dir_move(D1,(X1',Y1')), dir_move(D2,(X2',Y2')),
    X1+X1'=X2, Y1+Y1'=Y2,
    X2+X2'=X3, Y2+Y2'=Y3.

% check whether edges correspond to a turn
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),move_left) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 < (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),move_right) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 > (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).

% generate shared resources
shared_resource(vertex(At,From1),vertex(At,From2)) :- vertex(At,From1), vertex(At,From2).
shared_resource(edge(V1,V2),edge(V3,V4)) :- edge(V1,V2), edge(V3,V4),
    shared_resource(V1,V4), shared_resource(V2,V3).

time(0..T) :- end(_,_,T).
horizon(T) :- time(T), not time(T+1).
at(vertex(start),A,0) :- train(A).
first_vertex(A,vertex((X,Y),(X-X',Y-Y'))) :- start(A,(X,Y),_,D), dir_move(D,(X',Y')).
last_vertex(A,vertex(P,P')) :- end(A,P,_), vertex(P,P').



%%% PATH UP TO LIMIT %%%
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

% enforce vertex, edge and swap constraints
:- at(V1,A,T), at(V2,B,T), A<B, shared_resource(V1,V2).
:- at(V1,A,T), at(V2,A,T+1), at(V3,B,T), at(V4,B,T+1), A<B, shared_resource(edge(V1,V2),edge(V3,V4)).



#program step(t).
%%% PATH AFTER LIMIT %%%
% allow transition on map
{at(V,A,H+t): first_vertex(A,V), start(A,_,ST,_), H+t-1>=ST, H+t-1>=1} :- at(vertex(start),A,T), horizon(H).
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
% generate last move (separately since its no edge)
#show action(train(A),move_forward,T) : not at(vertex(end),A,T), at(vertex(end),A,T+1).



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