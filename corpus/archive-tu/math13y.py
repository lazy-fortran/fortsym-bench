"""Generated SymPy translation of ``corpus/archive-tu/math13y.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 192 non-assignment statement(s) remain.
COMPARE = {
    'test': 'numeric',
}
_ASSIGNMENTS = [
    ('p1', 'Plot[Floor[x], {x, -3, 3}, AxesLabel -> {"x", "Floor[x]"}]', ()),
    ('p2', 'Plot[Ceiling[x], {x, -3, 3}, AxesLabel -> {"x", "Ceiling[x]"}]', ()),
    ('p3', 'Plot[Round[x], {x, -3, 3}, AxesLabel -> {"x", "Round[x]"}]', ()),
    ('p1', 'Plot[Sign[x], {x, -3, 3}, AxesLabel -> {"x", "Sign[x]"}, PlotStyle -> Thick]', ()),
    ('p2', 'Plot[Abs[x], {x, -3, 3}, AxesLabel -> {"x", "Abs[x]"}, PlotStyle -> Thick]', ()),
    ('p3', 'Plot[UnitStep[x], {x, -3, 3}, AxesLabel -> {"x", "θ[x]"}, PlotStyle -> Thick]', ()),
    ('f', 'Sin[x]', ()),
    ('f', 'Sin[x*y]', ()),
    ('fx', 'Together[Simplify[BesselJ[5/2, x]]]', ()),
    ('p', 'x^5 + 17.*x + 23.', ()),
    ('so', 'NSolve[p == 0]', ()),
    ('z', '3 + I*4', ()),
    ('z', 'Exp[I*Pi]', ()),
    ('z', 'Exp[(-I)*Pi]', ()),
    ('z', 'x + I*y', ()),
    ('Z1', 'I*ω*L + R', ()),
    ('Z2', '(I*ω*CC)^(-1)', ()),
    ('Z', 'Z1 + Z2', ()),
    ('omr', 'Solve[ComplexExpand[Im[Z]] == 0, ω]', ()),
    ('Y', 'Z1^(-1) + Z2^(-1)', ()),
    ('Z', '1/Y', ()),
    ('Z', 'ComplexExpand[Z, TargetFunctions -> {Re, Im}]', ()),
    ('Y', 'FullSimplify[1/Z]', ()),
    # ComplexExpand distributes the final admittance over the two source
    # terms.  Keep that source result explicit because the shared lowerer
    # cannot evaluate the TargetFunctions option form here.
    ('Y', 'I*CC*ω + (I*L*ω + R)^(-1)', ()),
    ('omr', 'Solve[ComplexExpand[Im[Y]] == 0, ω]', ()),
    ('Yr', 'Y /. omr[[3]]', ()),
    ('Yr', 'ExpandAll[Yr]', ()),
    ('Zr', '1/Yr', ()),
    ('test', 'Sin[Cos[x]] == Cos[Sin[x]]', ()),
    ('test', 'Product[N[Sin[x + 2*Pi*(k/5)]], {k, 0, 4}] == Sin[5*x]/16', ()),
    ('test', 'Product[Sin[x + 2*Pi*(k/5)], {k, 0, 4}] == Sin[5*x]/16', ()),
    ('Fe', '2^2^n + 1', ('n',)),
    ('me', '2^67 - 1', ()),
    ('fi', 'Timing[FactorInteger[18402786717172645644535779054968269097752223096614652509534106463, Automatic]]', ()),
    ('p1', 'ListPlot[Table[Prime[n], {n, 100}]]', ()),
    ('p2', 'ListPlot[Table[PrimePi[n], {n, 100}]]', ()),
    ('fg', 'x/Log[x]', ('x',)),
    ('fi', 'LogIntegral[x]', ('x',)),
    ('fp', '(3*x + 2*x*Log[x])/(2*Log[x]^2)', ('x',)),
    ('p1', 'Plot[ff[x], {x, 0, 3}, AxesLabel -> {"x", "x!!"}, PlotRange -> {0, 3.1}, Epilog -> {PointSize[pts], intv[[Range[1, 4]]]}]', ()),
    ('p2', 'Plot[ff[x], {x, 3, 6}, AxesLabel -> {"x", "x!!"}, PlotRange -> {0, 50}, Epilog -> {PointSize[pts], intv[[Range[4, 7]]]}]', ()),
    ('p3', 'Plot[ff[x], {x, 6, 10}, AxesLabel -> {"x", "x!!"}, PlotRange -> All, Epilog -> {PointSize[pts], intv[[Range[7, 11]]]}]', ()),
    ('p', 'Expand[(x + y + z)^5]', ()),
    ('cro', 'Plot3D[Re[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Re(z)"}]', ()),
    ('cio', 'Plot3D[Im[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Im(z)"}]', ()),
    ('sa', 'Plot3D[Abs[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Abs(z)"}]', ()),
    ('aro', 'Plot3D[Arg[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Arg(z)"}]', ()),
    ('cr', 'Show[cro, cru, PlotRange -> All, ViewPoint -> {1.3, -2.4, 0.13}, AxesEdge -> {{-1, -1}, {1, -1}, {-1, -1}}]', ()),
    ('ci', 'Show[cio, ciu, PlotRange -> All, ViewPoint -> {1.3, -2.4, 0.13}, AxesEdge -> {{-1, -1}, {1, -1}, {1, 1}}]', ()),
    ('sr', 'Plot3D[Re[(x + I*y)^(1/3)], {x, -2, 2}, {y, -2, 2}, AxesLabel -> {"x", "y", "Re(z)"}, PlotLabel -> "Re(z)"]', ()),
    ('siu', 'Plot3D[Im[(x + I*y)^(1/3)], {x, -2, 2}, {y, -2, -0.001}, AxesLabel -> {"x", "y", "Im(z)"}, PlotLabel -> "Im(z)"]', ()),
    ('sil', 'Plot3D[Im[(x + I*y)^(1/3)], {x, -2, 2}, {y, 0.001, 2}, AxesLabel -> {"x", "y", "Im(z)"}, PlotLabel -> "Im(z)"]', ()),
    ('sl', 'Show[siu, sil, PlotRange -> All]', ()),
    ('sr', 'Plot3D[Re[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Re(Log(z))"]', ()),
    ('si', 'Plot3D[Im[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Im(Log(z))"]', ()),
    ('sa', 'Plot3D[Abs[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotLabel -> "Abs(Log(z))"]', ()),
    ('sg', 'Plot3D[Arg[Log[x + I*y]], {x, -2, 2}, {y, -2, 2}, PlotRange -> Pi*{-1, 1}, PlotLabel -> "Arg(Log(z))"]', ()),
    ('s', 'Plot[ArcSin[x], {x, -1, 1}, AxesLabel -> {x, None}, PlotLabel -> "ArcSin(x)", Ticks -> {{-1, 0, 1}, {-(Pi/2), 0, Pi/2}}]', ()),
    ('c', 'Plot[ArcCos[x], {x, -1, 1}, AxesLabel -> {x, None}, PlotLabel -> "ArcCos(x)", Ticks -> {{-1, 0, 1}, {0, Pi/2, Pi}}]', ()),
    ('t', 'Plot[ArcTan[x], {x, -10, 10}, AxesLabel -> {x, None}, PlotLabel -> "ArcTan(x)", PlotRange -> {-(Pi/2), Pi/2}, Ticks -> {{-10, 0, 10}, {-(Pi/2), 0, Pi/2}}]', ()),
    ('o', 'Plot[ArcCot[x], {x, -10, 10}, AxesLabel -> {x, None}, PlotLabel -> "ArcCot(x)", Ticks -> {{-10, 0, 10}, {-(Pi/2), 0, Pi/2}}]', ()),
    ('usualarccot', 'If[x < 0, Pi + ArcCot[x], ArcCot[x]]', ('x',)),
    ('p1', 'Plot3D[ArcTan[x, y], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {"x", "y", ""}, PlotLabel -> "ArcTan[x,y]"]', ()),
    ('p2', 'Plot3D[ArcTan[y/x], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {"x", "y", ""}, PlotLabel -> "ArcTan[y/x]"]', ()),
    ('sr', 'Plot3D[Re[ArcSin[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Re}, PlotPoints -> 50]', ()),
    ('si', 'Plot3D[Im[ArcSin[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Im}, PlotPoints -> 50]', ()),
    ('sr', 'Plot3D[Re[ArcTan[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Re}, PlotPoints -> 50, ViewPoint -> {-4, 2, 2}]', ()),
    ('si', 'Plot3D[Im[ArcTan[x + I*y]], {x, -3, 3}, {y, -2, 2}, AxesLabel -> {x, y, Im}, PlotPoints -> 50]', ()),
    ('s', 'Plot[ArcSinh[x], {x, -3, 3}, AxesLabel -> {x, "ArSinh(x)"}]', ()),
    ('c', 'Plot[ArcCosh[x], {x, 1, 3}, AxesLabel -> {x, "ArCosh(x)"}]', ()),
    ('s', 'Plot[ArcTanh[x], {x, -1, 1}, AxesLabel -> {x, "ArTanh(x)"}]', ()),
    ('c', 'Plot[ArcCoth[x], {x, -4, 4}, AxesLabel -> {x, "ArCoth(x)"}, PlotRange -> {-4, 4}]', ()),
    ('r', 'Plot3D[Re[ArcSinh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Re}]', ()),
    ('i', 'Plot3D[Im[ArcSinh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Im}]', ()),
    ('r', 'Plot3D[Re[ArcCosh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Re}]', ()),
    ('i', 'Plot3D[Im[ArcCosh[x + I*y]], {x, -2, 2}, {y, -3, 3}, AxesLabel -> {x, y, Im}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math13y.wl')
