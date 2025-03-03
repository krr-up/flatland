%% Auxilliary Atoms
%% Everything that only needs to be calculated once,
%% and is used across any solution. 
%% Atoms with only constants could go here, but we
%% will prioritize the readability of having them near
%% their use.

% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).

%% Conversion
% decode track
% D1 is the direction faced going in the cell
% D2 is the direction facing towards next cell 
cell_useful(Pos,N):- cell(Pos,N),N>0.
trackparts(Pos,D1,D2) :- cell_useful(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate edges
subcell((X,Y),D):- trackparts((X,Y),_,D).
% edge((prev_cell,direction going into current ), (current_subcell,direction one may go out to))
edge(subcell((X,Y),D),subcell((X2,Y2),Dnew)) :- 
	subcell((X,Y),D),
    trackparts((X2,Y2),D,Dnew),
    dir_move(D,(Xadd,Yadd)),  
    X+Xadd=X2,Y+Yadd=Y2.

% basic initialization
time(0..T) :- end(_,_,T).

save(cell_useful(U,V)) :- cell_useful(U,V).
save(trackparts(Pos,D1,D2)) :- trackparts(Pos,D1,D2).
save(subcell(Pos,D)) :- subcell(Pos,D).
save(edge(U,V)) :- edge(U,V).
save(time(T)):- time(T).
