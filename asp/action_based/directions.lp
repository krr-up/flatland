% this directions-based transitions file is based on the original transitions.lp
% however, transitions.lp follows the format (From,Action)
% which means it is facing a direction and has an action (f,r,l) to select
% but in the formalization, we define the transitions in terms of pairs of directions
% so (n,f) would be (n,n) because after moving forward, it would result in facing north

transition(32800, (s,f)).

convert(s,f,s).
convert(n,f,n).
convert(e,f,e).
convert(w,f,w).

convert(s,r,w).
convert(n,r,e).
convert(e,r,s).
convert(w,r,n).

convert(s,l,e).
convert(n,l,w).
convert(e,l,n).
convert(w,l,s).

new_transition(ID, (From,To)) :- transition(ID, (From,Action)), convert(From,Action,To).

% here we want to check an assumption that we have made in our formalization paper
% (d,d') iff (~d', ~d), where ~ is the complement (s <> n) and (w <> e)

complement(n,s).
complement(s,n).
complement(w,e).
complement(e,w).

complement_missing(ID) :- new_transition(ID, (From,To)), not new_transition(ID, (ToC,FromC)), complement(From,FromC), complement(To,ToC).

#show complement_missing/1.