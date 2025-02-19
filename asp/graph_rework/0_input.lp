%% Auxilliary Atoms
% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).
reverse(n,s).reverse(s,n).reverse(e,w).reverse(w,e).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
% D1 is the direction faced going in the cell
% D2 is the direction when facing the next cell
trackparts(Pos,D1,D2) :- cell(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2
    %, Pos=(8..10,29..32)
    .

% generate edges
edge((X,Y),(X2,Y2)) :- 
    trackparts((X,Y),_,D),
    trackparts((X2,Y2),D,_),
    dir_move(D,(Xadd,Yadd)),
    X+Xadd=X2,Y+Yadd=Y2
    %,{(X,Y)=(8,29);(X2,Y2)=(8,29)} =1
     .
 edge(X2,X):- edge(X,X2).
