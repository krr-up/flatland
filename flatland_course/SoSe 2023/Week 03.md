# Flatland encoding
> Week 3

## Progress
We have an encoding that produces a correct result for a single agent.  Congrats!


## Comments
### 👍 Positive feedback

> With this logic:
> `{ occur(Edge, T) } 1 :- transition(Edge), time(T).`
> if we include an upper limit, we are saying “choose between the action or a wait.”

> For all possible transitions, pick one and do that.  with your approach, you would need a constraint:
> `:- T1, T2.`

> Otherwise, you will end up with all waits.  If we rewrite it like this:
> `{ occur(Edge, T) : transition(Edge) } = 1 :- time(T).`
> we can simplify what we have.  For every transition, every possible action (wrt this transition) can happen, or you can wait.

### ⚠️ Making improvements

The encoding is long and written in such a manner that is a bit challenging to read the first time through.  Take some time to review the structure of the encoding and consider whether there are redundancies that can be removed.


