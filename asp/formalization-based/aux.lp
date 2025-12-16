
% Track Type 1 - Straight
connection(32800,   (n,s)).
connection(1025,    (w,e)).

% Track Type 8 - Curve
connection(4608,    (s,w)).
connection(16386,   (e,s)).
connection(72,      (n,e)).
connection(2064,    (w,n)).

% Track Type 2 - Simple switch (left)
connection(37408,   (n,s)).
connection(37408,   (s,w)).%%#(\label{aux:end-track-type-preview}#)
connection(17411,   (w,e)).
connection(17411,   (e,s)).
connection(32872,   (n,s)).
connection(32872,   (n,e)).
connection(3089,(w,e)).
connection(3089,(w,n)).

% Track Type 9 - Simple switch (right)
connection(49186,   (n,s)).
connection(49186,   (e,s)).
connection(1097,    (w,e)).
connection(1097,    (n,e)).
connection(34864,   (n,s)).
connection(34864,   (w,n)).
connection(5633,    (w,e)).
connection(5633,    (s,w)).

% Track Type 3 - Diamond crossing
connection(33825,   (n,s)).
connection(33825,   (w,e)).

% Track Type 4 - Single-slip switch
connection(38433,   (n,s)).
connection(38433,   (w,e)).
connection(38433,   (s,w)).
connection(50211,   (n,s)).
connection(50211,   (w,e)).
connection(50211,   (e,s)).
connection(33897,   (n,s)).
connection(33897,   (w,e)).
connection(33897,   (n,e)).
connection(35889,   (n,s)).
connection(35889,   (w,e)).
connection(35889,   (w,n)).

% Track Type 5 - Double-slip switch
connection(38505,   (n,s)).
connection(38505,   (w,e)).
connection(38505,   (n,e)).
connection(38505,   (s,w)).
connection(52275,   (n,s)).
connection(52275,   (w,e)).
connection(52275,   (e,s)).
connection(52275,   (w,n)).

% Track Type 6 - Symmetrical switch
connection(20994,   (e,s)).
connection(20994,   (s,w)).
connection(16458,   (n,e)).
connection(16458,   (e,s)).
connection(2136,    (w,n)).
connection(2136,    (n,e)).
connection(6672,    (s,w)).
connection(6672,    (w,n)).

% connection(T,(D,D')) :- connection(T,(D',D)).
