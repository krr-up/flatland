%% Auxilliary Atoms
% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).
reverse(n,s).reverse(s,n).reverse(e,w).reverse(w,e).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
trackparts(Pos,D1,D2) :- cell(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate edges
edge((X,Y),(X2,Y2)) :- 
    trackparts((X,Y),D1,_),
    trackparts((X2,Y2),D2,_),
    reverse(D1,D2),
    dir_move(D1,(Xadd,Yadd)),
    X+Xadd=X2,Y+Yadd=Y2 .

