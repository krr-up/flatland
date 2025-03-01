%% Output translation, from the at/3 atoms chosen as solution
%% No choice rules here.

% action given to start
a(A,2,0):- train(A).
a(A,2,T) :- time(T),first_at(A,T+1,_).
a(A,4,T) :- not at(A,T+1,_),train(A),time(T),time(T+1).

% stop action if an agent waits
a(A,4,T) :- at(A,T+1,V), at(A,T,V).

% turning logic 
%1st direction into cell, 2nd is direction going out the cell
turn(s,w,3).turn(e,s,3).turn(n,e,3).turn(w,n,3).%right 
turn(s,e,1).turn(e,n,1).turn(n,w,1).turn(w,s,1).%left

% edge case: sometimes we stay multiple turns in a cell
% and then inmediately must do a turn
 
% generate turns if necessary
a(A,O,T+1) :- 
	% We advanced in a non-straight way
	% this intrinsecaly checks for different vertex
	at(A,T,subcell(V1,Din)), 
	at(A,T+1,subcell(V2,Dout)), turn(Din,Dout,O)
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
