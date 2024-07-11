% forced wait from 0 until ready
action(train(ID), wait, 0..N) :- starting(ID,A,N).

% forced forward to spawn at ready + 1
action(train(ID), move_forward, N+1) :- starting(ID,A,N).

% determine subsequent actions
clock(n,e).     clock(e,s).     clock(s,w).     clock(w,n).
counter(e,n).   counter(s,e).   counter(w,s).   counter(n,w).

action(train(ID), move_left,    T) :- path(ID,A,B,D1,T-1), path(ID,B,C,D2,T), choice(B,D1), counter(D1,D2).
action(train(ID), move_right,   T) :- path(ID,A,B,D1,T-1), path(ID,B,C,D2,T), choice(B,D1), clock(D1,D2).
action(train(ID), wait,         T) :- path(ID,A,B,D2,T), A=B.
action(train(ID), move_forward, T) :- path(ID,A,B,D2,T), not action(train(ID), wait, T), not action(train(ID), move_left, T), not action(train(ID), move_right, T).

#show action/3.
