% pre-spawn logic
previous(Z,S) :- start(Z,(X,Y),_,D), inverse(D,D'), offset(D',Dx,Dy), S = (X+Dx,Y+Dy,D).

% first step
{ step(Z,S',T) : edge(S,S'), S = (X,Y,D) } = 1 :- previous(Z,S), start(Z,_,T,_).

% subsequent steps
{ step(Z,(X,Y,D),T) : edge(S,(X,Y,D)) } = 1 :- 
    step(Z,S,T-1),                      % if we have a previous step
    end(Z,(EndX,EndY),Arrival),         % given an end condition for the train
    not T > Arrival,                    % we cannot continue beyond the arrival deadline
    S=(SX,SY,SD),                       % given a previous subnode
    not (SX,SY) = (EndX,EndY).          % we cannot move beyond it if it reached the end

% overloaded step for compability
step(Z,(X,Y),D,T) :- step(Z,(X,Y,D),T).

% constraints
:- end(Z,(X,Y),_), not step(Z,(X,Y),_,_).               % we must reach the end
:- step(Z1,(X,Y),_,T), step(Z2,(X,Y),_,T), Z1>Z2.       % vertex conflict
:- step(Z1,(X,Y),_,T), step(Z2,(X,Y),_,T-1), Z1>Z2 .    % edge conflict

#show step/3.