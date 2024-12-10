%% ensuring conflicts are forbidden

% choose who gets priority
1 {resolve((A,U),(B,V)); resolve((B,V),(A,U))} 1 :- move(A,_,U), move(B,_,V), shared_resource(U,V), A<B.

% #edge((A,U),(A,V)) : move(A,U,V).
% #edge((A,V),(B,W)) : resolve((A,U),(B,W)), move(A,U,V).

&diff{(A,U,V)+1}<=(A,V,W) :- move(A,U,V), move(A,V,W).
&diff{(A,U,V)}<=(B,W,X) :- resolve((A,U),(B,X)), move(A,U,V), move(B,W,X).
&diff{(A,U,"End")}<=T-1 :- move(A,U,"End"), end(A,_,T).
&diff{(A,"Start",U)}>=T+1 :- move(A,"Start",U), start(A,_,T,_).

#show agent/1.
#show time/1.
#show turn/2.