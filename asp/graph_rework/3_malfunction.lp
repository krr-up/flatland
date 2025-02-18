% save map
save(edge(U,V)) :- edge(U,V).
% train information
save(at(V,A,T)) :- at(V,A,T).


% load map
edge(U,V) :- load(edge(U,V)).

% malfunction time
at(V,A,T):- load(at(V,A,T)),malfunction(_,_,TLast),T< TLast.
malfunction_custom(A,D-1,T+1):- malfunction(A,D,T), D>1.
malfunction_custom(A,D-1,T+1):- malfunction_custom(A,D,T), D>1.
at(V,A,T+1):- malfunction_custom(A,_,T),at(V,A,T) .
%efficiency rule, adding it here because it takes into account malfuntions
%at(vertex(P,D),A,T+1):-
%	at(vertex(_,P),A,T),
%	vertex(P,D),
%	not malfunction_custom(A,_,T),
%	{vertex(P,_)}==1.


#show malfunction/3.
