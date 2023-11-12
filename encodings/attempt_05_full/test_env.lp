%cell((1,0), 0). 
%cell((1,1), 0). 
%cell((1,2), (15,90)). 
%cell((1,3), (7,270)). 
%cell((0,0), (7,90)). 
%cell((0,1), (1,90)). 
%cell((0,2), (21,270)). 
%cell((0,3), (7,270)).
%start(cell(0,0), dir(e)).
%end(cell(0,3)).
%maxTime(3).

% environment as cells
cell((0,1), 0). 
cell((1,1), 16386). 
cell((2,1), 256). 
cell((0,0), 4). 
cell((1,0), 3089). 
cell((2,0), 256). 

% instance properties
start(cell(0,0), dir(e)).
end(cell(2,1)).
maxTime(3).