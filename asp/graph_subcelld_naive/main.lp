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
% D2 is the direction facing towards the next cell 
cell_useful(Pos,N):- cell(Pos,N),N>0.
trackparts(Pos,D1,D2) :- cell_useful(Pos,N), dir_bit(D1,N1), dir_bit(D2,N2),
    1 = ((N / 16**N1) \ 16 / 2**N2) \ 2.

% generate edges
subcell((X,Y),D):- trackparts((X,Y),_,D).
edge(subcell((X,Y),D),subcell((X2,Y2),Dnew)) :- 
	subcell((X,Y),D),
    trackparts((X2,Y2),D,Dnew),
    dir_move(D,(Xadd,Yadd)),  
    X+Xadd=X2,Y+Yadd=Y2.

% basic initialization
time(0..T) :- end(_,_,T).

%% Path-related work
%% Here the NP part of the problem is solved. 
%% All choice rules are here, and we will be saving
%% the "committed choices" as 
%% at/3: Agent, Time, Subcell(Position,Direction)
%% and base problem atoms that must be forwarded
#const imax=1.

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(A,T+1,P):- malfunction_custom(A,_,T),at(A,T,P) .
:- malfunction_custom(A,_,T),not at(A,T,P),first_at(A,T+1,P).
% malfunction adjustments
delay(D):-D=#count{T:malfunction_custom(_,_,T)}.
max_t(N):-N=#max{T:end(_,_,T)}.
% extend time upon malfunction
time_delay(1..T):-max_t(T),delay(0).
time_delay(Tmal..T+D+1):-max_t(T), delay(D), malfunction(A,_,Tmal).
% extend end upon malfunction
end_delay(A,V,D+T):-end(A,V,T),delay(D).

% Guessing first_at
{first_at(A,T2,subcell(P,D)): time_delay(T2), T2>T,T2>0 }=1 :- start(A,P,T,D).
% at/3 should use the direction within the cell 
% which is always the opposite of the direction faced
reverse(n,s).reverse(s,n).reverse(w,e).reverse(e,w).
at(A,T,subcell(P,Din)):- first_at(A,T,subcell(P,Dout)),reverse(Din,Dout).
:- at(A,1,_).
subcell(end).

% a train may come to a diferent place if a vertex allows it to 
% or stay in place; trains disappear upon completion
% edge(in_subcell,out_next_subcell)
% at(Agent, Timestamp, (Position, Direction within subcell) )
{at(A,T,P)}:- at(A,T-1,P), 
	time_delay(T),end_delay(A,_,TLast),T<TLast.
{at(A,T,subcell(V2,Dnew))}:- at(A,T-1,subcell(V1,D)), 
	edge(subcell(V2,Dnew),subcell(V1,D)),
	end_delay(A,_,TLast), T<TLast,time_delay(T).
{at(A,T,subcell(end))}:- at(A,T-1,subcell(V1,D)), 
	edge(subcell(V2,_),subcell(V1,D)),
	end_delay(A,V2,TLast),T<TLast,time_delay(T).
:- 2{at(A,T,P)},train(A),time_delay(T).

% and all trains must reach an end
end(A,T):- at(A,T,subcell(end)).
end(A,T):- end(A,T-1),time_delay(T).
busy(A,T,V):- at(A,T,subcell(end)), end_delay(A,V,_).
:- busy(A,T,V),busy(B,T,V),A<B.%no two trains ending at same time and place
:- train(A), not end(A,T), end_delay(A,_,T).

% enforce vertex, edge and swap constraints
:- at(A,T,subcell(V,D)), at(B,T,subcell(V,D2)), A<B.
:- at(A,T,subcell(V1,D1)), at(B,T,subcell(V2,D2)),
	A<B,reverse(D1,D2),
	edge(subcell(V2,D2),subcell(V1,_)).


%% Output translation, from the at/3 atoms chosen as solution
%% No choice rules here.

% action given to start
a(A,2,0):- train(A).
a(A,2,T) :- time_delay(T),first_at(A,T+1,_).
a(A,4,T) :- not at(A,T+1,_),train(A),time_delay(T),time_delay(T+1).

% stop action if an agent waits
a(A,4,T) :- at(A,T+1,V), at(A,T,V).

% turning logic; 3= right,1 = left 
% 1st direction within current cell
% 2nd is direction within cell
turn(s,w,3).turn(e,s,3).turn(n,e,3).turn(w,n,3).
turn(s,e,1).turn(e,n,1).turn(n,w,1).turn(w,s,1).

% edge case: sometimes we stay multiple turns in a cell
% and then inmediately must do a turn
 
% generate turns if necessary
a(A,O,T) :- 
	% We advanced in a non-straight way
	% this intrinsecaly checks for different vertex
	at(A,T,subcell(V1,D1)), 
	at(A,T+1,subcell(V2,D2)), turn(D1,D2,O)
	% And there are alternative paths(From the current cell origin)
	%,trackparts(V2,Din,Dout2),Dout2 != Dout
	.

% generate move action if a train continues moving
a(A,2,T) :- at(A,T,V), not at(A,T+1,V),%if train changes place
	at(A,T+1,_),%and still exists
	not a(A,1,T), not a(A,3,T) .%and didnt do something else

% translate all actions into the ouput
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').

#show.
