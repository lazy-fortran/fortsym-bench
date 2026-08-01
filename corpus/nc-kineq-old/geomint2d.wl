nodeactual = {{0, 0}, {1, 0}, {0.7, 0.9}}; 

node = {{x1, y1}, {x2, y2}, {x3, y3}}; 

l = {Norm[node[[3,All]] - node[[2,All]]], Norm[node[[1,All]] - node[[3,All]]], Norm[node[[2,All]] - node[[1,All]]]}; , Null, S = Det[Append[Transpose[node], {1, 1, 1}]]/2; 

Mtri = {{1, 1, 1}, node[[All,1]], node[[All,2]]}, Null, Minv = Inverse[Mtri], Null, L[x_, y_] = Minv . {1, x, y}

N12[x_, y_] = L[x, y][[1]]*Grad[L[x, y][[2]], {x, y}] - L[x, y][[2]]*Grad[L[x, y][[1]], {x, y}]; , Null, R1[x_, y_] = (l[[1]]/(2*S))*{x - node[[1,1]], y - node[[1,2]]}; , Null, N1[x_, y_] = {-R1[x, y][[2]], R1[x, y][[1]]}; , Null, R2[x_, y_] = (l[[2]]/(2*S))*{x - node[[2,1]], y - node[[2,2]]}; , Null, N2[x_, y_] = {-R2[x, y][[2]], R2[x, y][[1]]}; , Null, R3[x_, y_] = (l[[3]]/(2*S))*{x - node[[3,1]], y - node[[3,2]]}; , Null, N3[x_, y_] = {-R3[x, y][[2]], R3[x, y][[1]]}; 

B[x_, y_] = FullSimplify[b1*(R1[x, y]/Div[R1[x, y], {x, y}]) + b2*(R2[x, y]/Div[R2[x, y], {x, y}]) - (b1 + b2)*(R3[x, y]/Div[R3[x, y], {x, y}])], Null, FullSimplify[Div[B[x, y], {x, y}]]

Bval = B[x, y] /. {x1 -> 0, y1 -> 0, x2 -> 1, y2 -> 0, x3 -> 0.7, y3 -> 0.9, b1 -> 0, b2 -> 3}, Null, Show[Graphics[{FaceForm[White], EdgeForm[Black], Triangle[nodeactual]}], VectorPlot[Bval, {x, 0, 1}, {y, 0, 1}]]

FullSimplify[a1*(R1[x, y]/Div[R1[x, y], {x, y}]) + a2*(R2[x, y]/Div[R2[x, y], {x, y}]) - (a1 + a2)*(R3[x, y]/Div[R3[x, y], {x, y}])]

B11[x_, y_] = 2*{x, 0}; B12[x_, y_] = 2*{0, y}; , Null, B21[x_, y_] = 2*{-y, y}; B22[x_, y_] = 2*{x + y - 1, 0}; , Null, B31[x_, y_] = 2*{0, x + y - 1}; B32[x_, y_] = 2*{x, -x}; , Null, FullSimplify[a11*(B11[x, y]/Div[B11[x, y], {x, y}]) + a12*(B12[x, y]/Div[B12[x, y], {x, y}]) + a21*(B21[x, y]/Div[B21[x, y], {x, y}]) + a22*(B22[x, y]/Div[B22[x, y], {x, y}]) + a31*(B31[x, y]/Div[B31[x, y], {x, y}]) - (a11 + a12 + a21 + a22 + a31)*(B32[x, y]/Div[B32[x, y], {x, y}])], Null, B = B11[x, y] + B12[x, y] + B21[x, y] + B22[x, y] + B31[x, y] - 5*B32[x, y], Null, Div[B, {x, y}], Null, Show[Graphics[{FaceForm[White], EdgeForm[Black], Triangle[{{0, 0}, {1, 0}, {0, 1}}]}], StreamPlot[B, {x, 0, 1}, {y, 0, 1}]]

