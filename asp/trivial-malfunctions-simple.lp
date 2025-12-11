% #const z = -1.
% #const d = 0.
% #const t = 0.
% malfunction(z,d,t).

% { malfunction(Z,D,T) : Z=0..1, D=1..4, T=0..4 } = 1. 
malfunction(1,1,1).

% environment
possible_conflicts((1,(0,5),(1,4)); (2,(0,6),(1,3)); (3,(0,7),(1,2)); (4,(0,8),(1,1))).
% conflict_point(0,6).
% conflict_point(1,3).
{ choose_conflict(N) : N=1..4 }.
front(Z) :- conflict_point(Z,D), conflict_point(Z',D'), D < D'.
delta(D) :- conflict_point(Z0,T0), conflict_point(Z1,T1), Z0!=Z1, D = |T1-T0|.


% criteria
problem :- malfunction(Z,D,T), front(Z),         % if the train in front malfunctions
    conflict_point(Z,CP), T = CP,                   % and it does so on the conflict point
    delta(DZ), D >= DZ.                             % and the duration is >= the DELTA


problem :- malfunction(Z,D,T), front(Z),         % if the train in front malfunctions
    conflict_point(Z,CP), T < CP,                   % and it does so before the conflict point
    delta(DZ), D = DZ.                              % and the duration is equal to the DELTA


#show problem/0.
#show malfunction/3.
