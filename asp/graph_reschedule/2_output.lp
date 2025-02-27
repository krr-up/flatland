% action given to start
a(A,2,T) :- not at(vertex(start),A,T+1), at(vertex(start),A,T).

% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1), at(V,A,T).

% generate turns if necessary
a(A,O,T) :- at(V,A,T), at(V',A,T+1), edge(V,_), turn(edge(V,V'),O).

% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1), not a(A,1,T), not a(A,3,T), at(_,A,T+1).


% translate all actions into the ouput
output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),O',T) :- a(A,O,T), output(O,O').

% save map
save(vertex(P,Q)) :- vertex(P,Q).
save(edge(U,V)) :- edge(U,V).
save(turn(E,O)) :- turn(E,O).
save(shared_resource(A,B)) :- shared_resource(A,B).
save(global(T)) :- global(T).
save(first_vertex(A,B)) :- first_vertex(A,B).
save(last_vertex(A,B)) :- last_vertex(A,B).

% train information
save(end(A,B,C)) :- end(A,B,C).
save(train(T)) :- train(T).
save(start(A,B,C,D)) :- start(A,B,C,D).
save(at(V,A,T)) :- at(V,A,T).


#show.