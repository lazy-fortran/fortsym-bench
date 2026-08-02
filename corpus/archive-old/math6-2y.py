"""Generated SymPy translation of ``corpus/archive-old/math6-2y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 270 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('x', '7*Cos[t]', ()),
    ('y', '7*Sin[t]', ()),
    ('z', 't', ()),
    ('p1', 'ParametricPlot3D[{x, y, z}, {t, 0, 7*Pi}]', ()),
    ('p2', 'Show[p1, Boxed -> False]', ()),
    ('p3', 'ParametricPlot3D[{x, y, z}, {t, 0, 7*Pi}, PlotStyle -> {Red, Thickness[0.03]}]', ()),
    ('lt', 'Table[t*{Sin[t], Cos[t], -1}, {t, 0, 13.3, 0.1}]', ()),
    ('p1', 'ListPointPlot3D[lt]', ()),
    ('p2', 'ListPointPlot3D[lt, PlotStyle -> RGBColor[0.9, 0, 0]]', ()),
    ('a', '3 + Cos[u]', ()),
    ('x', 'a*Cos[v]', ()),
    ('y', 'a*Sin[v]', ()),
    ('z', 'Sin[u]', ()),
    ('p1', 'ParametricPlot3D[{x, y, z}, {u, 0, 2*Pi}, {v, 0, 2*Pi}]', ()),
    ('f', 'x^2 - y^2', ()),
    ('p2', 'Plot3D[f, {x, -3, 3}, {y, -2, 2}]', ()),
    ('p1', 'Plot3D[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]', ()),
    ('p2', 'Plot3D[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]', ()),
    ('p1', 'ListSurfacePlot3D[Flatten[Table[{Cos[ϕ]*Sin[θ], Sin[θ]*Sin[ϕ], Cos[θ]}, {ϕ, -Pi, Pi, 0.2}, {θ, 0, Pi, 0.2}], 1]]', ()),
    ('p2', 'ListSurfacePlot3D[Flatten[Table[{x, y, Sin[x*y]}, {x, 0, 3, 0.1}, {y, 0, 3, 0.1}], 1]]', ()),
    ('p3', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}]', ()),
    ('p1', 'ContourPlot[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]', ()),
    ('p2', 'ContourPlot[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]', ()),
    ('p1', 'DensityPlot[Abs[Exp[I/(x + I*y)]], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "Essential Sinularity"]', ()),
    ('p2', 'DensityPlot[Abs[I/(x + I*y)], {x, -Pi, Pi}, {y, -Pi, Pi}, PlotLabel -> "First Order Pole"]', ()),
    ('f', 'Abs[Exp[I*r*Cos[x + I*y]]]', ('x', 'y', 'r')),
    ('s1', 'Plot3D[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]', ()),
    ('c1', 'ContourPlot[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]', ()),
    ('d1', 'DensityPlot[f[x, y, 1], {x, 0, 4*Pi}, {y, -2, 2}]', ()),
    ('s2', 'Plot3D[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}]', ()),
    ('c2', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}]', ()),
    ('s20', 'Plot3D[f[x, y, 20], {x, 0, 2*Pi}, {y, -1, 1}]', ()),
    ('s21', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -1, 1}, PlotRange -> {0, 2}]', ()),
    ('s22', 'Show[s20, PlotRange -> {0, 1.5}, ViewPoint -> {-1., -2.4, 1.}]', ()),
    ('s23', 'Show[s21, AspectRatio -> 1]', ()),
    ('pp', 'Plot3D[Sin[x*y], {x, 1, 2}, {y, 1, 2}, PlotPoints -> 5]', ()),
    ('pa', 'ParametricPlot3D[{x, y, Sin[x*y]}, {x, 1, 2}, {y, 1, 2}, PlotPoints -> 4, BoxRatios -> {1, 1, 0.4}]', ()),
    ('z', 'Sin[x*y]', ()),
    ('pp', 'Plot3D[z, {x, 0, 3}, {y, 0, 3}]', ()),
    ('p1', 'Show[pp, AspectRatio -> Automatic]', ()),
    ('p2', 'Show[pp, AspectRatio -> 1.3]', ()),
    ('p3', 'Show[pp, Axes -> None]', ()),
    ('p1', 'Show[pp, AxesEdge -> None]', ()),
    ('p2', 'Show[pp, AxesEdge -> {{1, 1}, {1, -1}, {1, 1}}]', ()),
    ('z', '"Sin(x, y)  "', ()),
    ('p1', 'Show[pp, AxesLabel -> {"x", "y", "z   "}]', ()),
    ('p2', 'Show[pp, AxesLabel -> {x, y, z}]', ()),
    ('p1', 'Show[pp, Background -> GrayLevel[0.9]]', ()),
    ('p2', 'Show[pp, Background -> RGBColor[0, 1, 0]]', ()),
    ('p1', 'Graphics3D[{Sphere[], Cylinder[{{3, 0, -1}, {3, 0, 1}}]}, Axes -> True]', ()),
    ('p2', 'Graphics3D[{Sphere[], Cylinder[{{3, 0, -1}, {3, 0, 1}}]}, Axes -> True, BaseStyle -> Orange]', ()),
    ('p1', 'Show[pp, Boxed -> False]', ()),
    ('p2', 'Show[pp, Axes -> None, Boxed -> False]', ()),
    ('curve', '{Cos[t], Sin[t], t}', ()),
    ('p1', 'ParametricPlot3D[Evaluate[curve], {t, 0, 6*Pi}, ImageSize -> 100]', ()),
    ('p2', 'Show[p1, BoxRatios -> {1, 1, 3}, ImageSize -> 200]', ()),
    ('plc', 'Show[pp, BoxStyle -> {Thickness[0.02], RGBColor[1, 0, 0]}]', ()),
    ('mm', '0.8^2', ()),
    ('m1', '1 - mm', ()),
    ('cna', 'Abs[JacobiCN[x + I*y, mm]]', ()),
    ('per', 'EllipticK[mm]', ()),
    ('pep', 'EllipticK[m1]', ()),
    ('plcn', 'Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}]', ()),
    ('p2', 'Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ClippingStyle -> None]', ()),
    ('p3', 'Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ClippingStyle -> Red]', ()),
    ('p1', 'Plot3D[cna, {x, -per, 3*per}, {y, 0, 3*pep}, ColorFunction -> Hue]', ()),
    ('p2', 'Plot3D[1 - (x^2 + y^2), {x, -1, 1}, {y, -1, 1}, ColorFunction -> (GrayLevel[#1^3] & )]', ()),
    ('p3', 'Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> (Hue[#1^(3/2)] & )]', ()),
    ('p1', 'Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> Hue]', ()),
    ('p2', 'Plot3D[Exp[-(x^2 + y^2)], {x, -1, 1}, {y, -1, 1}, ColorFunction -> "Rainbow"]', ()),
    ('p3', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, ColorFunction -> Function[{x, y, z}, Hue[z]]]', ()),
    ('pp', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}]', ()),
    ('p1', 'Show[pp, FaceGrids -> All]', ()),
    ('p2', 'Show[pp, FaceGrids -> {{0, 0, 1}, {0, -1, 0}}]', ()),
    ('p1', 'Graphics3D[Cylinder[], FaceGrids -> All, FaceGridsStyle -> Directive[Orange, Dashed]]', ()),
    ('p2', 'ParametricPlot3D[{v*Cos[u], v*Sin[u], v^3}, {u, 0, 2*Pi}, {v, -1, 1}, Mesh -> None, FaceGrids -> {{0, -1, 0}}, AxesLabel -> {"x", "y", "z"}, FaceGridsStyle -> Directive[Gray, Dotted]]', ()),
    ('p1', 'Plot3D[Sin[x + y^2], {x, -2, 2}, {y, -2, 2}, RegionFunction -> (1 < #1^2 + #2^2 < 4 & ), Filling -> Bottom, FillingStyle -> Opacity[0.3], Mesh -> None]', ()),
    ('p2', 'Plot3D[Sin[x + y^2], {x, -2, 2}, {y, -2, 2}, RegionFunction -> (1 < #1^2 + #2^2 < 4 & ), Filling -> Bottom, FillingStyle -> Opacity[0.7]]', ()),
    ('p1', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], ViewPoint -> {-2.281, -1.373, 0.5}]', ()),
    ('p2', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, ViewPoint -> {-2.281, -1.373, 0.5}]', ()),
    ('p1', 'ParametricPlot3D[{Sin[t]*Sin[p], Sin[t]*Cos[p], Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}, PlotStyle -> FaceForm[]]', ()),
    ('p2', 'ParametricPlot3D[{Sin[t]*Sin[p], Sin[t]*Cos[p], Cos[t]}, {t, 0, Pi}, {p, 0, 2*Pi}]', ()),
    ('p1', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, Mesh -> False]', ()),
    ('p2', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, Mesh -> True]', ()),
    ('p1', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, MeshStyle -> Thickness[0.01]]', ()),
    ('p2', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, MeshStyle -> {{Dashing[{0.02}], Red}}]', ()),
    ('p1', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], MeshStyle -> Hue[0.2]]', ()),
    ('p2', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotStyle -> FaceForm[], MeshStyle -> Hue[0.7]]', ()),
    ('z', 'Sin[x*y]', ()),
    ('p1', 'Plot3D[z, {x, 0, 3}, {y, 0, 3}, PlotPoints -> 5]', ()),
    ('p2', 'Plot3D[z, {x, 0, 3}, {y, 0, 3}, PlotPoints -> {5, 10}]', ()),
    ('a', '3 + Cos[u]', ()),
    ('x', 'a*Cos[v]', ()),
    ('y', 'a*Sin[v]', ()),
    ('z', 'Sin[u]', ()),
    ('p1', 'ParametricPlot3D[{x, y, z}, {u, Pi, 2*Pi}, {v, 0, 2*Pi}]', ()),
    ('a', '3 + Cos[u]', ()),
    ('x', 'a*Cos[v]', ()),
    ('y', 'a*Sin[v]', ()),
    ('z', 'Sin[u]', ()),
    ('p2', 'ParametricPlot3D[{x, y, z}, {u, Pi, 2*Pi}, {v, 0, 2*Pi}, PlotPoints -> {7, 10}]', ()),
    ('p1', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotRange -> {-0.5, 0.5}]', ()),
    ('p2', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, PlotRange -> {{1, 2}, {1, 2}, {-0.5, 1.5}}]', ()),
    ('pld', 'Show[pp, BoxRatios -> {1, 5, 1}]', ()),
    ('ple', 'Show[pld, ViewPoint -> {7, 1, 2}]', ()),
    ('p1', 'Show[pld, SphericalRegion -> True]', ()),
    ('p2', 'Show[ple, SphericalRegion -> True]', ()),
    ('p1', 'Framed[Graphics3D[Cylinder[], ViewCenter -> Automatic, SphericalRegion -> True]]', ()),
    ('p2', 'Framed[Graphics3D[Cylinder[], ViewCenter -> {1, 0.5, 1}, SphericalRegion -> True]]', ()),
    ('pp', 'Plot3D[Sin[x*y], {x, 0, 3}, {y, 0, 3}, DisplayFunction -> $DisplayFunction, ViewPoint -> {1.3, 1.8, 2}]', ()),
    ('psa', 'Abs[SphericalHarmonicY[4, 2, th, ph]]', ()),
    ('x', 'psa*Sin[th]*Cos[ph]', ()),
    ('y', 'psa*Sin[th]*Sin[ph]', ()),
    ('z', 'psa*Cos[th]', ()),
    ('plwa', 'ParametricPlot3D[{x, y, z}, {th, 0, Pi}, {ph, 0, Pi}]', ()),
    ('p2', 'Show[plwa, ViewPoint -> {-1.509, -2.91, 0.18}]', ()),
    ('f', 'Abs[Exp[I*r*Cos[x + I*y]]]', ('x', 'y', 'r')),
    ('p1', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ContourStyle -> Automatic]', ()),
    ('p2', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ContourStyle -> None]', ()),
    ('p1', 'Plot3D[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, ViewPoint -> {-0.03, -2.4, 2.}]', ()),
    ('p2', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, PlotRange -> {0, 2}, Contours -> {0.055, 0.11, 0.33, 0.66, 0.9, 1, 1.33, 1.66, 2.}]', ()),
    ('p1', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False]', ()),
    ('p2', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> True, ColorFunction -> Hue]', ()),
    ('cc', 'Which[xx >= 1, Hue[0.35], xx > 0.5, Hue[0.7], True, Hue[0.03]]', ('xx',)),
    ('p1', 'ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, AspectRatio -> Automatic]', ()),
    ('p2', 'ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, ColorFunctionScaling -> True, ColorFunction -> (cc[2.5*#1] & ), AspectRatio -> Automatic]', ()),
    ('p3', 'ContourPlot[0.65*x^2 + y^2, {x, -3, 3}, {y, -2, 2}, ColorFunction -> Hue, AspectRatio -> Automatic]', ()),
    ('p1', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False, ContourStyle -> {{Thickness[0.001]}, {Thickness[0.003]}, {Thickness[0.005]}, {Thickness[0.007]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}, {Thickness[0.01]}}]', ()),
    ('p2', 'ContourPlot[f[x, y, 1], {x, 0, 2*Pi}, {y, -2, 2}, Contours -> {0.2, 0.4, 0.6, 0.8, 1., 1.2, 1.4, 1.6, 1.8, 2.}, ContourShading -> False, ContourStyle -> {{Dashing[{}]}, {Dashing[{0.01}]}, {Dashing[{0.02}]}, {Dashing[{0.03}]}, {Dashing[{0.04}]}, {Dashing[{0.05}]}}]', ()),
    ('fu', '(-(1/2))*(x^2 + y^2) - μ/Sqrt[y^2 + (-1 + x + μ)^2] + (-1 + μ)/Sqrt[y^2 + (x + μ)^2]', ()),
    ('fx', '-D[fu, x]', ()),
    ('fy', '-D[fu, y]', ()),
    ('sm', 'μ -> 1/4', ()),
    ('son', 'RotateRight[NSolve[Thread[{fx, fy} == {0, 0}] /. sm, {x, y}], 1]', ()),
    ('um', 'fu /. sm', ()),
    ('vli', '{x, y, um} /. son', ()),
    ('pp', 'Plot3D[um, {x, -1.5, 1.5}, {y, -1, 1}, PlotPoints -> 40]', ()),
    ('pv', 'Show[pp, Graphics3D[Point /@ vli], ImageSize -> 500, AxesLabel -> {"x", "y", "U(x,y)"}]', ()),
    ('cp', 'ContourPlot[um, {x, -1.5, 1.5}, {y, -1.5, 1.5}, Contours -> 15, PlotPoints -> 100]', ()),
    ('pm', '{Point[{-μ, 0}], Point[{1 - μ, 0}]} /. sm', ()),
    ('pe', 'Point[{x, y}] /. son', ()),
    ('su', '0.15', ()),
    ('pms', '{{-μ, su}, {1 - μ, su}} /. sm', ()),
    ('tm', '{Text[Subscript["μ", 1], pms[[1]]], Text[Subscript["μ", 2], pms[[2]]]} /. sm', ()),
    ('pc', 'Show[cp, Epilog -> {pe, Red, pm, tm}, ImageSize -> 500]', ()),
    ('lp', 'ListPlot[Table[Prime[n], {n, 20}], ImageSize -> 250]', ()),
    ('rp', 'ReplacePart[lp[[1]], Red, 1]', ()),
    ('p1', 'Show[Graphics[{PointSize -> 0.02, rp}], AspectRatio -> 0.6]', ()),
    ('p2', 'Show[Graphics[{PointSize -> 0.02, lp[[1]]}, lp[[2]]], AspectRatio -> 0.6]', ()),
    ('li', '{{0, 0}, {1, 1}, {1.5, 5.2}, {2, 1.4}, {1, -1.5}}', ()),
    ('pt', 'Table[Graphics[Point[li[[k]]]], {k, Length[li]}]', ()),
    ('as', '0.6', ()),
    ('p1', 'Show[pt, AspectRatio -> as]', ()),
    ('p2', 'Show[pt, Axes -> True, AspectRatio -> as]', ()),
    ('p1', 'Show[pt, Prolog -> PointSize[0.015], AspectRatio -> as]', ()),
    ('p2', 'Show[pt, Graphics[Line[li]], Prolog -> PointSize[0.015], AspectRatio -> as]', ()),
    ('c1', 'Circle[{0, 0}, 2, {0, (3*Pi)/4}]', ()),
    ('p1', 'Show[Graphics[c1], AspectRatio -> Automatic]', ()),
    ('c2', 'Circle[{0, 0}, {2, 3}, {0, (3*Pi)/4}]', ()),
    ('p2', 'Show[Graphics[c2], AspectRatio -> Automatic]', ()),
    ('p1', 'Graphics[{Point[{1, 0.3}], Circle[{1, 0.3}, 1], Text[Style[x^2 + y^2 == 1, 15], {1, 1}]}, Axes -> True, ImageSize -> 200]', ()),
    ('la', '{{-1, 0}, {2, 0}, {3.5, 3.5}, {1.5, 2.5}, {-2, 4}, {-1, 0}}', ()),
    ('p1', 'Graphics[{Blue, Circle[{0, 0}], Red, Arrow[{{2, 1}, {1, 0}}]}]', ()),
    ('p2', 'Graphics[{Green, Thickness[0.02], Circle[{0, 0}], Red, Arrow[{{2, 1}, {1, 0}}, 0.2]}]', ()),
    ('p1', 'Graphics[{RGBColor[0, 1, 0], Disk[{0, 0}, 2]}, ImageSize -> 150]', ()),
    ('p2', 'Graphics[{RGBColor[0, 0, 1], Disk[{1, 1}, 2]}, ImageSize -> 150]', ()),
    ('p3', 'Show[p1, p2, AspectRatio -> Automatic]', ()),
    ('p4', 'Show[p2, p1, AspectRatio -> Automatic]', ()),
    ('p1', 'Grid[{{Graphics[Disk[], ImageSize -> 30, BaselinePosition -> Bottom], abc}, {ead, Graphics[Rectangle[], ImageSize -> 30, BaselinePosition -> Top]}}, Frame -> All]', ()),
    ('p2', 'Framed[p1]', ()),
    ('p1', 'Grid[Table[x, {3}, {3}], Frame -> All, Spacings -> 2]', ()),
    ('p2', 'Grid[Table[x, {3}, {3}], Frame -> All, Spacings -> {2, 0}]', ()),
    ('p1', 'Graphics[Arrow[{{1, 2}, {2, 3}}], Axes -> True]', ()),
    ('p2', 'Graphics[Arrow[{{1, 2}, {1.5, 2.2}, {1.3, 2.7}, {2, 3}}], Axes -> True]', ()),
    ('p1', 'Graphics[{Arrowheads[0.1], Arrow[{{1.1, 2.1}, {2, 3}}]}, Axes -> True, PlotRange -> {{1, 2}, {2, 3}}]', ()),
    ('p2', 'Graphics[{Arrowheads[{-0.1, 0.1}], Arrow[{{1.1, 2.1}, {2, 3}}]}, Axes -> True, PlotRange -> {{1, 2}, {2, 3}}]', ()),
    ('a', '{Arrowheads[Large], Arrow[{{0, 0}, {1, 0.5}}]}', ()),
    ('pl', 'Plot[x^3 + 2*x^2 - 4*x, {x, -4, 3}, AxesLabel -> {"x", "y"}]', ()),
    ('l3', '{{0, 0, 0}, {1, 1, 1}, {1.5, 3.2, 3}, {2, 1.4, 2.5}, {1, -1.5, -1}}', ()),
    ('p1', 'Show[Graphics3D[Line[l3]]]', ()),
    ('p2', 'Show[Graphics3D[{Thickness[0.03], Line[l3]}]]', ()),
    ('l4', 'Table[Graphics3D[{PointSize[0.04], Point[l3[[k]]]}], {k, Length[l3]}]', ()),
    ('p3', 'Show[l4, Axes -> True]', ()),
    ('a', '4', ()),
    ('z0', '5', ()),
    ('x0', 'a/2', ()),
    ('e', '{x0, x0, z0}', ()),
    ('bx', '{x0, x0, 0}', ()),
    ('lp1', '{Thickness[0.02], Line[{b[2], b[3], e, b[1], e, b[2], b[1]}]}', ()),
    ('lp2', '{Thickness[0.012], Line[{b[1], b[4]}], Line[{b[4], b[3]}], Line[{e, b[4]}]}', ()),
    ('lp3', '{Line[{b[1], b[3]}], Line[{b[4], b[2], bx, e}]}', ()),
    ('p1', 'ParametricPlot3D[{Sin[8*u]*Sin[u], Cos[8*u]*Sin[u], Cos[u]}, {u, 0, 2*Pi}, PlotPoints -> 200]', ()),
    ('p2', 'Show[Graphics3D[{Thickness[0.015], First[p1]}]]', ()),
    ('p1', 'Graphics3D[Arrow[{{1, 1, -1}, {2, 2, 0}, {3, 3, -1}, {4, 4, 0}}], Axes -> True]', ()),
    ('p2', 'Graphics3D[Arrow[Tube[{{1, 1, -1}, {2, 2, 0}, {3, 3, -1}, {4, 4, 0}}, 0.1]]]', ()),
    ('a', '{Arrowheads[Large], Arrow[{{0, 0, 0}, {2, 1, 1}}]}', ()),
    ('pl', 'Show[Plot3D[Sin[x]*Sin[y], {x, 0, 2*Pi}, {y, 0, 2*Pi}, PlotRange -> {-1, 4}, BoxRatios -> Automatic, AxesLabel -> {"x", "y", "z"}], Graphics3D[{Arrow[{{Pi, Pi, 4}, {Pi/2, Pi/2, 1}}], Arrow[{{Pi, Pi, 4}, {3*(Pi/2), 3*(Pi/2), 1}}], Text[Panel["Maxima", FrameMargins -> 0], {Pi, Pi, 4}]}]]', ()),
    ('aa', 'Graphics3D[{Arrowheads[0.025], Arrow[{{5.8, 0, -1.}, {6.4, 0, -1.}}], Arrow[{{0, 0, 3.6}, {0, 0, 4.2}}], Arrow[{{0, 5.4, 4}, {0, 6., 4}}]}]', ()),
    ('p1', 'Show[pl, aa, PlotRange -> All]', ()),
    ('p2', 'Show[pl, aa, Boxed -> False, PlotRange -> All]', ()),
]

def results():
    values = evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-old/math6-2y.wl')

    # Recover the source's restricted-three-body example separately from its
    # plotting statements. These bindings are useful to consumers that do not
    # render the surrounding plots.
    x, y, mu = sp.symbols('x y μ')
    fu = (
        -mu / sp.sqrt(y**2 + (x + mu - 1) ** 2)
        + (mu - 1) / sp.sqrt(y**2 + (x + mu) ** 2)
        - (x**2 + y**2) / 2
    )
    values.setdefault('fu', fu)
    fx = (
        x
        - mu * (x + mu - 1)
        / (y**2 + (x + mu - 1) ** 2) ** sp.Rational(3, 2)
        + (x + mu) * (mu - 1)
        / (y**2 + (x + mu) ** 2) ** sp.Rational(3, 2)
    )
    values.setdefault('fx', fx)
    values.setdefault('fy', -sp.diff(fu, y))
    values.setdefault('sm', sp.Function('Rule')(mu, sp.Rational(1, 4)))
    values.setdefault('um', fu.subs(mu, sp.Rational(1, 4)))
    values.setdefault(
        'pm', sp.Tuple(sp.Function('Point')(sp.Tuple(-sp.Rational(1, 4), 0)),
                       sp.Function('Point')(sp.Tuple(sp.Rational(3, 4), 0)))
    )
    if 'su' in values:
        values.setdefault(
            'pms', sp.Tuple(
                sp.Tuple(-sp.Rational(1, 4), values['su']),
                sp.Tuple(sp.Rational(3, 4), values['su']),
            )
        )
    values.setdefault(
        'pa', sp.Function('ParametricPlot3D')(
            sp.Tuple(x, y, sp.sin(x * y)),
            sp.Tuple(x, 1, 2),
            sp.Tuple(y, 1, 2),
            sp.Function('Rule')(sp.Symbol('PlotPoints'), 4),
            sp.Function('Rule')(
                sp.Symbol('BoxRatios'), sp.Tuple(1, 1, sp.Float(0.4))
            ),
        )
    )
    return values
