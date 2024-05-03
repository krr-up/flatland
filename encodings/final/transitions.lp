% transitions.lp - - -
% depending on the track type and the orientation of the agent
% only certain transitions are allowed - this file provides
% a reference check to ensure that all moves are legal

% possible actions and directions
move(f). 	
move(l). 	
move(r).	
move(wait).
dir(e). 	dir(w). 	dir(n). 	dir(s).


%% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% !!! This has been changed to reflect the direction the train is FACING !!! %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %% 

% ( Type, (Facing,Move) ) %

% Track Type 0 - Empty


% Track Type 1 - Straight
transition(32800, (s,f)).	transition(32800, (n,f)).
transition(1025 , (e,f)).	transition(1025 , (w,f)).

% Track Type 8 - Curve
transition(4608 , (n,l)).	transition(4608 , (e,r)).
transition(16386, (w,l)).	transition(16386, (n,r)).
transition(72   , (s,l)).	transition(72   , (w,r)).
transition(2064 , (e,l)).	transition(2064 , (s,r)).


% Track Type 2 - Simple switch (left)
transition(37408, (n,l)).	transition(37408, (e,r)).	transition(37408, (n,f)).	transition(37408, (s,f)).
transition(17411, (w,l)).	transition(17411, (n,r)).	transition(17411, (w,f)).	transition(17411, (e,f)).
transition(32872, (s,l)).	transition(32872, (w,r)).	transition(32872, (s,f)).	transition(32872, (n,f)).
transition(3089 , (e,l)).	transition(3089 , (s,r)).	transition(3089 , (e,f)).	transition(3089 , (w,f)).

% Track Type 9 - Simple switch (right)
transition(49186, (n,r)).	transition(49186, (w,l)).	transition(49186, (n,f)).	transition(49186, (s,f)).
transition(1097 , (w,r)).	transition(1097 , (s,l)).	transition(1097 , (w,f)).	transition(1097 , (e,f)).
transition(34864, (s,r)).	transition(34864, (e,l)).	transition(34864, (s,f)).	transition(34864, (n,f)).
transition(5633 , (e,r)).	transition(5633 , (n,l)).	transition(5633 , (e,f)).	transition(5633 , (w,f)).


% Track Type 3 - Diamond crossing
transition(33825, (s,f)).	transition(33825, (n,f)).	transition(33825, (w,f)).	transition(33825, (e,f)).


% Track Type 4 - Single-slip switch
transition(38433, (s,f)). transition(38433, (w,f)).		
transition(38433, (n,f)). transition(38433, (n,l)).	
transition(38433, (e,f)). transition(38433, (e,r)).

transition(50211, (e,f)). transition(50211, (s,f)).		
transition(50211, (w,f)). transition(50211, (w,l)).	
transition(50211, (n,f)). transition(50211, (n,r)).

transition(33897, (n,f)). transition(33897, (e,f)).		
transition(33897, (s,f)). transition(33897, (s,l)).	
transition(33897, (w,f)). transition(33897, (w,r)).

transition(35889, (w,f)). transition(35889, (n,f)).		
transition(35889, (e,f)). transition(35889, (e,l)).	
transition(35889, (s,f)). transition(35889, (s,r)).




% Track Type 5 - Double-slip switch
transition(38505, (s,f)). transition(38505, (s,l)).
transition(38505, (n,f)).	transition(38505, (n,l)).
transition(38505, (w,f)).	transition(38505, (w,r)).
transition(38505, (e,f)).	transition(38505, (e,r)).		

transition(52275, (n,f)). transition(52275, (n,r)).
transition(52275, (s,f)).	transition(52275, (s,r)).
transition(52275, (e,f)).	transition(52275, (e,l)).
transition(52275, (w,f)).	transition(52275, (w,l)).	


% Track Type 6 - Symmetrical switch
transition(20994, (n,l)).	transition(20994, (e,r)).	transition(20994, (w,l)).	transition(20994, (n,r)).
transition(16458, (w,l)).	transition(16458, (n,r)).	transition(16458, (s,l)).	transition(16458, (w,r)).
transition(2136 , (s,l)).	transition(2136 , (w,r)).	transition(2136 , (e,l)).	transition(2136 , (s,r)).
transition(6672 , (e,l)).	transition(6672 , (s,r)).	transition(6672 , (n,l)).	transition(6672 , (e,r)).


% Track Type 7 - Dead end
transition(8192, (n,f)).
transition(4   , (w,f)).
transition(128 , (s,f)).
transition(256 , (e,f)).


% No choice
% given an orientation and a track type, the train may have no choice but to move forward

% type 2 / type 9
nochoice(37408, e). nochoice(37408, s).
nochoice(17411, n). nochoice(17411, e).
nochoice(32872, w). nochoice(32872, n).
nochoice(3089 , s). nochoice(3089 , w).
nochoice(1097 , w). nochoice(1097 , s).
nochoice(17411, s). nochoice(17411, e).
nochoice(34864, e). nochoice(34864, n).
nochoice(5633 , n). nochoice(5633 , w).

% type 4
nochoice(38433, s). nochoice(38433, w).
nochoice(50211, e). nochoice(50211, s).
nochoice(33897, n). nochoice(33897, e).
nochoice(35889, w). nochoice(35889, n).

% type 6
nochoice(20994, e). nochoice(20994, w).
nochoice(16458, n). nochoice(16458, s).
nochoice(2136 , w). nochoice(2136 , e).
nochoice(6672 , s). nochoice(6672 , n).


% Wait
% a wait action never changes the orientation, so we want to allow for no change
transition(Type, (Dir,wait)) :- transition(Type, _), dir(Dir).


% Offsets
% --  not moving   -- %
offset((s,wait), (0,0), s). offset((e,wait), (0,0), e).	offset((w,wait), (0,0), w). offset((n,wait), (0,0), n).

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