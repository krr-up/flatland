%% in this example, we attempt to move two trains along tracks in a simple network

% define size of environment
	height(2).
	width(6).


%	 1	   2     3     4     5     6
%  ————— ————— ————— ————— ————— —————
% |     |     |     |     |     |  X  |	2
% |     |     |     |     |     |     |
%  ————— ————— ————— ————— ————— —————
% |  X  |  O  |     |     |     |  O  | 1
% |     |     |     |     |     |     |
%  ————— ————— ————— ————— ————— —————
%


% pre-defined track types
% in this example, we only need four track types
	% 1. Case 1  - Straight
	% 2. Case 1b - Curve
	% 3. Case 2  - Simple switch
	% 4. Case 7  - Dead end


% define track locations
	% track(1,1) - Case 7 (270º clockwise)
	% track(2,1) - Case 1 (horizontal)
	% track(3,1) - Case 1 (horizontal)
	% track(4,1) - Case 1 (horizontal)
	% track(5,1) - Case 2 (90º clockwise)
	% track(6,1) - Case 7 (90º clockwise)

	% track(2,1) - Empty
	% track(2,2) - Empty
	% track(2,3) - Empty
	% track(2,4) - Empty
	% track(2,5) - Case 1b
	% track(2,6) - Case 7 (90º clockwise)


% define starting locations
	train(X,1,1).
	train(O,2,1).


% define goal locations
	goal(X,6,2).
	goal(O,6,1).