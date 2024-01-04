
| ∆ cell | cell type   | ∆ orientation | valid? | action                      |
|--------|-------------|---------------|:-------|:----------------------------|
| same   | non-switch  | 0º            | yes    | `STOP_MOVING`               |
| same   | non-switch  | 90º           | no     |                             |
| same   | non-switch* | 180º          | yes    | `MOVE_FORWARD`              |
| same   | switch      | 0º            | yes    | `STOP_MOVING`               |
| same   | switch      | 90º           | no     |                             |
| same   | switch      | 180º          | no     |                             |
| new    | non-switch  | 0º            | yes    | `MOVE_FORWARD`              |
| new    | non-switch  | 90º           | yes    | `MOVE_FORWARD`              |
| new    | non-switch  | 180º          | no     |                             |
| new    | switch      | 0º            | yes    | `MOVE_FORWARD`              |
| new    | switch      | 90º           | yes    | `MOVE_LEFT` or `MOVE_RIGHT` |
| new    | switch      | 180º          | no     |                             |

* 
* 

### Stop moving
`STOP_MOVING` occurs when the cell at T0 and T1 are the same, and when the orientation has not changed

| ∆ cell | cell type   | ∆ orientation |
|--------|-------------|---------------|
| same   | switch      | 0º            | 
| same   | non-switch  | 0º            |

### Move left or right
`MOVE_LEFT` or `MOVE_RIGHT` happens only when the cell changes, when the cell at T0 was a switch, and when the orientation changes in either direction by 90º

| ∆ cell | cell type   | ∆ orientation |
|--------|-------------|---------------|
| new    | switch      | 90º           |

### Move forward
`MOVE_FORWARD` occurs in the remaining valid cases

| ∆ cell | cell type   | ∆ orientation |
|--------|-------------|---------------|
| new    | switch      | 0º            | 
| new    | non-switch  | 0º            | 
| new    | non-switch  | 90º           | 
| same   | non-switch* | 180º          | 

