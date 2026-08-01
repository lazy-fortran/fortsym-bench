FullSimplify[Curl[Curl[{0, 0, AZ[R]}, {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]

DSolve[-((Derivative[1][AZ][R] + R*Derivative[2][AZ][R])/R) == JZ, AZ[R], R]

sol = {AZ[R] -> C[1]*Log[R] + C[2]}

FullSimplify[Curl[Curl[{0, 0, AZ[R] - (JZ*R^2)/4 /. sol}, {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]

eq1 = AZ[R] == 1 /. sol /. R -> 1

eq = {Ca[1] == 0, Cc[2] == 0, (-JZ/4)*Ra^2 + Ca[1]*Log[Ra] + Ca[2] == Cb[1]*Log[Ra] + Cb[2], Cb[1]*Log[Rb] + Cb[2] == Cc[1]*Log[Rb] + Cc[2], (-JZ/2)*Ra + Ca[1]/Ra == nu0*(Cb[1]/Ra), Cc[1]/Rb == nu0*(Cb[1]/Rb)}

solc = Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]

solc2 = FullSimplify[solc /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2}]

JZ0 = 1, Null, parta = (AZ[R] /. sol) - (JZ/4)*R^2 /. C -> Ca /. solc2 /. JZ -> JZ0, Null, partb = AZ[R] /. sol /. C -> Cb /. solc2 /. JZ -> JZ0, Null, partc = AZ[R] /. sol /. C -> Cc /. solc2 /. JZ -> JZ0, Null, A = Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}], Null, Plot[A, {R, 0, 1}]

Null

res = Table[{R, A}, {R, 0.001, 1, 0.001}]; , Null, SetDirectory[NotebookDirectory[]], Null, Export["az_analyt.tsv", res]

bparta = -D[(AZ[R] /. sol) - (JZ/4)*R^2, R] /. C -> Ca /. solc, Null, bpartb = -D[AZ[R] /. sol, R] /. C -> Cb /. solc, Null, bpartc = -D[AZ[R] /. sol, R] /. C -> Cc /. solc, Null, bparta = bparta /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0, Null, bpartb = bpartb /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0, Null, bpartc = bpartc /. {nu0 -> 1/50, Ra -> 2/5, Rb -> 1/2} /. JZ -> JZ0, Null, B = Piecewise[{{bparta, R <= 0.4}, {bpartb, 0.4 < R && R < 0.5}, {bpartc, R >= 0.5}}], Null, Plot[B, {R, 0, 1}]

Bres = Table[{R, B}, {R, 0.001, 1, 0.001}]; , Null, Export["bphi_analyt.tsv", Bres], Null
