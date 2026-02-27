% stupid scenario of all trains moving forward to see whether message passing and malfunction passing works
time(0..T) :- end(_,_,T).
agent(A) :- start(A,_,_,_).

action(train(A), move_forward, T) :- time(T), agent(A).

load(dummy).
save(never).
save(set) :- load(never).
save(the) :- load(set).
save(cat) :- load(the).
save(on) :- load(cat).
save(fire) :- load(on).
save(X) :- load(X).

#show X : save(X), X!= dummy.
#show malfunction/3.