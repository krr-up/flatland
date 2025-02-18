% action given to start
a(A,2,T) :- at(_,A,T,_), not at(_,A,T2,_),time(T2), T>T2.

% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1,D), at(V,A,T,D).

% turning logic 
turn(n,w,3).turn(w,s,3).turn(s,e,3).turn(e,n,3).%right 
turn(n,e,1).turn(w,n,1).turn(s,w,1).turn(e,s,1).%left 

% generate turns if necessary
a(A,O,T+1) :- 
	% We advanced in a non-straight way
	at(V,A,T,Din), at(V2,A,T+1,Dout), Din != Dout,
	% And there are alternative paths(From the current cell origin)
	reverse(Din,Dinrev), trackpaths(V2,Dinrev,Dout2),
	Dout2 != Dout,
	% Specific turn
	turn(Dinrev,Dout,O).

% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1), not a(A,1,T), not a(A,3,T), at(_,A,T+1).


% translate all actions into the ouput
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').



#show.
