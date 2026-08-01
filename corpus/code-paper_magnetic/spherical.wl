sqrtg := r^2*Sin[th], Null, g11 := 1, Null, g22 := r^2, Null, g33 := r^2*Sin[th]^2

gi11 := 1, Null, gi22 := 1/r^2, Null, gi33 := (1/r^2)*Sin[th]^2

g = {{g11, 0, 0}, {0, g22, 0}, {0, 0, g33}}

ginv = Inverse[g]

ginvsqrtg = Inverse[g]*sqrtg

numod = ginvsqrtg/g33

nu33 = FullSimplify[g33/sqrtg]

x = r*Sin[th]*Cos[ph], Null, y = r*Sin[th]*Sin[ph], Null, z = r*Cos[th]

J = {{D[x, r], D[x, th], D[x, ph]}, {D[y, r], D[y, th], D[y, ph]}, {D[z, r], D[z, th], D[z, ph]}}

Jinv = FullSimplify[Inverse[J]]

Bx = 1, Null, By = 0, Null, Bz = 0

Brctr = Jinv[[1,1]]*Bx + Jinv[[1,2]]*By + Jinv[[1,3]]*Bz, Null, Bthctr = Jinv[[2,1]]*Bx + Jinv[[2,2]]*By + Jinv[[2,3]]*Bz, Null, Bphctr = Jinv[[3,1]]*Bx + Jinv[[3,2]]*By + Jinv[[3,3]]*Bz

Brdens = FullSimplify[sqrtg*Brctr]

Bthdens = FullSimplify[sqrtg*Bthctr]

Bphdens = FullSimplify[sqrtg*Bphctr]
