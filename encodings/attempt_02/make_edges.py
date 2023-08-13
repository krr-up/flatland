### The goal is to take information about cells,
### that is their coordinates, their types, and their arrangements,
### and connect them together such that we can have groups
### of three cells that represent legal paths.

### My first idea is a two-step process.  The first step
### would identify pairs of cells which are connected.
### The second step would take this information, and 
### perform a tree-like search to find all possible
### triplets of cells.

### -------------------------
### |		|	  __|____   |	1
### |		|	 /	|		|
### -------------------------
### |   ____|__/____|____	|	0
### |		|		|		|
### -------------------------
### 	0		1		2

### According to the current definition of the cells
### we would receive input like this:
###		- (x,y,t,d,f)
###		- (0,0,7,w,0)
###		- (1,0,2,e,0)
### 	- (1,0,7,e,0)
###		- (0,1,0,n,0)
###		- (1,1,9,w,0) where 9 is a curve
###		- (2,1,7,e,0)

### What we have for each track type is a fixed matrix
### which shows where there are possible transitions
### or connections between the tracks.

### Algorithm: start at (0,0).
### Using the matrix, determine which neighbors it's connected to.
### Using the matrix of the connected neighbor, determine which
### further-neighbors are connected from that direction.
### Save those three 

# N = 0, W = 90, S = 180, E = 270
input_cells = [(0,0,"7",90), (0,1,"2L",270), (0,2,"7",270), (1,0,"0",0), (1,1,"1C",90), (1,2,"7",270)]

# e.g. when we get to cell (0,1), we obtain the matrix ("2L",270): [[0,0,1],[1,1,0],[0,0,0],[0,1,0]]
# from here we know we have a connection with the cell at its north, at its west, and at its east
# north is (X,Y+1), west is (X-1,Y), east is (X+1,Y)
# so with this information, we can already build out two of the three edges
# then for each of those we obtain the cells you can connect to from that side
# so when we pull the matrix for its north cell ("1C",90): 	[[0,0,0],[0,0,0],[0,0,1],[1,0,0]]
# we take the opposite of north (south) and check that row (third row) and see that it goes to the right
# right from the south is the cell to its east

# Step 1. 	pick a cell
# Step 2. 	start with the first direction
#			a. if it has a zero, move to the next direction
#			b. if it has a non-zero, check the matrix of the cell toward that direction
# 			c. we look only at the opposite direction (N vs. S / W vs. E, etc.)
# 			d. if it is Type 7, we duplicate it
#			e. if it not Type 7, we use each value of "1" as the final cell in our triplet-edge
#				[1,0,0] means the final cell is to the left of the incoming direction onto the second cell
# 					S → W ; W → N ; N → E ; E → S
# 				[0,1,0] means the final cell is straight ahead of the incoming direction onto the second cell
#					S → N ; W → E ; N → S ; E → W
# 				[0,0,1] means the final cell is to the right of the incoming direction onto the second cell
#					S → E ; W → S ; N → W ; E → N

# So what base components do we need?
# 1. as input, a set of tracks
# 2. track type static arrays
# 3. pair array values with relational directions (step e.) ...use a base-4 for this?
# 4. translate relational directions to changes in coordinates (offsets)

