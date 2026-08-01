ELevi = {{0, 1/J}, {-J^(-1), 0}}

nu = {{nuxx, nuxy}, {nuyx, nuyy}}

ELevi . nu . ELevi

Jmat = D[{R*Cos[φ], R*Sin[φ], Z}, {{Z, R, φ}}], Null, Jinv = FullSimplify[D[{z, Sqrt[x^2 + y^2], ArcTan[y/x]}, {{x, y, z}}]], Null, Jxyz = FullSimplify[Inverse[Jinv]]

nuzrp = {{nuzz, nuzr, 0}, {nurz, nurr, 0}, {0, 0, nupp*(x^2 + y^2)}}

nuxyz = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}

Do[nuxyz[[i,j]] = Sum[Jinv[[k,i]]*Jinv[[l,j]]*nuzrp[[k,l]], {k, 3}, {l, 3}], {i, 3}, {j, 3}]

FullSimplify[nuxyz]

muzrp = {{20, 8/10, 0}, {-8/10, 40, 0}, {0, 0, 50/(x^2 + y^2)}}

FullSimplify[Inverse[muzrp]]

muzrp2 = {{muzz, muzr, 0}, {murz, murr, 0}, {0, 0, mupp/(x^2 + y^2)}}, Null, FullSimplify[Inverse[muzrp2]]

muxyz = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}

Do[muxyz[[i,j]] = Sum[Jxyz[[i,k]]*Jxyz[[j,l]]*muzrp2[[k,l]], {k, 3}, {l, 3}], {i, 3}, {j, 3}]

FullSimplify[muxyz]

FullSimplify[muxyz /. {muzz -> 10, muzr -> 5, murz -> 5, murr -> 20, mupp -> 50}]
