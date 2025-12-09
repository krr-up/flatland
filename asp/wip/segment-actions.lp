

% possible train rotations
rotation((n,n),forward).
rotation((w,w),forward).
rotation((s,s),forward).
rotation((e,e),forward).

rotation((n,w),left).  
rotation((w,s),left). 
rotation((s,e),left).  
rotation((e,n),left).

rotation((n,e),right). 
rotation((e,s),right).
rotation((s,w),right). 
rotation((w,n),right).


% choice for given direction
dir(n;s;w;e).
choice(Type,P) :- #count{ Q: transition(Type,(P,Q))} > 1, dir(P), transition(Type,_).


% given a selected transition segment, which action is appropriate
action(Type,(P,Q),Rotation) :- transition(Type, (P,Q)), choice(Type,P), rotation((P,Q),Rotation).
action(Type,(P,Q),forward)  :- transition(Type, (P,Q)), not choice(Type,P).

#show action/3.
