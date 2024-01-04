% % % % % % % % % % % % % % % % % %
% % % Track types and offsets % % %
% % % % % % % % % % % % % % % % % %

% possible actions and directions
move(f). 	
move(l). 	
move(r).	
%move(wait).
dir(e). 	dir(w). 	dir(n). 	dir(s).

% ( Type, (From,Toward) ) %

% Track Type 0 - Empty


% Track Type 1 - Straight
type(32800, (n,f)).	type(32800, (s,f)).
type(1025 , (w,f)).	type(1025 , (e,f)).

% Track Type 8 - Curve
type(4608 , (s,l)).	type(4608 , (w,r)).
type(16386, (e,l)).	type(16386, (s,r)).
type(72   , (n,l)).	type(72   , (e,r)).
type(2064 , (w,l)).	type(2064 , (n,r)).


% Track Type 2 - Simple switch (left)
type(37408, (s,l)).	type(37408, (w,r)).	type(37408, (s,f)).	type(37408, (n,f)).
type(17411, (e,l)).	type(17411, (s,r)).	type(17411, (e,f)).	type(17411, (w,f)).
type(32872, (n,l)).	type(32872, (e,r)).	type(32872, (n,f)).	type(32872, (s,f)).
type(3089 , (w,l)).	type(3089 , (n,r)).	type(3089 , (w,f)).	type(3089 , (e,f)).

% Track Type 9 - Simple switch (right)
type(49186, (s,r)).	type(49186, (e,l)).	type(49186, (s,f)).	type(49186, (n,f)).
type(1097 , (e,r)).	type(1097 , (n,l)).	type(1097 , (e,f)).	type(1097 , (w,f)).
type(34864, (n,r)).	type(34864, (w,l)).	type(34864, (n,f)).	type(34864, (s,f)).
type(5633 , (w,r)).	type(5633 , (s,l)).	type(5633 , (w,f)).	type(5633 , (e,f)).


% Track Type 3 - Diamond crossing
type(33825, (n,f)).	type(33825, (s,f)).	type(33825, (e,f)).	type(33825, (w,f)).


% Track Type 4 - Single-slip switch
type((4,0)  , (n,f)). 	type((4,0)  , (s,f)).	type((4,0)  , (e,f)).	type((4,0)  , (w,f)).	
type((4,0)  , (s,l)).	type((4,0)  , (w,r)).

type((4,90) , (n,f)). 	type((4,90) , (s,f)).	type((4,90) , (e,f)).	type((4,90) , (w,f)).	
type((4,90) , (e,l)).	type((4,90) , (s,r)).

type((4,180), (n,f)). 	type((4,180), (s,f)).	type((4,180), (e,f)).	type((4,180), (w,f)).
type((4,180), (n,l)).	type((4,180), (e,r)).

type((4,270), (n,f)). 	type((4,270), (s,f)).	type((4,270), (e,f)).	type((4,270), (w,f)).
type((4,270), (w,l)).	type((4,270), (n,r)).


% Track Type 5 - Double-slip switch
type((5,0) , (n,f)). 	type((5,0) , (s,f)).	type((5,0) , (e,f)).	type((5,0) , (w,f)).	
type((5,0) , (s,l)).	type((5,0) , (w,r)).	type((5,0) , (n,l)).	type((5,0) , (e,r)).

type((5,90), (n,f)). 	type((5,90), (s,f)).	type((5,90), (e,f)).	type((5,90), (w,f)).	
type((5,90), (e,l)).	type((5,90), (s,r)).	type((5,90), (w,l)).	type((5,90), (n,r)).


% Track Type 6 - Symmetrical switch
type((6,0)  , (s,l)).	type((6,0)  , (w,r)).	type((6,0)  , (e,l)).	type((6,0)  , (s,r)).
type((6,90) , (e,l)).	type((6,90) , (s,r)).	type((6,90) , (n,l)).	type((6,90) , (e,r)).
type((6,180), (n,l)).	type((6,180), (e,r)).	type((6,180), (w,l)).	type((6,180), (n,r)).
type((6,270), (w,l)).	type((6,270), (n,r)).	type((6,270), (s,l)).	type((6,270), (w,r)).


% Track Type 7 - Dead end
type(8192, (s,f)).
type(4   , (e,f)).
type(128 , (n,f)).
type(256 , (w,f)).


% Offsets
% -- heading south -- %
offset((n,f), ( 0,-1), s). 	offset((w,r), ( 0,-1), s).	offset((e,l), ( 0,-1), s).

% -- heading west  -- %
offset((e,f), (-1, 0), w). 	offset((n,r), (-1, 0), w).	offset((s,l), (-1, 0), w).

% -- heading north -- %
offset((s,f), ( 0, 1), n). 	offset((w,l), ( 0, 1), n).	offset((e,r), ( 0, 1), n).

% -- heading east  -- %
offset((w,f), ( 1, 0), e). 	offset((n,l), ( 1, 0), e).	offset((s,r), ( 1, 0), e).


% directional swaps
swap(n,s). swap(s,n). swap(e,w). swap(w,e).
