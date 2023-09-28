"""
Build a flatland-compatible rendering of an environment

Input: 	track types and coordinates
Output: flatland environment array
"""

import re
import pandas as pd

# import the environment as ASP cell facts
with open('large_env.lp','r') as f:
    string = f.read()

cells = re.findall(r'^cell\(.*\)\.', string, flags=re.MULTILINE)
matches = [re.findall(r'\d+', cell) for cell in cells]
environment = [[(int(m[0]),int(m[1])),(int(m[2]),int(m[3]))] for m in matches]


#map the cell types + orientations to flatland-compatible encodings
mapping = {(1,0): 32800,
	(1,90): 1025,
	(15,0): 4608,
	(15,90): 16386,
	(15,180): 0,
	(15,270): 2064,
	(21,0): 0,
	(21,90): 0,
	(21,180): 0,
	(21,270): 0,
	(22,0): 49186,
	(22,90): 1097,
	(22,180): 0,
	(22,270): 5633,
	(3,0): 33825,
	(7,0): 8192,
	(7,90): 4,
	(7,180): 128,
	(7,270): 256}

# include the mappings
[cell.append(mapping.get(cell[1])) for cell in environment]

environment = pd.DataFrame(environment, columns = ['coordinates','track','encoding'])
environment['encoding'] = environment['encoding'].astype(int)

print(environment)


# (1,0)     → 32800
# (1,90)    → 1025
# (15,0)    → 4608    [8: 90]
# (15,90)   → 16386   [8: 0]
# (15,180)  →         [8]
# (15,270)  → 2064    [8: 90]
# (21,0)    →         [9]
# (21,90)   →         [9]
# (21,180)  →         [9]
# (21,270)  →         [9]
# (22,0)    → 49186   [10]
# (22,90)   → 1097    [10]
# (22,180)  →         [10]
# (22,270)  → 5633    [10]
# (3,0)     → 33825
# (7,0)     → 8192
# (7,90)    → 4
# (7,180)   → 128
# (7,270)   → 256