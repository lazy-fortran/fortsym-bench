$Version

Information["ParametricPlot3D", LongForm -> False]

x = 7*Cos[t]; y = 7*Sin[t]; z = t; , Null, p1 = ParametricPlot3D[{x, y, z}, {t, 0, 7*Pi}]; p2 = Show[p1, Boxed -> False]; p3 = ParametricPlot3D[{x, y, z}, {t, 0, 7*Pi}, PlotStyle -> {Red, Thickness[0.03]}]; Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 450]

Information["ListPointPlot3D", LongForm -> False]

lt = Table[t*{Sin[t], Cos[t], -1}, {t, 0, 13.3, 0.1}]; , Null, p1 = ListPointPlot3D[lt]; , Null, p2 = ListPointPlot3D[lt, PlotStyle -> RGBColor[0.9, 0, 0]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 350]

a = 3 + Cos[u]; x = a*Cos[v]; y = a*Sin[v]; z = Sin[u]; p1 = ParametricPlot3D[{x, y, z}, {u, 0, 2*Pi}, {v, 0, 2*Pi}]; 

Clear[x, y, f]; f = x^2 - y^2; , Null, p2 = Plot3D[f, {x, -3, 3}, {y, -2, 2}]; 

Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

p1 = Plot3D[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]; , Null, p2 = Plot3D[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450], Null

Information["ListSurfacePlot3D", LongForm -> False]

p1 = ListSurfacePlot3D[Flatten[Table[{Cos[ϕ]*Sin[θ], Sin[θ]*Sin[ϕ], Cos[θ]}, {ϕ, -Pi, Pi, 0.2}, {θ, 0, Pi, 0.2}], 1]]; , Null, p2 = ListSurfacePlot3D[Flatten[Table[{x, y, Sin[x*y]}, {x, 0, 3, 0.1}, {y, 0, 3, 0.1}], 1]]; , Null, p3 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}]; , Null, GraphicsRow[{p1, p2, p3}, ImageSize -> 500]

Information["ContourPlot", LongForm -> False]

p1 = ContourPlot[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]; , Null, p2 = ContourPlot[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450], Null

Information["DensityPlot", LongForm -> False]

p1 = DensityPlot[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]; , Null, p2 = DensityPlot[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450], Null

Clear[f, r, x, y, z], Null, f[x_, y_, r_] = Abs[Exp[I*r*Cos[x + I*y]]]; , Null, s1 = Plot3D[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]; , Null, c1 = ContourPlot[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]; , Null, Show[GraphicsRow[{s1, c1}], ImageSize -> 500]

d1 = DensityPlot[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]

s2 = Plot3D[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}]; , Null, c2 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}]; , Null, Show[GraphicsRow[{s2, c2}], ImageSize -> 500]

s20 = Plot3D[f[x, y, 20], {x, 0, 2*Pi}, {y, -1, 1}]; , Null, s21 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}, PlotRange -> {0, 2}]; , Null, Show[GraphicsRow[{s20, s21}], ImageSize -> 500]

s22 = Show[s20, PlotRange -> {0, 1.5}, ViewPoint -> {-1., -2.4, 1.}]; , Null, s23 = Show[s21, AspectRatio -> 1]; , Null, Show[GraphicsRow[{s22, s23}], ImageSize -> 450]

pp = Plot3D[Sin[x*y], {x, 1, 2}, {y, 1, 2}, PlotPoints -> 5]

FullForm[pp]

pa = ParametricPlot3D[{x, y, Sin[x*y]}, {x, 1, 2}, {y, 1, 2}, PlotPoints -> 4, BoxRatios -> {1, 1, 0.4}]

FullForm[pa]

Information["Plot3D", LongForm -> True]

Information["ParametricPlot3D", LongForm -> False]

Clear[x, y, z], Null, z = Sin[x*y]; , Null, pp = Plot3D[z, {x, 0, 3}, {y, 0, 3}]

Information["AspectRatio", LongForm -> False]

p1 = Show[pp, AspectRatio -> Automatic]; , Null, p2 = Show[pp, AspectRatio -> 1.3]; 

