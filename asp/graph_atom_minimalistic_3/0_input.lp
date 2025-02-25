%% Auxilliary Atoms
% directions and their bit
dir_bit(n,3).dir_bit(e,2).dir_bit(s,1).dir_bit(w,0).

% directions and their assiciated move
dir_move(n,(-1,0)).dir_move(e,(0,1)).dir_move(s,(1,0)).dir_move(w,(0,-1)).


%% Conversion
% decode track
% D1 is the direction faced going in the cell
% D2 is the direction when facing the next cell 
cell_useful(Pos,N):- cell(Pos,N),N>0.
trackparts(Pos,D1,D2) :- cell_useful(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate edges
reverse(n,s).reverse(s,n).reverse(w,e).reverse(e,w).
edge(trackparts((X,Y),Din,D),trackparts((X2,Y2),D,Dnew)) :- 
    trackparts((X,Y),Din,D),
    trackparts((X2,Y2),D,Dnew),
    dir_move(D,(Xadd,Yadd)),  
    X+Xadd=X2,Y+Yadd=Y2.


% basic initialization
time(0..T) :- end(_,_,T).
%time(0..).
{first_at(A,T2,trackparts(P,D0,D)): trackparts(P,D0,D),time(T2), T2>T}=1 :- start(A,P,T,D).
at(A,T,P):- first_at(A,T,P).
trackparts(end).
% a train may come to a diferent place if a vertex allows it to 
{at(A,T,V1)} :- at(A,T-1,V1), time(T), V1!=trackparts(end). 
{at(A,T,trackparts(V2,D,Dnew))} :- 
	at(A,T-1,trackparts(V1,Din,D)), time(T), 
	V1!=trackparts(end), 
	edge(trackparts(V1,Din,D),trackparts(V2,D,Dnew)).
{at(A,T,trackparts(end))} :- 
	at(A,T-1,trackparts(V1,Din,D)), time(T), 
	V1!=trackparts(end), 
	edge(trackparts(V1,Din,D),trackparts(V2,D,_)),
	end(A,V2,_).

:- at(A,T,V1),at(A,T,V2),V1!=V2.

% and all trains must reach an end
end(A,T):- at(A,T,trackparts(end)).
end(A,T):- end(A,T-1),time(T).
:- train(A), not end(A,T), end(A,_,T).

% enforce vertex, edge and swap constraints
:- at(A,T,V), at(B,T,V), A<B,V!= trackparts(end).
:- at(A,T,trackparts(V1,_,_)), at(B,T,trackparts(V2,_,_)), A<B,
	at(B,T+1,trackparts(V1,_,_)),at(A,T+1,trackparts(V2,_,_)),
	edge(trackparts(V1,_,_),trackparts(V2,_,_)),
	edge(trackparts(V2,_,_),trackparts(V1,_,_))
	.

%at2(A,T,V,D):-at(V,A,T,D).%translation
%#show error/2.
%#show trackparts/3.#show edge/2.
%#show at2/4.
%#show first_at/4.
%

% action given to start
a(A,2,T) :- at(A,T,_),first_at(A,T,_).
a(A,2,T) :- not at(A,T,_),train(A),time(T).

% stop action if an agent waits
a(A,4,T) :- at(A,T+1,V), at(A,T,V).

% turning logic 
%1st direction into cell, 2nd is direction going out the cell
turn(s,w,3).turn(e,s,3).turn(n,e,3).turn(w,n,3).%right 
turn(s,e,1).turn(e,n,1).turn(n,w,1).turn(w,s,1).%left
% generate turns if necessary
a(A,O,T) :- 
	% We advanced in a non-straight way
	% this intrinsecaly checks for different vertex
	at(A,T,trackparts(V1,_,Din)), 
	at(A,T+1,trackparts(V2,_,Dout)), turn(Din,Dout,O)
	% And there are alternative paths(From the current cell origin)
	%,trackpaths(V2,Din,Dout2),Dout2 != Dout
	.

% generate move action if a train continues moving
a(A,2,T) :- at(A,T,V), not at(A,T+1,V),%if train changes place
	at(A,T+1,_),%and still exists
	not a(A,1,T), not a(A,3,T) .%and didnt do something else


% translate all actions into the ouput
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').

#show.
