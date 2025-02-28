#const imax = 1.
% action given to start
a(A,2,T) :- not at(vertex(start),A,T+1), at(vertex(start),A,T).
% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1), at(V,A,T), V!=vertex(start), V!=vertex(end).
a(A,0,T) :- at(V,A,T+1), at(V,A,T), V=(vertex(start);vertex(end)).
% generate turns if necessary
a(A,O,T) :- at(V,A,T), at(V',A,T+1), turn(edge(V,V'),O).
% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1), not a(A,1,T), not a(A,3,T), at(_,A,T+1).

% translate all actions into the ouput
output(0,nothing).output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').

% save map
save(cell(A,B)) :- cell(A,B).
save(global(T)) :- global(T).

% train information
save(end(A,B,C)) :- end(A,B,C).
save(train(T)) :- train(T).
save(start(A,B,C,D)) :- start(A,B,C,D).
save(at(V,A,T)) :- at(V,A,T).


#show.