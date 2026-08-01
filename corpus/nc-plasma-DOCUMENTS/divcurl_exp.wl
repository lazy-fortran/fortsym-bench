$Assumptions = Element[{x, y, z, l, m, n}, Reals]

bas = Exp[I*n*z - l*Abs[x] - m*Abs[y]]; 

J = {Jx, Jy, Jz}*bas; divj = FullSimplify[Div[J, {x, y, z}]]/bas

B = {Bx, By, Bz}*bas; FullSimplify[Div[B, {x, y, z}]]

bzsol = FullSimplify[Flatten[Solve[divB == 0, Bz]]], Null, jzsol = FullSimplify[Flatten[Solve[divj == 0, Jz]]]

CB = FullSimplify[Curl[B, {x, y, z}]]/bas

eq = FullSimplify[CB == J/bas /. bzsol /. jzsol]

FullSimplify[divB = Div[B, {x, y, z}]/bas]

bsol = FullSimplify[Flatten[Solve[eq /. bzsol /. jzsol, {Bx, By}]]]

eq2 = FullSimplify[eq /. {bzsol, jzsol} /. {Bx -> (-I)*n*ay, By -> I*n*ax}]

asol = FullSimplify[Flatten[Solve[eq2, {ax, ay}]]]

a = FullSimplify[Flatten[{ax, ay} /. asol]], Null, Ca = FullSimplify[Curl[a*Exp[-(l*x + m*y)], {x, y}]/Exp[-(l*x + m*y)]], Null, Ca2 = FullSimplify[(D[ay*Exp[-(l*x + m*y)], x] - D[ax*Exp[-(l*x + m*y)], y])/Exp[-(l*x + m*y)] /. asol], Null, b = FullSimplify[Flatten[{Bx, By} /. bsol]], Null, B = FullSimplify[Flatten[{Bx, By, Bz} /. bsol /. bzsol]]

cond = {l -> 0, m -> 0, n -> 1, Jx -> -1, Jy -> 1}; , Null, FullSimplify[a /. cond], Null, FullSimplify[Ca /. cond], Null, FullSimplify[b /. cond], Null, FullSimplify[B /. cond]

Null
