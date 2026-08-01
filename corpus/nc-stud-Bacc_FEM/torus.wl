(* UNCONVERTED CELL *)

xtrans = FullSimplify[CoordinateTransform["Toroidal" -> "Cartesian", {et, th, ph}] /.  -> R0]

(* UNCONVERTED CELL *)

dudet = FullSimplify[D[u[R0/Cosh[et], th, Z], et] /. et -> ArcCosh[R0/r]], Null, d2udet2 = FullSimplify[D[D[u[R0/Cosh[et], th, Z], et], et] /. et -> ArcCosh[R0/r]], Null, d2udph2 = R0^2*Derivative[0, 0, 2][u][r, th, Z]

(* UNCONVERTED CELL *)

lapu0 = FullSimplify[Laplacian[u[et, th, ph], {et, th, ph}, "Toroidal"] /.  -> R0]

(* UNCONVERTED CELL *)

lapu = FullSimplify[lapu0 /. {Derivative[1, 0, 0][u][et, th, ph] -> dudet, Derivative[2, 0, 0][u][et, th, ph] -> d2udet2, Derivative[0, 0, 2][u][et, th, ph] -> d2udph2, et -> ArcCosh[R0/r], ph -> Z/R0} /. {ArcCosh[R0/r] -> r, Z/R0 -> Z}]

(* UNCONVERTED CELL *)

lapu2 = lapu /. {Derivative[0, 0, 2][u][r, th, Z] -> uzz, Derivative[2, 0, 0][u][r, th, Z] -> urr, Derivative[0, 2, 0][u][r, th, Z] -> utt, Derivative[1, 0, 0][u][r, th, Z] -> ur, Derivative[0, 1, 0][u][r, th, Z] -> ut}

(* UNCONVERTED CELL *)

FullSimplify[Series[lapu2, {R0, Infinity, 0}]]

(* UNCONVERTED CELL *)

FullSimplify[Series[lapu2, {R0, Infinity, 1}]]

(* UNCONVERTED CELL *)

FullSimplify[Laplacian[u[r, th, Z], {r, th, Z}, "Cylindrical"]]

(* UNCONVERTED CELL *)

FullSimplify[Series[FullSimplify[xtrans /. et -> ArcCosh[R0/r] /. ph -> Z/R0], {R0, Infinity, 0}], {Element[R0, Reals], R0 > 0}]

The*coordinate*transform*for*pseudotoroidal*coordinates*is*then*given*by

xt = (R0 + r*Cos[th])*Cos[ph]; , Null, yt = (R0 + r*Cos[th])*Sin[ph]; , Null, zt = r*Sin[th]; 

(* UNCONVERTED CELL *)

J = FullSimplify[{{D[xt, r], D[xt, th], D[xt, ph]}, {D[yt, r], D[yt, th], D[yt, ph]}, {D[zt, r], D[zt, th], D[zt, ph]}}]

Jinv = Normal[Series[FullSimplify[Inverse[J]], {r, 0, 0}]]

(* UNCONVERTED CELL *)

grad1 = FullSimplify[Jinv . {D[u[r, th, ph], r], D[u[r, th, ph], th], D[u[r, th, ph], ph]}]

div1 = FullSimplify[Jinv . {ddr, ddth, ddph}]
