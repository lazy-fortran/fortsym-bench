R[x_, y_, z_] = {{x, y, z - 1}, {x, y - 1, z}, {x - 1, y, z}, {x, y, z}}; , Null, B = FullSimplify[Sum[a[i]*R[x, y, z][[i]], {i, 1, 4}] /. {a[4] -> -Sum[a[i], {i, 1, 3}]}]

Div[B, {x, y, z}]

A = {a[1, 1]*x^2 + a[1, 2]*y^2 + a[1, 3]*z^2 + b[1, 1]*x*y + b[1, 2]*x*z + c[1, 1]*x + c[1, 2]*y + c[1, 3]*z + d[1], a[2, 1]*x^2 + a[2, 2]*y^2 + a[2, 3]*z^2 + b[2, 1]*x*y + b[2, 2]*x*z + c[2, 1]*x + c[2, 2]*y + c[2, 3]*z + d[2], a[3, 1]*x^2 + a[3, 2]*y^2 + a[3, 3]*z^2 + b[3, 1]*x*y + b[3, 2]*x*z + c[3, 1]*x + c[3, 2]*y + c[3, 3]*z + d[3]}

B = FullSimplify[Curl[A, {x, y, z}]]

sol = Flatten[DSolve[D[{x[t], y[t], z[t]}, t] == a*{x[t], y[t], z[t] - 1} + b*{x[t], y[t] - 1, z[t]} + c*{x[t] - 1, y[t], z[t]} + (-a - b - c)*{x[t], y[t], z[t]}, {x[t], y[t], z[t]}, t]]

FullSimplify[D[{x[t], y[t], z[t]} /. sol, t] - (a*{x[t], y[t], z[t] - 1} + b*{x[t], y[t] - 1, z[t]} + c*{x[t] - 1, y[t], z[t]} + d*{x[t], y[t], z[t]}) /. sol]

phi[1] = {-1 + x + y + z, 0, 0}; , Null, phi[2] = {0, -1 + x + y + z, 0}; , Null, phi[3] = {0, 0, -1 + x + y + z}; , Null, phi[4] = {x, 0, 0}; , Null, phi[5] = {0, y, 0}; , Null, phi[6] = {0, 0, z}; , Null, phi[7] = {x, -z, 0}; , Null, phi[8] = {-y, y, 0}; , Null, phi[9] = {x, 0, -x}; , Null, phi[10] = {-z, 0, z}; , Null, phi[11] = {0, y, -y}; , Null, phi[12] = {0, -z, z}; , Null, B = Sum[a[k]*phi[k], {k, 1, 11}] - Sum[a[k], {k, 4, 11}]*phi[12], Null

DSolve[D[{x[t], y[t], z[t]}, t] == (B /. {x -> x[t], y -> y[t], z -> z[t]}), {x[t], y[t], z[t]}, t]

FullSimplify[DSolve[D[{x[t], y[t], z[t]}, t] == {a[1]*x[t] + a[2]*y[t] + a[3]*z[t] + a[4], b[1]*x[t] + b[2]*y[t] + b[3]*z[t] + b[4], c[1]*x[t] + c[2]*y[t] + c[3]*z[t] + c[4]}, {x[t], y[t], z[t]}, t]]

e[1] = {y^2, (-x)*y, 0}; , Null, e[2] = {0, (-y)*z, y^2}; , Null, e[3] = {(-x)*y, x^2, 0}; , Null, e[4] = {(-x)*z, 0, x^2}; , Null, e[5] = {z^2, 0, (-x)*z}; , Null, e[6] = {0, z^2, (-y)*z}; , Null, e[7] = {y*z, (-x)*z, 0}; , Null, e[8] = {0, x*z, (-x)*y}; , Null, A = {a[1, 1] + a[1, 2]*x + a[1, 3]*y + a[1, 4]*z, a[2, 1] + a[2, 2]*x + a[2, 3]*y + a[2, 4]*z, a[3, 1] + a[3, 2]*x + a[3, 3]*y + a[3, 4]*z} + Sum[b[k]*e[k], {k, 1, 8}]; 

B = FullSimplify[Curl[A, {x, y, z}]]

FullSimplify[Div[B, {x, y, z}]]

DSolve[D[{x[t], y[t], z[t]}, t] == (B /. {x -> x[t], y -> y[t], z -> z[t]}), {x[t], y[t], z[t]}, t]

Phi1 = a[1, 1]*x^2 + a[1, 2]*y^2 + a[1, 3]*z^2 + a[1, 4]*x*y + a[1, 5]*x*z + a[1, 6]*y*z + a[1, 7]*x + a[1, 8]*y + a[1, 9]*z + a[1, 10]; Phi2 = a[2, 1]*x^2 + a[2, 2]*y^2 + a[2, 3]*z^2 + a[2, 4]*x*y + a[2, 5]*x*z + a[2, 6]*y*z + a[2, 7]*x + a[2, 8]*y + a[2, 9]*z + a[2, 10]; 

Solve[Cross[Grad[Phi1, {x, y, z}], Grad[Phi2, {x, y, z}]] == B, Flatten[Table[a[i, j], {i, 1, 2}, {j, 1, 10}]]]

DSolve[Grad[Ph[x, y, z], {x, y, z}] . B == 0, Ph[x, y, z], {x, y, z}]

B = {a[1, 1]*x + a[1, 2]*y + a[1, 3]*z + a[1, 4], a[2, 1]*x + a[2, 2]*y + a[2, 3]*z + a[2, 4], a[3, 1]*x + a[3, 2]*y + a[3, 3]*z + a[3, 4]}, Null, Div[B, {x, y, z}]

FullSimplify[DSolve[{D[y[x], x] == (B[[2]]/B[[1]] /. {y -> y[x], z -> 0, a[2, 2] -> -a[1, 1]}), y[0] == y0}, {y[x]}, x]]

Null

DSolve[{D[z[x, y], x], D[z[x, y], y]} == ({a, b} /. {z -> z[x, y], a[1, 1] -> 0, a[2, 2] -> 0, a[3, 3] -> 0}), z[x, y], {x, y}]