def find_matrix(cell):
	"""
	given a track type and its orientation, return the corresponding matrix
	"""
	track_paths = {	
		# north, west, south, east
		# [left, forward, right]
		("0",0): 	[[0,0,0],[0,0,0],[0,0,0],[0,0,0]],
		("1",0): 	[[0,1,0],[0,0,0],[0,1,0],[0,0,0]],
		("1",90): 	[[0,0,0],[0,1,0],[0,0,0],[0,1,0]],
		("1C",0): 	[[0,0,0],[0,0,1],[1,0,0],[0,0,0]],
		("1C",90): 	[[0,0,0],[0,0,0],[0,0,1],[1,0,0]],
		("1C",180): [[1,0,0],[0,0,0],[0,0,0],[0,0,1]],
		("1C",270): [[0,0,1],[1,0,0],[0,0,0],[0,0,0]],
		("1D",0): 	[[1,0,0],[0,0,1],[1,0,0],[0,0,1]],
		("1D",90): 	[[0,0,1],[1,0,0],[0,0,1],[1,0,0]],
		("2L",0): 	[[0,1,0],[0,0,1],[1,1,0],[0,0,0]],
		("2L",90): 	[[0,0,0],[0,1,0],[0,0,1],[1,1,0]],
		("2L",180): [[1,1,0],[0,0,0],[0,1,0],[0,0,1]],
		("2L",270): [[0,0,1],[1,1,0],[0,0,0],[0,1,0]],
		("2R",0): 	[[0,1,0],[0,0,0],[0,1,1],[1,0,0]],
		("2R",90): 	[[1,0,0],[0,1,0],[0,0,0],[0,1,1]],
		("2R",180): [[0,1,1],[1,0,0],[0,1,0],[0,0,0]],
		("2R",270): [[0,0,0],[0,1,1],[1,0,0],[0,1,0]],
		("3",0): 	[[0,1,0],[0,1,0],[0,1,0],[0,1,0]],
		("4",0): 	[[0,1,0],[0,1,1],[1,1,0],[0,1,0]],
		("4",90): 	[[0,1,0],[0,1,0],[0,1,1],[1,1,0]],
		("4",180): 	[[1,1,0],[0,1,0],[0,1,0],[0,1,1]],
		("4",270): 	[[0,1,1],[1,1,0],[0,1,0],[0,1,0]],
		("5",0): 	[[1,1,0],[0,1,1],[1,1,0],[0,1,1]],
		("5",90): 	[[0,1,1],[1,1,0],[0,1,1],[1,1,0]],
		("6",0): 	[[0,0,0],[0,0,1],[1,0,1],[1,0,0]],
		("6",90): 	[[1,0,0],[0,0,0],[0,0,1],[1,0,1]],
		("6",180): 	[[1,0,1],[1,0,0],[0,0,0],[0,0,1]],
		("6",270): 	[[0,0,1],[1,0,1],[1,0,0],[0,0,0]],
		("7",0):	[[0,0,0],[0,0,0],[0,1,0],[0,0,0]],
		("7",90):	[[0,0,0],[0,0,0],[0,0,0],[0,1,0]],
		("7",180):	[[0,1,0],[0,0,0],[0,0,0],[0,0,0]],
		("7",270):	[[0,0,0],[0,1,0],[0,0,0],[0,0,0]]
	}
	return(track_paths[cell])


def find_third_cell(init_dir, array):
    """
    given an initial incoming direction and an array, determine potential third cells

    return: a set of cells that would complete an edge
    """
    offsets = {0: (0,1), 1: (-1,0), 2: (0,-1), 3: (1,0)}

    base = [(start-1)%4, (start+2)%4, (start+1)%4]
    result = [value for value, path in zip(base, array) if path == 1]	# include only values from the base where array has value of 1
    return([offsets[direction] for direction in result])				# return offset pairs that correspond to values in result list


def main():
    offsets = {0: (0,1), 1: (-1,0), 2: (0,-1), 3: (1,0)}
    cells = { (0,0): ("7",90), (1,0): ("2L",270), (2,0): ("7",270), (0,1): ("0",0), (1,1): ("1C",90), (2,1): ("7",270)} #input
    output = ""

    # iterate through each cell in the grid
    for cell in cells:
        matrix = find_matrix(cells[cell])

        # iterate through each of the four directional arrays
        for key, array in enumerate(matrix):

            # consider only arrays that are not [0,0,0]
            if(sum(array) > 0):
            	
                # find the second cell
                x2 = offsets[key][0] + cell[0]
                y2 = offsets[key][1] + cell[1]
                second_cell = (x2,y2)

                # find the array in the second cell from this direction
                flipped_direction = (key + 2)%4 # N → S, W → E, etc.
                second_cell_type = cells[second_cell]
                second_array = find_matrix(second_cell_type)[flipped_direction]

                # find the offsets for all possible third cells
                third_cell_offsets = find_third_cell(flipped_direction, second_array)
                for offset in third_cell_offsets:
                    third_cell = tuple([sum(x) for x in zip(second_cell,offset)])
                    output += "edge(cell" + str(cell) + ", cell" + str(second_cell) + ", cell" + str(third_cell) + "). \n"
    print(output)

if __name__ == "__main__":
    main()






