% % % % % % % % % % % % % % % % % %
% % % Track types and offsets % % %
% % % % % % % % % % % % % % % % % %

% possible actions and directions
move(f). 	
move(l). 	
move(r).	
%move(wait).
dir(e). 	dir(w). 	dir(n). 	dir(s).


%% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% !!! This has been changed to reflect the direction the train is FACING !!! %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %% 

% ( Type, (Facing,Toward) ) %

% Track Type 0 - Empty

% Track Type 1 - Straight
type(32800, (s,f)).	type(32800, (n,f)).
type(1025 , (e,f)).	type(1025 , (w,f)).

% Track Type 8 - Curve
type(4608 , (n,l)).	type(4608 , (e,r)).
type(16386, (w,l)).	type(16386, (n,r)).
type(72   , (s,l)).	type(72   , (w,r)).
type(2064 , (e,l)).	type(2064 , (s,r)).


% Track Type 2 - Simple switch (left)
type(37408, (n,l)).	type(37408, (e,r)).	type(37408, (n,f)).	type(37408, (s,f)).
type(17411, (w,l)).	type(17411, (n,r)).	type(17411, (w,f)).	type(17411, (e,f)).
type(32872, (s,l)).	type(32872, (w,r)).	type(32872, (s,f)).	type(32872, (n,f)).
type(3089 , (e,l)).	type(3089 , (s,r)).	type(3089 , (e,f)).	type(3089 , (w,f)).

% Track Type 9 - Simple switch (right)
type(49186, (n,r)).	type(49186, (w,l)).	type(49186, (n,f)).	type(49186, (s,f)).
type(1097 , (w,r)).	type(1097 , (s,l)).	type(1097 , (w,f)).	type(1097 , (e,f)).
type(34864, (s,r)).	type(34864, (e,l)).	type(34864, (s,f)).	type(34864, (n,f)).
type(5633 , (e,r)).	type(5633 , (n,l)).	type(5633 , (e,f)).	type(5633 , (w,f)).


% Track Type 3 - Diamond crossing
type(33825, (s,f)).	type(33825, (n,f)).	type(33825, (w,f)).	type(33825, (e,f)).


% Track Type 4 - Single-slip switch
type(38433, (s,f)). 	type(38433, (n,f)).	type(38433, (w,f)).	type(38433, (e,f)).	
type(38433, (n,l)).	type(38433, (e,r)).

type(50211, (s,f)). 	type(50211, (n,f)).	type(50211, (w,f)).	type(50211, (e,f)).	
type(50211, (w,l)).	type(50211, (n,r)).

type((4,180), (s,f)). 	type((4,180), (n,f)).	type((4,180), (w,f)).	type((4,180), (e,f)).
type((4,180), (s,l)).	type((4,180), (w,r)).

type(35889, (s,f)). 	type(35889, (n,f)).	type(35889, (w,f)).	type(35889, (e,f)).
type(35889, (e,l)).	type(35889, (s,r)).


% Track Type 5 - Double-slip switch
type(38505, (s,f)). 	type(38505, (n,f)).	type(38505, (w,f)).	type(38505, (e,f)).	
type(38505, (n,l)).	type(38505, (e,r)).	type(38505, (s,l)).	type(38505, (w,r)).

type(52275, (s,f)). 	type(52275, (n,f)).	type(52275, (w,f)).	type(52275, (e,f)).	
type(52275, (w,l)).	type(52275, (n,r)).	type(52275, (e,l)).	type(52275, (s,r)).


% Track Type 6 - Symmetrical switch
type(20994, (n,l)).	type(20994, (e,r)).	type(20994, (w,l)).	type(20994, (n,r)).
type(16458, (w,l)).	type(16458, (n,r)).	type(16458, (s,l)).	type(16458, (w,r)).
type(2136 , (s,l)).	type(2136 , (w,r)).	type(2136 , (e,l)).	type(2136 , (s,r)).
type(6672 , (e,l)).	type(6672 , (s,r)).	type(6672 , (n,l)).	type(6672 , (e,r)).


% Track Type 7 - Dead end
type(8192, (n,f)).
type(4   , (w,f)).
type(128 , (s,f)).
type(256 , (e,f)).


% Offsets
% -- heading south -- %
offset((s,f), ( 0,-1), s). 	offset((e,r), ( 0,-1), s).	offset((w,l), ( 0,-1), s).

% -- heading west  -- %
offset((w,f), (-1, 0), w). 	offset((s,r), (-1, 0), w).	offset((n,l), (-1, 0), w).

% -- heading north -- %
offset((n,f), ( 0, 1), n). 	offset((e,l), ( 0, 1), n).	offset((w,r), ( 0, 1), n).

% -- heading east  -- %
offset((e,f), ( 1, 0), e). 	offset((s,l), ( 1, 0), e).	offset((n,r), ( 1, 0), e).


% directional swaps
swap(s,s). swap(n,n). swap(w,w). swap(e,e).
