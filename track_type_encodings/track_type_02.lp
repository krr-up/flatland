%% the base case for determining paths for track type 2

%% a brief explanation ——
	%% track type 2 is a simple switch meaning
	%% if a train approaches from a particular direciton, it has two options: straight or to turn

	%% from one direction, there are two possible destinations
	%% then come from either of those two directions, there is only one possible destination
	%% this means that for each track type 2, there are four possible paths
	%% these four possible paths comprise our transition function for track type 2

	%% however, the tile can be rotated in one of four directions
	%% it can also be flipped
	%% this means there are eight possible configurations of this one track type

	%% the goal is to develop a base case for determining paths that applies to all
	%% possible configurations — primarily relying on the orientation value as input


%% track(X-position, Y-position, Type, Direction, Flip)
%% path(X0,Y0, X,Y, X2,Y2)
path(X0,Y0, X,Y, -1*X0,-1*Y0) :- track(X,Y,2,D), X0 = X+(|D-1|-1), Y0 = -1*(Y+(|D-2|-1)).
path(X0,Y0, X,Y,    Y0,-1*X0) :- track(X,Y,2,D), X0 = X+(|D-1|-1), Y0 = -1*(Y+(|D-2|-1)).
path(X0,Y0, X1,Y1, X2,Y2) :- path(X2,Y2, X1,Y1, X0,Y0).


%% example
track(0,0,2,0).


track(0,0,2,0).
    % expected results - track(0,0,2,0).
    % path( (0,-1) (0, 0) (0, 1) )
    % path( (0,-1) (0, 0) (-1,0) )
    % path( (0, 1) (0, 0) (0,-1) )
    % path( (-1,0) (0, 0) (0,-1) )
    

    
#show path/6.
