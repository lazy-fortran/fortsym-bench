ParametricPlot3D[{t*Cos[t], t*Sin[t], 2*t}, {t, 0, 4*Pi}]

p1 = ParametricPlot3D[{2*Sin[t]*Sin[p], Sin[t]*Cos[p], 3*Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]; , Null, p2 = ContourPlot[Sqrt[1 - (x/2)^2 - y^2]*3, {x, -2, 2}, {y, -1, 1}, AspectRatio -> 1/2]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

p1 = Plot3D[Abs[Sin[x + y*I]], {x, -3*Pi, 3*Pi}, {y, -2, 2}]; , Null, p2 = ContourPlot[Abs[Sin[x + y*I]], {x, -3*Pi, 3*Pi}, {y, -2, 2}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450], Null

f = Exp[I*r*Cos[x + y*I]]*Exp[I*(x + y*I - Pi/2)]; , Null, p1 = Plot3D[Abs[f /. r -> 1], {x, 0, Pi}, {y, -Pi/2, Pi/2}]; , Null, p2 = ContourPlot[Abs[f /. r -> 1], {x, 0, Pi}, {y, -Pi/2, Pi/2}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

p1 = Plot3D[Abs[f /. r -> 10], {x, -0.3, 0.5}, {y, -0.4, 0.4}]; , Null, p2 = ContourPlot[Abs[f /. r -> 10], {x, -0.3, 0.5}, {y, -0.4, 0.4}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

ParametricPlot3D[{Cos[t], Sin[t], t/4}, {t, 0, 4*Pi}, PlotStyle -> Red, AxesLabel -> {"x", "y", "z"}, AxesStyle -> Green, BoxStyle -> Blue, Background -> Yellow]

Plot3D[Abs[Sin[x + y*I]], {x, -1.2*Pi, 1.2*Pi}, {y, -1.1, 1.1}, PlotRange -> {0, 1.1}, Ticks -> {{-Pi, Pi}, {-1, 1}}, AxesLabel -> {"x", "y"}, MeshStyle -> Blue, BaseStyle -> Red, ClippingStyle -> Yellow]

p = Table[ParametricPlot3D[{Cos[u], Sin[u], v}, {u, 0, 2*Pi}, {v, -5/2, 5/2}, ViewPoint -> v], {v, {{1.3, -2.4, 2}, Left, Top, {2, -2, -2}}}]
