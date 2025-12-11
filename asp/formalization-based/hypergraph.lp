hyperedge(C1,C2,C3)     :- connected(C1,D,C2), connected(C2,D',C3), cell(C2,Type), transition(Type,(D,D')).
hypernode(C)            :- hyperedge(C,_,_; _,C,_; _,_,C).

% :-  step(C,D,T), step(C',D',T+1), step(C'',D'',T+2), 
%     not hyperedge(C,C',C'').
% :-  step(C,D,1), step(C',D',2), 
%     not hyperedge(_,C,C').
% :-  step(C,D,T), step(C',D',T+1), 
%     not hyperedge(C,C',_).
