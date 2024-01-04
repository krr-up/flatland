% these are the possible actions given a class

% the agent can move forward, left, or right at switches
class(switch, l).
class(switch, r).
class(switch, f).

% the agent can wait or move forward at waits
class(wait, w).
class(wait, f).

% the agent can move forward on simples
class(simple, f).