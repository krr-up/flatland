% test environment for track classes

% cells and track types
cell((1,1), 0).
cell((2,1), 0).
cell((3,1), 0).
cell((4,1), 0).
cell((5,1), 0).
cell((6,1), 0).
cell((7,1), 0).
cell((8,1), 0).
cell((9,1), 0).
cell((10,1), 0).
cell((11,1), 0).
cell((1,2), 4).
cell((2,2), 1025).
cell((3,2), 1025).
cell((4,2), 1025).
cell((5,2), 3089).
cell((6,2), 1025).
cell((7,2), 1097).
cell((8,2), 1025).
cell((9,2), 1025).
cell((10,2), 1025).
cell((11,2), 256).
cell((1,3), 0).
cell((2,3), 0).
cell((3,3), 0).
cell((4,3), 0).
cell((5,3), 16386).
cell((6,3), 1025).
cell((7,3), 4608).
cell((8,3), 0).
cell((9,3), 0).
cell((10,3), 0).
cell((11,3), 0).
cell((1,4), 0).
cell((2,4), 0).
cell((3,4), 0).
cell((4,4), 0).
cell((5,4), 0).
cell((6,4), 0).
cell((7,4), 0).
cell((8,4), 0).
cell((9,4), 0).
cell((10,4), 0).
cell((11,4), 0).

% environment parameters
maxTime(10).
agent(1..2).
start(agent(1), cell(2,2), dir(e)).
start(agent(2), cell(10,2), dir(w)).
end(agent(2), cell(2,2)).
end(agent(1), cell(10,2)).