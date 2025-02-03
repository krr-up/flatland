% action given to start
a(A,2,T) :- at(_,A,T+1), not at(_,A,T).

% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1), at(V,A,T).

% generate turns if necessary
a(A,O,T) :- at(V,A,T), at(V',A,T+1), 2 {edge(V,_)}, turn(edge(V,V'),O).

% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1), not a(A,1,T), not a(A,3,T), at(_,A,T+1).


output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),wait,0..T-1) :- at(_,A,T+1), not at(_,A,T).
action(train(A),O',T) :- a(A,O,T), output(O,O').
% #show action/3.
% #show at/3.
#show.

save(at(V,A,T)) :- at(V,A,T).
save(edge(U,V)) :- edge(U,V).
save(turn(E,O)) :- turn(E,O).
save(vertex(P,Q)) :- vertex(P,Q).
save(shared_resource(A,B)) :- shared_resource(A,B).
save(end(A,B,C)) :- end(A,B,C).
save(train(T)) :- train(T).
save(start(A,B,C,D)) :- start(A,B,C,D).
save(dir_move(A,B)) :- dir_move(A,B).