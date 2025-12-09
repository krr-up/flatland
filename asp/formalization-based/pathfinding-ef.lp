% pre-spawn logic
step(Z,(X,Y),D,T) :- start(Z,(X,Y),T,D).

% first step
{ step(Z,N',D',T) : p(N,N',D), q(N,N',D') } = 1 :- start(Z,N,T-1,D).

% subsequent steps
{ step(Z,N',D',T) : node(N') } = 1 :- 
    step(Z,N,D,T-1),
    p(N,N',D),
    q(N,N',D'),
    % end(Z,_,End), not T > End.
    T <= 2.

 

% % constraints
% :- end(Z,(X,Y),_), not step(Z,(X,Y),_,_).               % we must reach the end
% :- step(Z1,(X,Y),_,T), step(Z2,(X,Y),_,T), Z1>Z2.       % vertex conflict
% :- step(Z1,(X,Y),_,T), step(Z2,(X,Y),_,T-1), Z1>Z2 .    % edge conflict



% #show p/3.
#show step/4.