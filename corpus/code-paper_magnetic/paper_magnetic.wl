$Assumptions = g11[x1, x2] > 0 && g12[x1, x2] > 0 && g22[x1, x2] > 0 && g33[x1, x2] > 0 && gt[x1, x2] > 0 && n > 0; 

g = Det[{{g11[x1, x2], g12[x1, x2], 0}, {g12[x1, x2], g22[x1, x2], 0}, {0, 0, g33[x1, x2]}}]; , Null, sqg = Sqrt[gt[x1, x2]*g33[x1, x2]]; , Null, B1u = (-I)*(n/sqg)*A2l[x1, x2]; , Null, B2u = I*(n/sqg)*A1l[x1, x2]; , Null, B3u = (1/sqg)*(D[A2l[x1, x2], x1] - D[A1l[x1, x2], x2]); 

B1l = g11[x1, x2]*B1u + g12[x1, x2]*B2u, Null, B2l = g12[x1, x2]*B1u + g22[x1, x2]*B2u, Null, B3l = FullSimplify[g33[x1, x2]*B3u]

Null

J1u = FullSimplify[(-I)*(n/sqg)*B2l], Null, J2u = FullSimplify[I*(n/sqg)*B1l]