Information["Axes  ", LongForm -> False]

p3 = Show[pp, Axes -> None]; Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 500]

Information["AxesEdge", LongForm -> False]

p1 = Show[pp, AxesEdge -> None]; , Null, p2 = Show[pp, AxesEdge -> {{1, 1}, {1, -1}, {1, 1}}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["AxesLabel", LongForm -> False]

z = "Sin(x, y)  "; , Null, p1 = Show[pp, AxesLabel -> {"x", "y", "z   "}]; , Null, p2 = Show[pp, AxesLabel -> {x, y, z}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["AxesOrigin", LongForm -> False]

Information["AxesStyle", LongForm -> False]

Show[pp, AxesStyle -> {{Thickness[0.01]}, {Thickness[0.015], Green}, {Thickness[0.02], Red}}, AxesLabel -> {"x", "y", "z"}]

Information["Background ", LongForm -> False]

p1 = Show[pp, Background -> GrayLevel[0.9]]; , Null, p2 = Show[pp, Background -> RGBColor[0, 1, 0]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 350]

Information["BaselinePosition", LongForm -> True]

{x, Graphics3D[Sphere[], BaselinePosition -> Center, BaselinePosition -> Center, ImageSize -> 70], y}

Information["BaseStyle", LongForm -> False]

p1 = Graphics3D[{Sphere[], Cylinder[{{3, 0, -1}, {3, 0, 1}}]}, Axes -> True]; , Null, p2 = Graphics3D[{Sphere[], Cylinder[{{3, 0, -1}, {3, 0, 1}}]}, Axes -> True, BaseStyle -> Orange]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 350]

Information["Boxed", LongForm -> False]

p1 = Show[pp, Boxed -> False]; , Null, p2 = Show[pp, Axes -> None, Boxed -> False]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["BoxRatios", LongForm -> False]

Show[pp, BoxRatios -> {1, 1.5, 0.6}]

curve = {Cos[t], Sin[t], t}; p1 = ParametricPlot3D[Evaluate[curve], {t, 0, 6*Pi}, ImageSize -> 100]; , Null, p2 = Show[p1, BoxRatios -> {1, 1, 3}, ImageSize -> 200]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["BoxStyle", LongForm -> False]

plc = Show[pp, BoxStyle -> {Thickness[0.02], RGBColor[1, 0, 0]}]

Information["ClippingStyle", LongForm -> False]

mm = 0.8^2; m1 = 1 - mm; , Null, cna = Abs[JacobiCN[x + I*y, mm]]; , Null, per = EllipticK[mm]; pep = EllipticK[m1]; , Null, plcn = Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}], Null, p2 = Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ClippingStyle -> None], Null, p3 = Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ClippingStyle -> Red]

Information["ColorFunctionScaling", LongForm -> False]

Information["ColorFunction", LongForm -> False]

p1 = Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ColorFunction -> Hue]; , Null, p2 = Plot3D[1 - (x^2 + y^2), {x, -1, 1}, {y, -1, 1}, ColorFunction -> (GrayLevel[#1^3] & )]; p3 = Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> (Hue[#1^(3/2)] & )]; Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 500]

p1 = Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> Hue]; , Null, p2 = Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> "Rainbow"]; , Null, p3 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, ColorFunction -> Function[{x, y, z}, Hue[z]]]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 500]

Information["ColorOutput ", LongForm -> False]

Information["Epilog", LongForm -> False]

Information["FaceGrids", LongForm -> False]

