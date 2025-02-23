%% Auxilliary Atoms
% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
% D1 is the direction faced going in the cell
% D2 is the direction when facing the next cell
trackparts(Pos,D1,D2) :- cell(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate edges
edge((X,Y),(X2,Y2)) :- 
    trackparts((X,Y),_,D),
    trackparts((X2,Y2),D,_),
    dir_move(D,(Xadd,Yadd)),
    X+Xadd=X2,Y+Yadd=Y2.
 edge(P2,P):- edge(P,P2).


% basic initialization
time(0..T) :- end(_,_,T).
{first_at(P,A,T2,D): time(T2), T2>=T}=1  :- start(A,P,T,D).
at(P,A,T,D):- first_at(P,A,T,D).

% a train may come to a diferent place if a vertex allows it to 
1={at(V2,A,T,Dnew):trackparts(V2,D,Dnew),edge(V1,V2)
	;at(end,A,T,n): trackparts(V2,D,_), edge(V1,V2), 
		end(A,V2,Tlast),Tlast>T
	; at(V1,A,T,D) %or remain in the same vertex
	} :- at(V1,A, T-1,D), time(T), V1!=end. 

% and all trains must reach an end
end(A):- at(end,A,_,_).
:- train(A), not end(A).

% enforce vertex, edge and swap constraints
:- at(V,A,T,_), at(V,B,T,_), A<B.
:- at(V1,A,T,_), at(V2,B,T,_), A<B,
	at(V1,B,T+1,_), at(V2,A,T+1,_) .

%at2(A,T,V,D):-at(V,A,T,D).%translation
%#show error/2.
%#show trackparts/3.#show edge/2.
%#show at2/4.
%#show first_at/4.


% action given to start
a(A,2,T) :- at(_,A,T,_),first_at(_,A,T,_).
a(A,2,T) :- not at(_,A,T,_),train(A),time(T).

% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1,_), at(V,A,T,_ ).

% turning logic 
%1st direction into cell, 2nd is direction going out the cell
turn(s,w,3).turn(e,s,3).turn(n,e,3).turn(w,n,3).%right 
turn(s,e,1).turn(e,n,1).turn(n,w,1).turn(w,s,1).%left
% generate turns if necessary
a(A,O,T) :- 
	% We advanced in a non-straight way
	% this intrinsecaly checks for different vertex
	at(V,A,T,Din), at(V2,A,T+1,Dout), turn(Din,Dout,O)
	% And there are alternative paths(From the current cell origin)
	%,trackpaths(V2,Din,Dout2),Dout2 != Dout
	.

% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T,_), not at(V,A,T+1,_),%if train changes place
	at(_,A,T+1,_),%and still exists
	not a(A,1,T,_), not a(A,3,T,_) .%and didnt do something else


% translate all actions into the ouput
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').


#show.
