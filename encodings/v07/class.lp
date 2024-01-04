% class.lp - - -
% this file defines the class of each track
% and specifies the allowable actions for an agent for those tracks

% possible actions given a class
    % the agent can move forward, left, or right at junctions
    class_action(junction, l).
    class_action(junction, r).
    class_action(junction, f).

    % the agent can wait or move forward at waits
    class_action(wait, w).
    class_action(wait, f).

    % the agent can move forward on simples
    class_action(simple, f).

% determining what class a track is for an agent
    % it is a junction if it is a type of switch
    class((X,Y), junction) :- cell((X,Y), Type), Type = (37408;17411;32872;3089).               %type 2
    class((X,Y), junction) :- cell((X,Y), Type), Type = (38433;50211;33897;35889).              %type 4
    class((X,Y), junction) :- cell((X,Y), Type), Type = (38505;52275).                          %type 5
    class((X,Y), junction) :- cell((X,Y), Type), Type = (20994;16458;2136;6672).                %type 6
    class((X,Y), junction) :- cell((X,Y), Type), Type = (49186;1097;34864;5633).                %type 9
 
    % it is a wait if it is the neighbor of a junction or a crossing
    neighbor(0,1). neighbor(1,0). neighbor(0,-1). neighbor(-1,0).                               %neighbors

    class((X+A,Y+B), wait) :- class((X,Y), junction), neighbor(A,B), not cell((X+A,Y+B), 0).    %junction
    class((X+A,Y+B), wait) :- cell((X,Y), 33825), neighbor(A,B), not cell((X+A,Y+B), 0).        %type 3 (crossing)
    class((X,Y), wait) :- start(cell(X,Y), _, _).                                               %starting cell
    class((X,Y), wait) :- end(cell(X,Y), _).                                                    %ending cell

    % all other tracks are simple
    class((X,Y), simple) :- cell((X,Y), Type), not class((X,Y), wait), not class((X,Y), junction), Type!=0.

    %#show class/2.