% Example environment

%        v  1
%        |
%        |
%    > — + - - -
%   0    | 
%        |

% Constant values (for specified malfunctions)
#const z = -1.
#const d = 0.
#const t = 0.

malf(z,d,t).

% Given plans - plan(Train, Cell, Time)

plan(0,(3,0),0).
plan(0,(3,1),1).
plan(0,(3,2),2).    % conflict point
plan(0,(3,3),3).
plan(0,(3,4),4).

plan(1,(0,2),0).
plan(1,(1,2),1).
plan(1,(2,2),2).
plan(1,(3,2),3).    % conflict point
plan(1,(4,2),4).


% Conflict points

conflict_point(X,Y) :- plan(Z1,(X,Y),_), plan(Z2,(X,Y),_), Z1>Z2.
conflict_time(Z,T) :- plan(Z,(X,Y),T), conflict_point(X,Y).


% Assertions

unsat_same_conflict_times :- conflict_time(Z1,T1), conflict_time(Z2,T2), Z1!=Z2, T1=T2. % invalid plan - they have the same conflict point

trivial :-  malf(Z,D,MT), conflict_time(Z,CT), CT < MT.                                 % the malfunction occurs after the conflict point

trivial :-  malf(Z1,_,_), conflict_time(Z1,CT1), conflict_time(Z2,CT2), CT1 > CT2.      % the train farther from the conflict point malfunctions

trivial :-  malf(Z1,D,MT), conflict_time(Z1,CT1), MT < CT1,                             % a train malfunctions before the conflict point
            conflict_time(Z2, CT2), Z1!=Z2,                                             % there is a second, distinct train
            D + CT1 != CT2.                                                             % the duration of the malfunction now puts the two trains on the CP at the same time

trivial :-  malf(Z1,D,MT), conflict_time(Z1,CT1), MT = CT1,                             % a train malfunctions on the conflict point
            conflict_time(Z2, CT2), Z1!=Z2,                                             % there is a second, distinct train
            D + CT1 < CT2.                                                             % the duration of the malfunction now puts the two trains on the CP at the same time


#show trivial/0.
#show unsat_same_conflict_times/0.