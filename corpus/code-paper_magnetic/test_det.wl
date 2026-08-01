g = {{g11, g12, 0}, {g21, g22, 0}, {0, 0, g33}}

Det[g]

FullSimplify[Sqrt[Det[g]]*g22]

g = {{g11[x1, x2, x3], g12[x1, x2], g13[x1, x2]}, {g12[x1, x2], g22[x1, x2], Sqrt[g22[x1, x2]*g33[x1, x2]]}, {g13[x1, x2], Sqrt[g22[x1, x2]*g33[x1, x2]], g33[x1, x2]}}

FullSimplify[D[Det[g], x3]]

Det[g]

g = {{g11[x1, x2, x3], Sqrt[g11[x1, x2, x3]*g22[x1, x2, x3]], Sqrt[g11[x1, x2, x3]*g33[x1, x2, x3]]}, {Sqrt[g11[x1, x2, x3]*g22[x1, x2, x3]], g22[x1, x2, x3], Sqrt[g22[x1, x2, x3]*g33[x1, x2, x3]]}, {Sqrt[g11[x1, x2, x3]*g33[x1, x2, x3]], Sqrt[g22[x1, x2, x3]*g33[x1, x2, x3]], g33[x1, x2, x3]}}

FullSimplify[Det[g]]

FullSimplify[D[Det[g], x3]]

g = {{g11[x1, x2, x3], g13[x1, x2]*(g22[x1, x2]/g23[x1, x2]), g13[x1, x2]}, {g13[x1, x2]*(g22[x1, x2]/g23[x1, x2]), g22[x1, x2], g23[x1, x2]}, {g13[x1, x2], g23[x1, x2], g23[x1, x2]^2/g22[x1, x2]}}

Det[g]