Div[B21[x, y], {x, y}]

B = a11*B11[x, y] + a12*B12[x, y] + a21*B21[x, y] + a22*B22[x, y] + a31*B31[x, y] - (a11 + a12 + a21 + a22 + a31)*B32[x, y], Null, FullSimplify[Div[B, {x, y}]]

sol = Simplify[(Flatten /. {E^(-2*Sqrt[a12^2 + a11*(-a21 + a22) + (a22 + a31)^2 + a12*(a21 + a22 + 2*a31)]*t) -> A})[DSolve[D[{x[t], y[t]}, t] == (B /. {x -> x[t], y -> y[t]}), {x[t], y[t]}, t]]]

r = Sqrt[(R - 1)^2 + Z^2]; , Null, th = ArcTan[Z/(R - 1)]; , Null, dRdr = Cos[th]; , Null, dZdr = Sin[th]; , Null, dRdth = -Z; , Null, dZdth = R - 1; , Null, Bph = 1/R^2; , Null, Bth = FullSimplify[r^2/(q*R*Sqrt[1 - r^2])]; , Null, BR = dRdth*Bth, Null, BZ = dZdth*Bth, Null, ass = {Element[{R, ph, Z, q, q0, q2}, Reals], q0 > 0, q2 > 0, R > 0}; 

Aphsol2 = FullSimplify[Integrate[x^3/((q0 + q1*x^2)*Sqrt[1 - x^2]), x] /. {x -> r, q0 -> 1, q1 -> 4}]

ContourPlot[Aphsol2, {R, 0, 1.5}, {Z, -0.5, 0.5}, PlotLegends -> Automatic]

Bsol1 = {BR, BZ} /. q -> 1 + 4*r^2, Null, Bsol2 = FullSimplify[Curl[{0, Aphsol2/R, 0}, {R, ph, Z}, "Cylindrical"], ass]; , Null, Bsol2 = {Bsol2[[1]], Bsol2[[3]]}

StreamPlot[Bsol1, {R, 0, 1.5}, {Z, -0.5, 0.5}]

StreamPlot[Bsol2, {R, 0, 1.5}, {Z, -0.5, 0.5}]

Aphi = Aphsol2; , Null, Bvec = Bsol2; , Null, Bphi = 1; , Null, B = Simplify[Sqrt[Bvec[[1]]^2 + Bvec[[2]]^2 + Bphi^2/R^2]]; , Null, ContourPlot[B, {R, 0.5, 1.5}, {Z, -0.5, 0.5}, PlotLegends -> Automatic]

e = 1; , Null, c = 1; , Null, m = 1; , Null, w = 10^(-4); , Null, mu = w*1.; , Null, vpar = Sqrt[(2/m)*(w - mu*B)]; , Null, vperp = Sqrt[(2/m)*B*mu]; , Null, v = Sqrt[vpar^2 + vperp^2]; , Null, ContourPlot[vpar, {R, 0.5, 1.5}, {Z, -0.5, 0.5}, PlotLegends -> Automatic]

R0 = 1.2; , Null, Z0 = 0.; , Null, pphi = Simplify[m*vpar*(Bphi/B) + (e/c)*Aphi /. {R -> R0, Z -> Z0}], Null, H = c*(Bphi/e)*(w/B^2 - mu/B) - (e/(2*m*c*Bphi))*(Aphi - (c/e)*pphi)^2; , Null, vpar/v /. {R -> R0, Z -> Z0}, Null, H0 = H /. {R -> R0, Z -> Z0}, Null, ContourPlot[H == 0, {R, 0.5, 1.5}, {Z, -0.5, 0.5}, PlotLegends -> Automatic]

Bstar = {(-R^(-1))*D[H, Z], (1/R)*D[H, R]}; 

StreamPlot[Bstar, {R, 0.7, 1.5}, {Z, -0.5, 0.5}, StreamPoints -> Fine]
