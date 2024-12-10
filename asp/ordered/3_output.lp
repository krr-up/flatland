
action(train(A),O,T):- dl((A,U,V),T), turn(edge(U,V),O).
action(train(A),move_forward,T):- dl((A,U,V),T), not turn(edge(U,V),_).
action(train(A),wait,T):- time(T), agent(A), dl((A,_,_),T).

#show action/3.