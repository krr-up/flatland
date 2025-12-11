subnode(X,Y,D) 		:- 	cell((X,Y),Type), 
    				transition(Type, (D,_); Type, (_,D)).

edge((X1,Y1,D1), (X2,Y2,D2)) :- subnode(X1,Y1,D1), subnode(X2,Y2,D2), 
    				connected((X1,Y1),D1,(X2,Y2)), 
    				cell((X2,Y2), Type2), transition(Type2, (D1,D2)).         

violation_consecutive	:- 	step((X1,Y1),D1,T), step((X2,Y2),D2,T+1), 
    				not edge((X1,Y1,D1),(X2,Y2,D2)).
violation_unique	:- 	step((X,Y),D,T), 
				step((X,Y),D,T'), 
    				not T=T'.