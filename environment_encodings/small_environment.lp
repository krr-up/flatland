% track transitions
path(X0,Y0, X,Y, -1*X0,   -1*Y0)    :- track(X,Y,T,D,F), X0 =     X+(|D-1|-1),  Y0 = -1*(Y+(|D-2|-1)),  T=1..5.       %straight
path(X0,Y0, X,Y, -1*X0,   -1*Y0)    :- track(X,Y,T,D,F), Y0 =     X+(|D-1|-1),  X0 = -1*(Y+(|D-2|-1)),  T=3..5.       %straight prime
path(X0,Y0, X,Y,    Y0*F, -1*X0*F)  :- track(X,Y,T,D,F), X0 =     X+(|D-1|-1),  Y0 = -1*(Y+(|D-2|-1)),  T=2.          %T=2,4,6,12. 
path(X0,Y0, X,Y, -1*Y0*F,    X0*F)  :- track(X,Y,T,D,F), X0 =     X+(|D-1|-1),  Y0 = -1*(Y+(|D-2|-1)),  T=5..6.       %curved prime
path(X0,Y0, X,Y, -1*Y0*F,    X0*F)  :- track(X,Y,T,D,F), X0 = -1*(X+(|D-1|-1)), Y0 =     Y+(|D-2|-1),   T=5.          %curved contra prime
path(X0,Y0, X1,Y1, X2,Y2)           :- path(X2,Y2, X1,Y1, X0,Y0).                                                     %bidirectional


% designing the model world
	% tracks
	track(0,0,7,1,1). 
	track(1,0,2,1,1).
	track(2,0,7,3,1).
	track(0,1,0,0,0).
	track(1,1,9,3,1). % 9 is case 1a
	track(2,1,7,3,1).

	% trains
	init(train(0), at(0,0)).

	% stations
	init(station(0), at(2,0)).


% determining paths