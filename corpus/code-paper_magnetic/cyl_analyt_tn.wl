FullSimplify[Curl[Curl[{AR[R], 0, AZ[R]}*Exp[I*n*P], {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]/Exp[I*n*P]

DSolve[n^2*AZ[R] - R*(Derivative[1][AZ][R] + R*Derivative[2][AZ][R]) == 0, AZ[R], R]

sol = {AZ[R] -> C[1]/R^n + C[2]*R^n}

FullSimplify[Curl[Curl[{0, 0, AZ[R] /. sol}*Exp[I*n*P], {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]/Exp[I*n*P]

AZ[R] == 1 /. sol /. R -> 1, Null, FullSimplify[D[AZ[R] /. sol, R] /. n -> 1], Null, FullSimplify[AZ[R] /. sol /. n -> 1]

eq = {Ca[1] == 0, Cc[1] + Cc[2] == 1, Ca[2]*Ra^n == Cb[1]/Ra^n + Cb[2]*Ra^n, Cb[1]/Rb^n + Cb[2]*Rb^n == Cc[1]/Rb^n + (1 - Cc[1])*Rb^n, Ca[2]*Ra^(n - 1) == (-nu0)*Cb[1]*Ra^(-n - 1) + nu0*Cb[2]*Ra^(n - 1), (-Cc[1])*Rb^(-n - 1) + (1 - Cc[1])*Rb^(n - 1) == (-nu0)*Cb[1]*Rb^(-n - 1) + nu0*Cb[2]*Rb^(n - 1)}

solc = Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]

Null

sol2 = sol /. n -> 1, Null, solc2 = FullSimplify[solc /. {n -> 1, nu0 -> 1/50, Ra -> 4/10, Rb -> 5/10}]

parta = AZ[R] /. sol2 /. C -> Ca /. solc2, Null, partb = AZ[R] /. sol2 /. C -> Cb /. solc2, Null, partc = AZ[R] /. sol2 /. C -> Cc /. solc2

A = Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}]

22491 + 106436

Null

Plot[A, {R, 0, 1}]

res = Table[{R, A}, {R, 0.001, 1, 0.001}]; 

SetDirectory[NotebookDirectory[]], Null, Export["az_analyt.tsv", res]

Plot[A/R, {R, 0, 1}]

Bres = Table[{R, A/R}, {R, 0.001, 1, 0.001}]; , Null, Export["br_analyt.tsv", Bres], Null
