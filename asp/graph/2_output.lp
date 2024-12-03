% action given to start
a(A,2,T) :- at(_,A,T+1), not at(_,A,T).

% stop action if an agent waits
a(A,4,T) :- at(V,A,T+1), at(V,A,T).

% generate turns if necessary
a(A,O,T) :- at(V,A,T), at(V',A,T+1), 2 {edge(V,_)}, turn(edge(V,V'),O).

% generate move action if a train continues moving
a(A,2,T) :- at(V,A,T), not at(V,A,T+1),
    not a(A,1,T), not a(A,3,T), at(_,A,T+1).


output(1,move_left).output(2,move_forward).output(3,move_right).output(4,wait).
action(train(A),wait,T') :- at(_,A,T+1), not at(_,A,T), time(T'), T'<T.
action(train(A),O',T) :- a(A,O,T), output(O,O').
#show action/3.