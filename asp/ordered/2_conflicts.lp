%% ensuring conflicts are forbidden

% choose who gets priority
1 {resolve((A,U),(B,V)); resolve((B,V),(A,U))} 1 :- move(A,_,U), move(B,_,V), U = (P,_), V = (P,_), A<B.

#edge((A,U),(A,V)) : move(A,U,V).
#edge((A,V),(B,W)) : resolve((A,U),(B,W)), move(A,U,V).

duration(U,V,1) :- edge(U,V), m=vf.
duration(U,V,0) :- edge(U,V), m=ef.
duration(U,V,d) :- edge(U,V), m=sf.
&diff{(A,U)+1}<=(A,V) :- move(A,U,V), edge(U,V).
&diff{(A,V)+W}<=(B,U) :- resolve(A,B,U), move(A,U,V), duration(U,V,W).

&diff{(A,U)}<=(A,V) :- move(A,"Start",U), move(A,V,"End").