pp = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}]; , Null, p1 = Show[pp, FaceGrids -> All]; , Null, p2 = Show[pp, FaceGrids -> {{0, 0, 1}, {0, -1, 0}}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["FaceGridsStyle", LongForm -> True]

p1 = Graphics3D[Cylinder[], FaceGrids -> All, FaceGridsStyle -> Directive[Orange, Dashed]]; , Null, p2 = ParametricPlot3D[{v*Cos[u], v*Sin[u], v^3}, {u, 0, 2*Pi}, {v, -1, 1}, Mesh -> None, FaceGrids -> {{0, -1, 0}}, AxesLabel -> {"x", "y", "z"}, FaceGridsStyle -> Directive[Gray, Dotted]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["Filling                 (* Plot3D  only  *)", LongForm -> True]

Information["FillingStyle           (* Plot3D  only  *)", LongForm -> True]

p1 = Plot3D[Sin[x + y^2], {x, -2, 2}, {y, -2, 2}, RegionFunction -> (1 < #1^2 + #2^2 < 4 & ), Filling -> Bottom, FillingStyle -> Opacity[0.3], Mesh -> None]; , Null, p2 = Plot3D[Sin[x + y^2], {x, -2, 2}, {y, -2, 2}, RegionFunction -> (1 < #1^2 + #2^2 < 4 & ), Filling -> Bottom, FillingStyle -> Opacity[0.7]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

p1 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], ViewPoint -> {-2.281, -1.373, 0.5}]; , Null, p2 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, ViewPoint -> {-2.281, -1.373, 0.5}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

p1 = ParametricPlot3D[{Sin[t]*Sin[p], Sin[t]*Cos[p], Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}, PlotStyle -> FaceForm[]]; , Null, p2 = ParametricPlot3D[{Sin[t]*Sin[p], Sin[t]*Cos[p], Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

Information["Lighting", LongForm -> False]

Table[Graphics3D[{White, Sphere[]}, ImageSize -> 150, Lighting -> {{"Directional", c, {{0, 0, 1}, {0, 0, 0}}}}], {c, {Red, Orange, Blue}}]

Graphics3D[{Specularity[White, 50], Lighting -> {{"Point", Red, {0, 0, 5}}}, Sphere[], Lighting -> {{"Point", White, {3, 0, 5}}}, Sphere[{3, 0, 0}], Lighting -> {{"Point", Blue, {0, 3, 5}}}, Sphere[{0, 3, 0}], Lighting -> {{"Point", Yellow, {3, 3, 5}}}, Sphere[{3, 3, 0}]}]

Information["Mesh ", LongForm -> False]

p1 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, Mesh -> False]; , Null, p2 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, Mesh -> True]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["MeshStyle  ", LongForm -> False]

p1 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, MeshStyle -> Thickness[0.01]]; p2 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, MeshStyle -> {{Dashing[{0.02}], Red}}]; Show[GraphicsRow[{p1, p2}, Spacings -> {Scaled[0.3], Scaled[0]}], ImageSize -> 400]

p1 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], MeshStyle -> Hue[0.2]]; p2 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], MeshStyle -> Hue[0.7]]; Show[GraphicsRow[{p1, p2}]]

Information["PlotLabel", LongForm -> False]

Information["PlotPoints", LongForm -> False]

Null

z = Sin[x*y]; , Null, p1 = Plot3D[z, {x, 0, 3}, {y, 0, 3}, PlotPoints -> 5]; p2 = Plot3D[z, {x, 0, 3}, {y, 0, 3}, PlotPoints -> {5, 10}]; Show[GraphicsRow[{p1, p2}]]

a = 3 + Cos[u]; x = a*Cos[v]; y = a*Sin[v]; z = Sin[u]; p1 = ParametricPlot3D[{x, y, z}, {u, Pi, 2*Pi}, {v, 0, 2*Pi}]; a = 3 + Cos[u]; x = a*Cos[v]; y = a*Sin[v]; z = Sin[u]; p2 = ParametricPlot3D[{x, y, z}, {u, Pi, 2*Pi}, {v, 0, 2*Pi}, PlotPoints -> {7, 10}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Information["PlotRange", LongForm -> False]

p1 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotRange -> {-0.5, 0.5}]; p2 = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotRange -> {{1, 2}, {1, 2}, {-0.5, 1.5}}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["PlotRegion", LongForm -> False]

Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotRegion -> {{0.1, 0.9}, {0.3, 0.8}}]

Information["PlotStyle", LongForm -> False]

Information["Prolog", LongForm -> False]

Information["SphericalRegion", LongForm -> False]

pld = Show[pp, BoxRatios -> {1, 5, 1}]; ple = Show[pld, ViewPoint -> {7, 1, 2}]; Show[GraphicsRow[{pld, ple}], ImageSize -> 450]

