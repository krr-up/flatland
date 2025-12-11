% environment paths
path(0,(2,2),0).
path(0,(2,1),1).
path(0,(1,1),2).
path(0,(0,1),3).
path(0,(0,0),4).
path(1,(0,2),0).
path(1,(0,1),4).
path(1,(1,1),5).
path(1,(2,1),6).
path(1,(2,2),7).


% conflict points
    % conflict(X,Y,Front)
conflict(X,Y,Front) :- path(Front,(X,Y),T1), path(Z,(X,Y),T2), Front!=Z, T1<T2.



% malfunctions
    % delta(X,Y,RelativeDistance)
    % front(X,Y,TemporalDistance)
    %  back(X,Y,TemporalDistance)
delta(X,Y,D) :- conflict(X,Y,_), 
            path(Z1,(X,Y),T1), path(Z2,(X,Y),T2), 
            D = |T2-T1|.
front(X,Y,T) :- conflict(X,Y,F), path(F,(X,Y),T).
back(X,Y,T)  :- conflict(X,Y,F), path(B,(X,Y),T), B!=F.

% blocking conflict
problem :- malfunction(Z,D,T), conflict(X,Y,Z),     % if the train in front malfunctions
    front(X,Y,T),                                   % and it does so on the conflict point
    delta(X,Y,DZ), D >= DZ.                         % and the duration is >= the DELTA


% there is a malfunction
% the train Z malfunctioning is the front train of a conflict point X,Y
% the front train Z reaches that conflit point at time step T = malfunction time step T
% the duration of the malfunction D is >= the delta of that conflict point


% vertex conflict
% problem :- malfunction(Z,D,T), front(Z),         % if the train in front malfunctions
%     conflict_point(Z,CP), T < CP,                   % and it does so before the conflict point
%     delta(DZ), D = DZ.                              % and the duration is equal to the DELTA

% edge conflict


% triviality check

malfunction(1,3,5).

% #show problem/0.
#show front/3.
#show back/3.
#show conflict/3.