% four times the number of cells with tracks is the maximum time horizon without waits
%tracks(T*4) :- T = #count{ 1,X,Y : cell((X,Y),Type), Type != 0}.

%twos(T) 	:- T = #count{ 1,X,Y : cell((X,Y), (32800;1025;4608;16386;72;2064)) }. % straights and curves
%switches(S) :- S = #count{ 1,X,Y : cell((X,Y), (37408;17411;32872;3089;49186;1097;34864;5633;20994;16458;2136;6672)) }. % switches
%fours(F)	:- F = #count{ 1,X,Y : cell((X,Y), (33825;38433;50211;33897;35889;38505;52275)) }. % crossings

%tracks(X) 	:- twos(T), switches(S), fours(F), X = (T*2) + (S*2) + (F*4).

% maximum allowable time by Flatland - this is the global horizon
tracks(Z) :- Z = #max{ M,X,Y : end(X,Y,M) }.

% the distance between start and end is the minimum time horizon for an agent
distance(D,ID) :- start(agent(ID), (X1,Y1), _,_), end(agent(ID), (X2,Y2),_), DX=|X2-X1|, DY=|Y2-Y1|, D=DX+DY.

%#show tracks/1.
%#show action/3.
%#show at/4.