p1 = Show[pld, SphericalRegion -> True]; p2 = Show[ple, SphericalRegion -> True]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["Ticks", LongForm -> False]

Information["TicksStyle", LongForm -> False]

Information["ViewCenter", LongForm -> False]

p1 = Framed[Graphics3D[Cylinder[], ViewCenter -> Automatic, SphericalRegion -> True]]; , Null, p2 = Framed[Graphics3D[Cylinder[], ViewCenter -> {1, 0.5, 1}, SphericalRegion -> True]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["ViewPoint", LongForm -> False]

pp = Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, DisplayFunction -> $DisplayFunction, ViewPoint -> {1.3, 1.8, 2}]

Show[pp]

Clear[x, y, z], Null, psa = Abs[SphericalHarmonicY[4, 2, th, ph]]; , Null, x = psa*Sin[th]*Cos[ph]; y = psa*Sin[th]*Sin[ph]; z = psa*Cos[th]; plwa = ParametricPlot3D[{x, y, z}, {th, 0, Pi}, {ph, 0, Pi}]; p2 = Show[plwa, ViewPoint -> {-1.509, -2.91, 0.18}]; Show[GraphicsRow[{plwa, p2}]]

Information["ContourPlot", LongForm -> True]

Information["DensityPlot", LongForm -> True]

Information["ContourLines", LongForm -> False]

Clear[x, y, r]; f[x_, y_, r_] = Abs[Exp[I*r*Cos[x + I*y]]]; 

p1 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ContourStyle -> Automatic]; p2 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ContourStyle -> None]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 350]

p1 = Plot3D[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ViewPoint -> {-0.03, -2.4, 2.}]; p2 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, Contours -> {0.055, 0.11, 0.33, 0.66, 0.9, 1, 1.33, 1.66, 2.}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Information["ContourShading", LongForm -> False]

p1 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False]; p2 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> True, ColorFunction -> Hue]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

cc[xx_] := Which[xx >= 1, Hue[0.35], xx > 0.5, Hue[0.7], True, Hue[0.03]], Null, p1 = ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, AspectRatio -> Automatic]; , Null, p2 = ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, ColorFunctionScaling -> True, ColorFunction -> (cc[2.5*#1] & ), AspectRatio -> Automatic]; , Null, p3 = ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, ColorFunction -> Hue, AspectRatio -> Automatic]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 500]

Information["ContourStyle", LongForm -> False]

p1 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False, ContourStyle -> {{Thickness[0.001]}, {Thickness[0.003]}, {Thickness[0.005]}, {Thickness[0.007]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}}]; p2 = ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False, ContourStyle -> {{Dashing[{}]}, {Dashing[{0.01}]}, {Dashing[{0.02}]}, {Dashing[{0.03}]}, {Dashing[{0.04}]}, {Dashing[{0.05}]}}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

Clear[fu, fx, fy, x, y]

fu = (-(1/2))*(x^2 + y^2) - μ/Sqrt[y^2 + (-1 + x + μ)^2] + (-1 + μ)/Sqrt[y^2 + (x + μ)^2]; 

fx = -D[fu, x]

fy = -D[fu, y]

sm = μ -> 1/4; , Null, son = RotateRight[NSolve[Thread[{fx, fy} == {0, 0}] /. sm, {x, y}], 1]

um = fu /. sm; , Null, vli = {x, y, um} /. son

pp = Plot3D[um, {x, -1.5, 1.5}, {y, -1, 1}, PlotPoints -> 40]; 

pv = Show[pp, Graphics3D[Point /@ vli], ImageSize -> 500, AxesLabel -> {"x", "y", "U(x,y)"}]; 

cp = ContourPlot[um, {x, -1.5, 1.5}, {y, -1.5, 1.5}, Contours -> 15, PlotPoints -> 100]; 

pm = {Point[{-μ, 0}], Point[{1 - μ, 0}]} /. sm; , Null, pe = Point[{x, y}] /. son; , Null, su = 0.15; , Null, pms = {{-μ, su}, {1 - μ, su}} /. sm; , Null, tm = {Text[Subscript["μ", 1], pms[[1]]], Text[Subscript["μ", 2], pms[[2]]]} /. sm; 

pc = Show[cp, Epilog -> {pe, Red, pm, tm}, ImageSize -> 500]; 

Show[GraphicsRow[{pv, pc}], ImageSize -> 500]

lp = ListPlot[Table[Prime[n], {n, 20}], ImageSize -> 250]

InputForm[lp]

lp[[1]]

lp[[2]]

rp = ReplacePart[lp[[1]], Red, 1]

p1 = Show[Graphics[{PointSize -> 0.02, rp}], AspectRatio -> 0.6]; , Null, p2 = Show[Graphics[{PointSize -> 0.02, lp[[1]]}, lp[[2]]], AspectRatio -> 0.6]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 450]

