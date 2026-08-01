g1 = 1/2 - Sqrt[3]/6; , Null, g2 = 1/2 + Sqrt[3]/6; , Null, l1[t_] := (t - g2)/(g1 - g2); , Null, l2[t_] := (t - g1)/(g2 - g1); , Null, e1 = Sqrt[2]*{x, y}; , Null, e2 = {x - 1, y}; , Null, e3 = {x, y - 1}; , Null, e4 = y*{x, y - 1}; , Null, e5 = x*{x - 1, y}; , Null, phi11 = l1[y]*e1; , Null, phi12 = l2[y]*e2; , Null, phi13 = l1[x]*e3; , Null, phi21 = l2[y]*e1; , Null, phi22 = l1[y]*e2; , Null, phi23 = l2[x]*e3; , Null, phi14 = e4; , Null, phi15 = e5; , Null

g11 = StreamPlot[phi11, {x, 0, 1}, {y, 0, 1}]; , Null, g12 = StreamPlot[phi12, {x, 0, 1}, {y, 0, 1}]; , Null, g13 = StreamPlot[phi13, {x, 0, 1}, {y, 0, 1}]; , Null, g21 = StreamPlot[phi21, {x, 0, 1}, {y, 0, 1}]; , Null, g22 = StreamPlot[phi22, {x, 0, 1}, {y, 0, 1}]; , Null, g23 = StreamPlot[phi23, {x, 0, 1}, {y, 0, 1}]; , Null, g14 = StreamPlot[phi14, {x, 0, 1}, {y, 0, 1}]; , Null, g15 = StreamPlot[phi15, {x, 0, 1}, {y, 0, 1}]; , Null, GraphicsGrid[{{g11, g12, g13, g14}, {g21, g22, g23, g15}}, ImageSize -> Full]

FullSimplify[Div[a11*phi11 + a12*phi12 + a13*phi13 + a21*phi21 + a22*phi22 + a23*phi23 + a14*phi14 + a15*phi15, {x, y}] /. x -> 0]

Div[phi15, {x, y}]

gr1 = StreamPlot[e1, {x, 0, 1}, {y, 0, 1}]; , Null, gr2 = StreamPlot[e2, {x, 0, 1}, {y, 0, 1}]; , Null, gr3 = StreamPlot[e3, {x, 0, 1}, {y, 0, 1}]; , Null, GraphicsGrid[{{gr1, gr2, gr3}}, ImageSize -> Full]

eb1[s1_, s2_] := (Sqrt[2]/(s2 - s1))*{s2*x, (s2 - s1)*y}; , Null, eb2[s1_, s2_] := (1/(s2 - s1))*{s2*x + y - s2, (s2 - 1)*y}; , Null, eb3[s1_, s2_] := (1/(s2 - s1))*{(s2 - 1)*x, x + s2*y - s2}; , Null, phib11 = FullSimplify[eb1[g1, g2]], Null, phib12 = FullSimplify[eb2[g2, g1]], Null, phib13 = FullSimplify[eb3[g1, g2]], Null, phib21 = FullSimplify[eb1[g2, g1]], Null, phib22 = FullSimplify[eb2[g1, g2]], Null, phib23 = FullSimplify[eb3[g2, g1]]

g11 = StreamPlot[phib11, {x, 0, 1}, {y, 0, 1}]; , Null, g12 = StreamPlot[phib12, {x, 0, 1}, {y, 0, 1}]; , Null, g13 = StreamPlot[phib13, {x, 0, 1}, {y, 0, 1}]; , Null, g21 = StreamPlot[phib21, {x, 0, 1}, {y, 0, 1}]; , Null, g22 = StreamPlot[phib22, {x, 0, 1}, {y, 0, 1}]; , Null, g23 = StreamPlot[phib23, {x, 0, 1}, {y, 0, 1}]; , Null, GraphicsGrid[{{g11, g12, g13}, {g21, g22, g23}}, ImageSize -> Full]

B = a11*phib11 + a12*phib12 + a13*phib13 + a21*phib21 + a22*phib22 + a23*phib23; , Null, sol = Flatten[Solve[Div[B, {x, y}] == 0, a23]]

B0 = FullSimplify[B /. sol]

FullSimplify[Div[B0, {x, y}]]

DSolve[D[{x[t], y[t]}, t] == (B0 /. {a11 -> 1, a12 -> 1, a13 -> 1, a21 -> 0, a22 -> 1, a23 -> 1, x -> x[t], y -> y[t]}), {x[t], y[t]}, t]

StreamPlot[B0 /. {a11 -> 1, a12 -> 1, a13 -> 1, a21 -> 1, a22 -> 1, a23 -> 1}, {x, 0, 1}, {y, 0, 1}]

phic11 = 2*{x, 0}; phic12 = 2*{0, y}; , Null, phic21 = 2*{-y, y}; phic22 = 2*{x + y - 1, 0}; , Null, phic31 = 2*{0, x + y - 1}; phic32 = 2*{x, -x}; 

tri = Graphics[{FaceForm[White], EdgeForm[Black], Triangle[{{0, 0}, {1, 0}, {0, 1}}]}]; , Null, g11 = Show[tri, StreamPlot[phic11, {x, 0, 1}, {y, 0, 1}]]; , Null, g12 = Show[tri, StreamPlot[phic12, {x, 0, 1}, {y, 0, 1}]]; , Null, g13 = Show[tri, StreamPlot[phic21, {x, 0, 1}, {y, 0, 1}]]; , Null, g21 = Show[tri, StreamPlot[phic22, {x, 0, 1}, {y, 0, 1}]]; , Null, g22 = Show[tri, StreamPlot[phic31, {x, 0, 1}, {y, 0, 1}]]; , Null, g23 = Show[tri, StreamPlot[phic32, {x, 0, 1}, {y, 0, 1}]]; , Null, GraphicsGrid[{{g11, g12, g13}, {g21, g22, g23}}, ImageSize -> Full]

(* UNCONVERTED CELL *)
