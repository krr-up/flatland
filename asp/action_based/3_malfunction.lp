%% File that is called when we want our solution to be malfunction-ready;
%% It does all the loading/saving (that does is not done 
%% in another file) and takes into account the waiting 
%% turns due to malfunction

% save map
save(offset(A,B,C)) :-offset(A,B,C).
save(transition(A,B)) :- transition(A,B).
save(choice(C,D)) :- choice(C,D).
save(move(A)) :- move(A).
save(idle(A)) :- idle(A).
save(dir(A)):- dir(A).


% load map
offset(U,V) :- load(offset(U,V)).
transition(A,B) :- load(transition(A,B)).
choice(Pos,D) :- load(choice(Pos,D)).
move(A) :- load(move(A)).
idle(A) :- load(idle(A)).
dir(A) :- load(dir(A)).
% base problem
end(A,B,C):- load(end(A,B,C)).
train(A):- load(train(A)).
start(A,P,T,D):- load(start(A,P,T,D)).
% train information
do(A,Act,T):- load(do(A,Act,T)),malfunction(_,_,TLast),T <= TLast.
active(A,T):- load(active(A,T)),malfunction(_,_,TLast),T <= TLast.
at(A,P,D,T):- load(at(A,P,T,D)),malfunction(_,_,TLast),T <= TLast.

% malfunction time
malfunction_custom(A,D,T):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(A,P,D,T+1):- malfunction_custom(A,_,T),at(A,P,D,T) .
:- malfunction_custom(A,_,T),not at(A,P,D,T),at(A,P,D,T+1).