Information["Graphics", LongForm -> True]

Information["Point", LongForm -> False]

Information["Line", LongForm -> False]

Information["Circle", LongForm -> False]

Information["Disk", LongForm -> False]

Information["Text", LongForm -> False]

Information["Arrow", LongForm -> False]

Information["Grid", LongForm -> True]

Information["Framed", LongForm -> False]

li = {{0, 0}, {1, 1}, {1.5, 5.2}, {2, 1.4}, {1, -1.5}}; ListPlot[li, Prolog -> PointSize[0.015], ImageSize -> 200]

pt = Table[Graphics[Point[li[[k]]]], {k, Length[li]}]; 

as = 0.6; , Null, p1 = Show[pt, AspectRatio -> as]; , Null, p2 = Show[pt, Axes -> True, AspectRatio -> as]; Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

Show[Graphics[{Thickness[0.02], Line[li]}], Axes -> True, AspectRatio -> 0.7]

p1 = Show[pt, Prolog -> PointSize[0.015], AspectRatio -> as]; , Null, p2 = Show[pt, Graphics[Line[li]], Prolog -> PointSize[0.015], AspectRatio -> as]; Show[GraphicsRow[{p1, p2}], Prolog -> PointSize[0.02], ImageSize -> 400]

c1 = Circle[{0, 0}, 2, {0, (3*Pi)/4}]; p1 = Show[Graphics[c1], AspectRatio -> Automatic]; , Null, c2 = Circle[{0, 0}, {2, 3}, {0, (3*Pi)/4}]; p2 = Show[Graphics[c2], AspectRatio -> Automatic]; Show[GraphicsRow[{p1, p2}]]

p1 = Graphics[{Point[{1, 0.3}], Circle[{1, 0.3}, 1], Text[Style[x^2 + y^2 == 1, 15], {1, 1}]}, Axes -> True, ImageSize -> 200]

la = {{-1, 0}, {2, 0}, {3.5, 3.5}, {1.5, 2.5}, {-2, 4}, {-1, 0}}; ListPlot[la, Joined -> True, PlotStyle -> Thickness[0.01], AxesLabel -> {"u", "v"}, Epilog -> {Text["a1", {-0.7, 0.3}], Text["a2", {1.8, 0.3}], Text["a3", {2.7, 2.7}], Text["a4", {1.5, 2.2}], Text["a5", {-1.6, 3.4}]}]

p1 = Graphics[{Blue, Circle[{0, 0}], Red, Arrow[{{2, 1}, {1, 0}}]}]; , Null, p2 = Graphics[{Green, Thickness[0.02], Circle[{0, 0}], Red, Arrow[{{2, 1}, {1, 0}}, 0.2]}]; , Null, GraphicsRow[{p1, p2}]

p1 = Graphics[{RGBColor[0, 1, 0], Disk[{0, 0}, 2]}, ImageSize -> 150]; p2 = Graphics[{RGBColor[0, 0, 1], Disk[{1, 1}, 2]}, ImageSize -> 150]; , Null, p3 = Show[p1, p2, AspectRatio -> Automatic]; p4 = Show[p2, p1, AspectRatio -> Automatic]; GraphicsRow[{p3, p4}]

