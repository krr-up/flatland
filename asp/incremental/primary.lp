% #include <incmode>.
% #const imin = 1.



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
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),1) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 < (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).
turn(edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),3) :- edge(vertex((X2,Y2),(X1,Y1)),vertex((X3,Y3),(X2,Y2))),
    0 > (X2-X1)*(Y3-Y2) - (Y2-Y1)*(X3-X2).

% generate shared resources
shared_resource(vertex(At,From1),vertex(At,From2)) :- vertex(At,From1), vertex(At,From2).
shared_resource(edge(V1,V2),edge(V3,V4)) :- edge(V1,V2), edge(V3,V4),
    shared_resource(V1,V4), shared_resource(V2,V3).

time(0..T-40) :- end(_,_,T).
horizon(T) :- time(T), not time(T+1).
at(vertex(start),A,0) :- train(A).
first_vertex(A,vertex((X,Y),(X-X',Y-Y'))) :- start(A,(X,Y),_,D), dir_move(D,(X',Y')).



%%% PATH UP TO LIMIT %%%
% allow transition on map
{at(V,A,T+1): first_vertex(A,V), start(A,_,ST,_), T>=ST, T>=1, time(T+1)} :- at(vertex(start),A,T).
% a train can stay at the same place
{at(V,A,T)} :- at(V,A,T-1), time(T), V!=vertex(end).
% a train may come to a diferent place if a vertex allows it to
{at(V2,A,T)} :- at(V1,A, T-1), edge(V1,V2), time(T). 
% if a train reaches its goal it leaves the map
at(vertex(end),A,T) :- at(vertex(P,D),A,T-1), end(A,P,_), time(T).

% ensure no duplicate options are choosen
:- 2{at(V,A,T)}, train(A),time(T).

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
{at(V2,A,H+t)} :- at(V1,A,H+t-1), edge(V1,V2), horizon(H). 
% if a train reaches its goal it leaves the map
at(vertex(end),A,H+t) :- at(vertex(P,D),A,H+t-1), end(A,P,_), horizon(H).

% ensure no duplicate options are choosen
:- 2{at(V,A,H+t)}, train(A), horizon(H).

% enforce vertex, edge and swap constraints
:- at(V1,A,H+t), at(V2,B,H+t), A<B, shared_resource(V1,V2), horizon(H).
:- at(V1,A,H+t-1), at(V2,A,H+t), at(V3,B,H+t-1), at(V4,B,H+t), A<B, shared_resource(edge(V1,V2),edge(V3,V4)), horizon(H).


#program check(t).
#external query(t).
%%% GOAL %%%
% all trains must have ended their task
error(A) :- train(A), not at(vertex(end),A,_), query(t).
:- error(A).



%%% OUTPUT %%%
% action given to start
a(A,2,T) :- at(_,A,T+1), at(vertex(start),A,T), query(t).
% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1), at(V,A,T), query(t).
% generate turns if necessary
a(A,O,T) :- at(V,A,T), at(V',A,T+1), edge(V,_), turn(edge(V,V'),O), query(t).
% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1), not a(A,1,T), not a(A,3,T), at(_,A,T+1), query(t).


% translate all actions into the output
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O'), query(t).

% save map
save(vertex(P,Q)) :- vertex(P,Q), query(t).
save(edge(U,V)) :- edge(U,V), query(t).
save(turn(E,O)) :- turn(E,O), query(t).
save(shared_resource(A,B)) :- shared_resource(A,B), query(t).
save(global(T)) :- global(T), query(t).
save(first_vertex(A,B)) :- first_vertex(A,B), query(t).

% train information
save(end(A,B,C)) :- end(A,B,C), query(t).
save(train(T)) :- train(T), query(t).
save(start(A,B,C,D)) :- start(A,B,C,D), query(t).
save(at(V,A,T)) :- at(V,A,T), query(t).

#show.
#show action/3.