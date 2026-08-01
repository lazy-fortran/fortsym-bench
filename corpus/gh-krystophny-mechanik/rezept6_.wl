eom = {D[x[t], t, t] == om^2*x[t] + 2*om*D[y[t], t], D[y[t], t, t] == om^2*y[t] - 2*om*D[x[t], t]}

sol = DSolve[eom, Null]
