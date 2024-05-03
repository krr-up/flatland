% Example environment
% -------------------
% |	|   __|___  |	1
% |	|  /  |	    |
% -------------------
% |  ___|_/___|___  |	0
% |	|     |	    |
% -------------------
%    0	   1	 2

% In this small example, we only have three different track types
%	1. Type 15 (1C)
%	2. Type 21 (2L)
%	3. Type 7

% environment as cells
cell((0,0), (7,90)).
cell((1,0), (21,270)).
cell((2,0), (7,270)).
cell((1,1), (15,90)).
cell((2,1), (7,270)).

% instance properties
start(cell(0,0), dir(e)).
end(cell(2,1)).
maxTime(3).