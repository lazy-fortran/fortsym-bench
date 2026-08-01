Clear[x, y, z, R0, r, th, ph]*(x = (R0 + r*Cos[th])*Cos[ph]; )*(y = (R0 + r*Cos[th])*Sin[ph]; )*(z = r*Sin[th]; )*Manipulate[ParametricPlot3D[{x, y, z} /. {R0 -> 1, r -> 1/A}, {th, -Pi, Pi}, {ph, 0, 2*Pi}], {{A, 3}, 1.1, 5}]

(nutilde[th_, a_] := -((th + 2*ArcTan[((a - 1)*Tan[th/2])/Sqrt[1 - a^2]])/Sqrt[1 - a^2]))*Manipulate[Plot[nutilde[th, 1/A], {th, -Pi, Pi}], {{A, 3}, 1.1, 5}]

(thf[th_, a_] := th + 2*a*((th + 2*ArcTan[((a - 1)*Tan[th/2])/Sqrt[1 - a^2]])/(1 - a^2)))*Manipulate[Plot[thf[th, 1/A], {th, -Pi, Pi}], {{A, 5}, 1.01, 10}]

Manipulate[Plot[$CellContext`thf[$CellContext`th, 1/A], {$CellContext`th, -Pi, Pi}], {{A, 5}, 1.01, 10}]

Manipulate[ContourPlot[thf[ArcTan[x, y], 1/A], {x, -1, 1}, {y, -Sqrt[1 - x^2], Sqrt[1 - x^2]}, ImageSize -> {300, 300}, AspectRatio -> Full, Contours -> 12], {{A, 5}, 2.01, 10}]

phiofth[th_, a_] := -2*ArcTan[((a - 1)*Tan[th/2])/Sqrt[1 - a^2]]

Manipulate[Plot[Mod[q*phiofth[th, 1/A] - Pi, 2*Pi] - Pi, {th, -Pi, Pi}, PlotRange -> {-Pi, Pi}, AxesLabel -> {theta, phi}], {{A, 3}, 1.1, 10}, {{q, 2.5}, 0.1, 5}]

Manipulate[plot1 = ParametricPlot3D[{x, y, z} /. {R0 -> 1, r -> 1/A}, {th, -Pi, Pi}, {ph, 0, 2*Pi}, Mesh -> None, PlotStyle -> {Opacity[0.3]}]; plot2 = ParametricPlot3D[{x, y, z} /. {R0 -> 1, r -> 1/A, ph -> q*phiofth[th, 1/A]}, {th, -Pi, Pi}, PlotStyle -> Thick]; Show[plot1, plot2], {{A, 3}, 1.1, 10}, {{q, 2.5}, 1, 10}]

Manipulate[plot1c = ParametricPlot3D[{x, y, z} /. {R0 -> 1, r -> 1/A}, {th, -Pi, Pi}, {ph, 0, 2*Pi}, Mesh -> None, PlotStyle -> {Opacity[0.3]}]; plot2c = ParametricPlot3D[{x, y, z} /. {R0 -> 1, ph -> q*phiofth[th, r]}, {th, -Pi, Pi}, {r, 0, 1/A}]; Show[plot1c, plot2c], {{A, 3}, 1.1, 10}, {{q, 2.5}, 1, 10}]
