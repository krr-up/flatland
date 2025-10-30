maxTime(3).

path(((X1,Y1),(X2,Y2)),1) :- start(_,(X1,Y1),_,D), offset(D,(DX,DY)), X2=X1+DX, Y2=Y1+DY.
{ path((V2,V3),T) : edge(V2,V3) } = 1 :- T = 2..M, maxTime(M), path((V1,V2),T-1). 

:- path(V1,V2,_), 

#show path/2.
#show start/4.