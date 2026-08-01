$Assumptions = {Element[{r, r0, s, p, z, l, m, n, sr, sz}, Reals], r0 > 0, r > 0}

bas = Exp[I*n*p]; , Null, tail = r^3*Exp[-((r - r0)^2/(2*sr^2) + z^2/(2*sr^2))]; 

Ar = tail*bas; , Null, Az = 0; , Null, A = {Ar, 0, Az}; , Null, B = FullSimplify[Curl[A, {r, p, z}, "Cylindrical"]], Null, J = FullSimplify[Curl[B, {r, p, z}, "Cylindrical"]], Null, conds = {r0 -> 160, n -> 1, sr -> 10, sz -> 10}, Null, Jv = Simplify[Re[J[[{1, 3}]]/bas] /. conds], Null, Bv = Simplify[Im[B[[{1, 3}]]/bas] /. conds], Null, Av = Simplify[Re[{Ar, Az}/bas] /. conds], Null, VectorPlot[Jv, {r, 160 - 20, 180}, {z, -20, 20}], Null, VectorPlot[Bv, {r, 160 - 20, 180}, {z, -20, 20}], Null, VectorPlot[Av, {r, 160 - 20, 180}, {z, -20, 20}]

Plot[Jv /. z -> 0, {r, 0, 5}], Null, Plot[Bv /. z -> 0, {r, 0, 5}], Null, Plot[Av /. z -> 0, {r, 0, 5}]

Null

Plot[Jv /. r -> 0, {z, -3, 3}], Null, Plot[Bv /. r -> 0, {z, -3, 3}], Null, Plot[Av /. r -> 0, {z, -3, 3}]

FullSimplify(Part(J,1)/bas)

FullSimplify(Part(J,3)/bas)

FullSimplify(FullSimplify(Part(A,1)/bas))

FullSimplify(Part(A,3)/bas)
