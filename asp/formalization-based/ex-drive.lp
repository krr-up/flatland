tpair((1,3),n, 1).
tpair((0,3),n, 2).
tpair((0,2),w, 3).
tpair((0,1),w, 4).
tpair((1,1),s, 5).
tpair((2,1),s, 6).
tpair((3,1),s, 7).
tpair((3,0),w, 8).
tpair((2,0),n, 9).
tpair((2,1),e,10).
tpair((2,2),e,11).
tpair((2,3),e,12).
tpair((3,3),s,13).
tpair((3,2),w,14).

:-  tpair(C,D,T), tpair(C',D',T+1), not connected(tpair(C,D,T), tpair(C',D',T+1)).

% #show connected/2.