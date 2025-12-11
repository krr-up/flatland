# Initial encoding analysis

## Subnodes

> 26 subnodes
> 4 decision subnodes: decision(1,0,e) decision(2,1,n) decision(1,2,e) decision(2,0,e)

The 26 subnodes form the basis of the number of paths, since they represet the set of trivial paths of length one. The subsequent increases of four additional paths (up to length four) is explained by the four decision subnodes. The fluctuations thereafter and subsequent consistent decrease (starting at length eight) can be explained by the rule preventing repetitions.

| Length | Models |
|--------|--------|
| 1      | 26     |
| 2      | 30     |
| 3      | 34     |
| 4      | 38     |
| 5      | 36     |
| 6      | 38     |
| 7      | 42     |
| 8      | 46     |
| 9      | 34     |
| 10     | 32     |
| 11     | 12     |
| 12     | 8      |
| 13     | 4      |
| 14     | UNSAT  |


