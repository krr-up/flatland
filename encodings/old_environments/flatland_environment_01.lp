%% in this first approach, we define the environment in two ways
%% first, we define which cells are tracks and which are non-tracks
%% then, we define which cells are connected (i.e. the orientation of the tracks) with separate atoms

% define size of environment
	height(6).
	width(6).

% define track cells
	track(1,2).
	track(1,3).
	track(1,6).

	track(2,2).
	track(2,3).
	track(2,4).
	track(2,5).
	track(2,6).

	track(3,1).
	track(3,2).
	track(3,4).

	track(4,1).
	track(4,2).
	track(4,3).
	track(4,4).
	track(4,5).
	track(4,6).

	track(5,1).
	track(5,2).
	track(5,3).
	track(5,4).
	track(5,5).
	track(5,6).

	track(6,2).
	track(6,5).
	track(6,6).

% define connections between track cells
	% primary issue - although two track cells can be connected,
	% this doesnt mean that a path can occur from any combination
	% of the connected track cells