p1 = Grid[{{Graphics[Disk[], ImageSize -> 30, BaselinePosition -> Bottom], abc}, {ead, Graphics[Rectangle[], ImageSize -> 30, BaselinePosition -> Top]}}, Frame -> All]; , Null, p2 = Framed[p1]; , Null, GraphicsRow[{p1, p2}]

p1 = Grid[Table[x, {3}, {3}], Frame -> All, Spacings -> 2]; , Null, p2 = Grid[Table[x, {3}, {3}], Frame -> All, Spacings -> {2, 0}]; , Null, GraphicsRow[{p1, p2}]

Arrow

p1 = Graphics[Arrow[{{1, 2}, {2, 3}}], Axes -> True]; , Null, p2 = Graphics[Arrow[{{1, 2}, {1.5, 2.2}, {1.3, 2.7}, {2, 3}}], Axes -> True]; , Null, GraphicsRow[{p1, p2}, Spacings -> {100, 0}]

Information["Arrowheads", LongForm -> False]

p1 = Graphics[{Arrowheads[0.1], Arrow[{{1.1, 2.1}, {2, 3}}]}, Axes -> True, PlotRange -> {{1, 2}, {2, 3}}]; , Null, p2 = Graphics[{Arrowheads[{-0.1, 0.1}], Arrow[{{1.1, 2.1}, {2, 3}}]}, Axes -> True, PlotRange -> {{1, 2}, {2, 3}}]; , Null, GraphicsRow[{p1, p2}, Spacings -> {100, 0}]

a = {Arrowheads[Large], Arrow[{{0, 0}, {1, 0.5}}]}; 

{Graphics[{Dashed, a}], Graphics[{Red, a}], Graphics[{Thick, a}], Graphics[{Thick, Dashed, Red, a}]}

Plot[Sin[x], {x, 0, 2*Pi}, Ticks -> {Pi*{1/2, 1, 3/2, 2}, Range[-1, 1, 0.5]}, Epilog -> {Arrow[{{3*(Pi/2), 1/2}, {Pi, 0}}], Text["Zero", {3*(Pi/2), 1/2}, {-1, -1}]}]

pl = Plot[x^3 + 2*x^2 - 4*x, {x, -4, 3}, AxesLabel -> {"x", "y"}]

Show[pl, Graphics[{Arrow[{{3.15, 0.12}, {3.32, 0.12}}], Arrow[{{0, 26}, {0, 28}}]}], PlotRange -> {{-4, 3.13}, {-15, 27}}, Ticks -> {Range[-4, 3, 0.5], Range[-30, 30, 5]}, ImageSize -> 400]

Show[pl, Epilog -> {Arrow[{{3.15, 0.12}, {3.32, 0.12}}], Arrow[{{0, 26}, {0, 28}}]}, PlotRange -> {{-4, 3.13}, {-15, 27}}, Ticks -> {Range[-4, 3, 0.5], Range[-30, 30, 5]}, ImageSize -> 600]; 

Show[pl, Graphics[{Arrowheads[0.028], Arrow[{{3.1, 0.12}, {3.3, 0.12}}], Arrow[{{0, 26}, {0, 28}}]}], PlotRange -> {{-4, 3.13}, {-15, 27}}, Ticks -> {Range[-4, 3, 0.5], Range[-30, 30, 5]}, ImageSize -> 400]

Plot[x^3 + 2*x^2 - 4*x, {x, -4, 3}, AxesLabel -> {"x", "y"}, PlotRange -> {{-4, 3.125}, {-15, 27}}, Ticks -> {Range[-4, 3, 0.5], Range[-30, 30, 5]}, Epilog -> {Black, Thickness[0.0025], Line[{{3.05, 1}, {3.13, 0}, {3.05, -1}}], Line[{{0.1, 26}, {0, 27}, {-0.1, 26}}]}]

Information["Graphics3D", LongForm -> True]

Information["Point", LongForm -> False]

Information["Line", LongForm -> False]

Information["Text", LongForm -> False]

Information["Framed", LongForm -> False]

Information["Arrow", LongForm -> False]

Information["Cylinder", LongForm -> False]

