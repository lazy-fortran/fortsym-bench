FullSimplify[Curl[Curl[{0, AP[R]/R, 0}, {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]

DSolve[(Derivative[1][AP][R] - R*Derivative[2][AP][R])/R^2 == R*JP, AP[R], R]

sol = {AP[R] -> C[1]*R^2 + C[2]}

FullSimplify[Curl[Curl[{0, (-JP)*(R^3/8), 0}, {R, P, Z}, "Cylindrical"], {R, P, Z}, "Cylindrical"]]

eq1 = AP[R] == 1 /. sol /. R -> 1

eq = {Ca[2] == 0, Cc[1] == 1, (-JP/8)*Ra^4 + Ca[1]*Ra^2 + Ca[2] == Cb[1]*Ra^2 + Cb[2], Cb[1]*Rb^2 + Cb[2] == Cc[1]*Rb^2 + Cc[2], (2*Ca[1]*Ra - (1/2)*JP*Ra^3)/Ra == nu0*((2*Cb[1]*Ra)/Ra), Cc[1] == nu0*Cb[1]}

solc = Flatten[FullSimplify[Solve[eq, {Ca[1], Ca[2], Cb[1], Cb[2], Cc[1], Cc[2]}]]]

solc2 = FullSimplify[solc /. {nu0 -> 1/50, Ra -> 4/10, Rb -> 5/10}]

JP0 = 1, Null, parta = (AP[R] /. sol) - (1/8)*JP*R^4 /. C -> Ca /. solc2 /. JP -> JP0, Null, partb = AP[R] /. sol /. C -> Cb /. solc2 /. JP -> JP0, Null, partc = AP[R] /. sol /. C -> Cc /. solc2 /. JP -> JP0, Null, A = Piecewise[{{parta, R <= 0.4}, {partb, 0.4 < R && R < 0.5}, {partc, R >= 0.5}}], Null, Plot[A, {R, 0, 1}]

res = Table[{R, A}, {R, 0.001, 1, 0.001}]; 

SetDirectory[NotebookDirectory[]], Null, Export["aphi_analyt.tsv", res]

bparta = D[(AP[R] /. sol) - (1/8)*JP*R^4, R]/R /. C -> Ca /. solc2 /. JP -> JP0, Null, bpartb = D[(AP[R] /. sol)/50, R]/R /. C -> Cb /. solc2 /. JP -> JP0, Null, bpartc = D[AP[R] /. sol, R]/R /. C -> Cc /. solc2 /. JP -> JP0, Null, B = Piecewise[{{bparta, R <= 0.4}, {bpartb, 0.4 < R && R < 0.5}, {bpartc, R >= 0.5}}], Null, Plot[B, {R, 0, 1}]

Bres = Table[{R, A/R}, {R, 0.001, 1, 0.001}]; , Null, Export["bz_analyt.tsv", Bres], Null

Integrate[(52/25)*R - (1/2)*R^3, {R, 0, 2/5}] + Integrate[100*R, {R, 2/5, 1/2}] + Integrate[2*R, {R, 1/2, 1}]

N[%]
