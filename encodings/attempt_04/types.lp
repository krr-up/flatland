% % % % % % % % % % % % % % % % % %
% % % Track types and offsets % % %
% % % % % % % % % % % % % % % % % %

%possible actions and directions
move(f). 	move(l). 	move(r).
dir(e). 	dir(w). 	dir(n). 	dir(s).

% (Type, Rotation), (From,Toward) %

% Track Type 1 - Straight
type((1,0) , (n,f)).	type((1,0) , (s,f)).
type((1,90), (w,f)).	type((1,90), (e,f)).

% Track Type 15 - Curve
type((15,0)  , (s,l)).	type((15,0)  , (w,r)).
type((15,90) , (e,l)).	type((15,90) , (s,r)).
type((15,180), (n,l)).	type((15,180), (e,r)).
type((15,270), (w,l)).	type((15,270), (n,r)).


% Track Type 21 - Simple switch (left)
type((21,0)  , (s,l)).	type((21,0)  , (w,r)).	type((21,0)  , (s,f)).	type((21,0)  , (n,f)).
type((21,90) , (e,l)).	type((21,90) , (s,r)).	type((21,90) , (e,f)).	type((21,90) , (w,f)).
type((21,180), (n,l)).	type((21,180), (e,r)).	type((21,180), (n,f)).	type((21,180), (s,f)).
type((21,270), (w,l)).	type((21,270), (n,r)).	type((21,270), (w,f)).	type((21,270), (e,f)).

% Track Type 22 - Simple switch (right)
type((22,0)  , (s,r)).	type((22,0)  , (e,l)).	type((22,0)  , (s,f)).	type((22,0)  , (n,f)).
type((22,90) , (e,r)).	type((22,90) , (n,l)).	type((22,90) , (e,f)).	type((22,90) , (w,f)).
type((22,180), (n,r)).	type((22,180), (w,l)).	type((22,180), (n,f)).	type((22,180), (s,f)).
type((22,270), (w,r)).	type((22,270), (s,l)).	type((22,270), (w,f)).	type((22,270), (e,f)).


% Track Type 3 - Diamond crossing
type((3,0), (n,f)).	type((3,0), (s,f)).	type((3,0), (e,f)).	type((3,0), (w,f)).


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
type((7,0)  , (s,f)).
type((7,90) , (e,f)).
type((7,180), (n,f)).
type((7,270), (w,f)).


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