Information["Sphere", LongForm -> False]

Information["Cuboid", LongForm -> False]

Information["Tube", LongForm -> False]

l3 = {{0, 0, 0}, {1, 1, 1}, {1.5, 3.2, 3}, {2, 1.4, 2.5}, {1, -1.5, -1}}; , Null, p1 = Show[Graphics3D[Line[l3]]]; , Null, p2 = Show[Graphics3D[{Thickness[0.03], Line[l3]}]]; , Null, l4 = Table[Graphics3D[{PointSize[0.04], Point[l3[[k]]]}], {k, Length[l3]}]; , Null, p3 = Show[l4, Axes -> True]; Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 400]

a = 4; z0 = 5; b[1] = {0, 0, 0}; b[2] = {a, 0, 0}; b[3] = {a, a, 0}; b[4] = {0, a, 0}; , Null, x0 = a/2; e = {x0, x0, z0}; bx = {x0, x0, 0}; , Null, lp1 = {Thickness[0.02], Line[{b[2], b[3], e, b[1], e, b[2], b[1]}]}; , Null, lp2 = {Thickness[0.012], Line[{b[1], b[4]}], Line[{b[4], b[3]}], Line[{e, b[4]}]}; , Null, lp3 = {Line[{b[1], b[3]}], Line[{b[4], b[2], bx, e}]}; Show[Graphics3D[lp1], Graphics3D[lp2], Graphics3D[lp3], Boxed -> False, ImageSize -> 200]

p1 = ParametricPlot3D[{Sin[8*u]*Sin[u], Cos[8*u]*Sin[u], Cos[u]}, {u, 0, 2*Pi}, PlotPoints -> 200]; 

p2 = Show[Graphics3D[{Thickness[0.015], First[p1]}]]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

Graphics3D[{Yellow, Cuboid[{0, 0, 0}], Blue, Cuboid[{0.5, 0.5, 0.5}]}, ImageSize -> 150]

Graphics3D[{Yellow, Sphere[{0, 0, 0}], Blue, Cylinder[{{0.5, 0.25, 0.36}, {1, 1, 1}}]}, ImageSize -> 150]

Graphics3D[Tube[{{0, 0, 0}, {1, 1, 1}}, 0.1], ImageSize -> 200]

p1 = Graphics3D[Arrow[{{1, 1, -1}, {2, 2, 0}, {3, 3, -1}, {4, 4, 0}}], Axes -> True]; , Null, p2 = Graphics3D[Arrow[Tube[{{1, 1, -1}, {2, 2, 0}, {3, 3, -1}, {4, 4, 0}}, 0.1]]]; , Null, GraphicsRow[{p1, p2}, Spacings -> 100]

a = {Arrowheads[Large], Arrow[{{0, 0, 0}, {2, 1, 1}}]}; , Null, {Graphics3D[{Dashed, a}, ImageSize -> 100], Graphics3D[{Red, a}, ImageSize -> 100], Graphics3D[{Thick, a}, ImageSize -> 100], Graphics3D[{Thick, Dashed, Red, a}, ImageSize -> 100]}

pl = Show[Plot3D[Sin[x]*Sin[y], {x, 0, 2*Pi}, {y, 0, 2*Pi}, PlotRange -> {-1, 4}, BoxRatios -> Automatic, AxesLabel -> {"x", "y", "z"}], Graphics3D[{Arrow[{{Pi, Pi, 4}, {Pi/2, Pi/2, 1}}], Arrow[{{Pi, Pi, 4}, {3*(Pi/2), 3*(Pi/2), 1}}], Text[Panel["Maxima", FrameMargins -> 0], {Pi, Pi, 4}]}]]

aa = Graphics3D[{Arrowheads[0.025], Arrow[{{5.8, 0, -1.}, {6.4, 0, -1.}}], Arrow[{{0, 0, 3.6}, {0, 0, 4.2}}], Arrow[{{0, 5.4, 4}, {0, 6., 4}}]}]; , Null, p1 = Show[pl, aa, PlotRange -> All], Null, p2 = Show[pl, aa, Boxed -> False, PlotRange -> All];
