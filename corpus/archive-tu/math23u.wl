Clear[x, y], Null, fc = -Conjugate[2*I*Sqrt[Exp[x + I*y] - 1] - Log[(1 + I*Sqrt[Exp[x + I*y] - 1])/(1 - I*Sqrt[Exp[x + I*y] - 1])]]; 

c1 = ListPlot[{{-5, 0}, {0, 0}, {0, 7}}, Joined -> True, PlotStyle -> {Black, Thick}]; , Null, c2 = ListPlot[N[{{-5, -Pi}, {9, -Pi}}], Joined -> True, PlotStyle -> {Black, Thick}]; , Null, c3 = ListPlot[{{-5, -2*Pi}, {0, -2*Pi}, {0, -7 - 2*Pi}}, Joined -> True, PlotStyle -> {Black, Thick}]; 

p1 = ParametricPlot[{Re[fc], Im[fc]}, {x, -5, 3}, {y, 0.0001, Pi}]; , Null, p2 = ParametricPlot[{Re[fc], -2*Pi - Im[fc]}, {x, -5, 3}, {y, 0.0001, Pi}]; , Null, Show[p1, p2, c1, c2, c3, PlotRange -> {{-5, 9}, {-4*Pi, 2*Pi}}]
