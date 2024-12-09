%% generating ordered cyclefree paths

% move to enter the map
move(A,"Start",vertex((X,Y),(X-X',Y-Y'))) :- start(A,(X,Y),_,D), dir_move(D,(X',Y')).

% move to leave the map
1 {move(A,vertex(At,From),"End"): vertex(At,From)} 1 :- end(A,At,_).

% choice rule for moves
{move(A,vertex(At,From),Next): edge(vertex(At,From),Next)} 1 :- agent(A), vertex(At,From).

% all moves except the start one, must have one before them
:- move(A,U,_), not move(A,_,U), U!="Start".
% all moves except the last one, must have one after them
:- move(A,_,V), not move(A,V,_), V!="End".

% every move has no more than 1 leading up to it
:- move(A,V,_), 2 {move(A,_,V)}.