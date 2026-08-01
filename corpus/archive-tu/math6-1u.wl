f = Cos[x] - Sin[x]

Plot[f, {x, -2*Pi, 2*Pi}]

x0 = FindRoot[f == 0, {x, {-6, -2, 0, 4}}]

f /. x0

Plot[{x, Tan[x]}, {x, -5*Pi, 7*Pi}]

x0 = FindRoot[x == Tan[x], {x, {-15, -9, -7, -4, 0, 4, 7, 10, 13, 19}}]

Tan[x] - x /. x0

x0 = Solve[x^7 == 1, x]

r = {Re[x], Im[x]} /. x0

ListPlot[r]

x0 = Solve[x^7 + 3*x^3 == 1, x]

r = {Re[x], Im[x]} /. x0

ListPlot[r]

x0 = NSolve[(1/(2*x))*Exp[x] == 1, x]

ListPlot[Re[x0], Im[x0]]

Null

Null

PolarPlot[1 + Cos[t], {t, 0, 2*Pi}]

Plot[1 + Cos[t], {t, 0, 2*Pi}]

f = x^4 - 2*x^3 + x^2 + 3*x; , Null, k = Plot[f, {x, -1, 1}, Background -> RGBColor[0., 1., 0.], PlotStyle -> Blue, BaseStyle -> Yellow, AxesLabel -> {"x", "f(x)"}, PlotLabel -> f]

ContourPlot[9*x^2 - 12*y*x - 16*x + 4*y^2 + 8*y - 27 == 0, {x, -10, 1}, {y, -15, 1}]

y0 = Solve[9*x^2 - 12*y*x - 16*x + 4*y^2 + 8*y - 27 == 0, y]

Plot[y /. y0, {x, -8, 1}]

Null

T = (2/Pi)*EllipticK[Sin[a/2]^2]; , Null, xticks = ({#1, ""} & ) /@ Range[0, 2*Pi, Pi*(10/180)]; , Null, xticks = MapAt[#1[[1]] & , xticks, Partition[Range[1, 37, 3], 1]]; , Null, yticks = ({#1, ""} & ) /@ Range[0, 7, 1/2]; , Null, yticks = MapAt[#1[[1]] & , yticks, Partition[Range[1, 15, 2], 1]]; , Null, Plot[T, {a, 0, 2*Pi}, PlotRange -> {Automatic, {0, 7}}, Ticks -> {xticks, yticks}, GridLines -> {Range[0, 2*Pi, Pi*(30/180)], Range[0, 7]}, PlotLabel -> "Mathematical Pendulum", AxesLabel -> {"\!\(\*\nStyleBox["*α*",\nAspectRatioFixed->True,\nFontTracking->"*Plain*",\nFontVariations->{"*Outline*"->False,\n"*Shadow*"->False,\n"*Underline*"->False}]\)", "T/T0"}]

k1 = 3; k2 = 2; , Null, y1 = Table[{x, k1*(k2/x)}, {x, -k1, -0.01, 0.01}]; , Null, y2 = Table[{x, k1*(k2/x)}, {x, 0.01, k1, 0.01}]; , Null, y3 = Table[{x, k1*(k2/x)}, {x, (-3/2)*k1, -k1, 0.01}]; , Null, y4 = Table[{x, k1*(k2/x)}, {x, k1, (3/2)*k1, 0.01}]; , Null, ListPlot[{y1, y2, y3, y4, {{-k1, -k2}}, {{k1, k2}}}, AxesLabel -> {"x", "y"}, Ticks -> {{-k1, k1}, {-k2, k2}}, Joined -> {True, True, True, True, False, False}, PlotStyle -> {Thick, Thick, {}, {}, PointSize[Large], PointSize[Large]}, PlotLabel -> "Branch cut of square root"], Null, ListPlot[{y1, y2, y3, y4, {{-k1, -k2}}, {{k1, k2}}}, AxesLabel -> {"x", "y"}, Ticks -> {{-k1, k1}, {-k2, k2}}, Joined -> {True, True, True, True, False, False}, PlotStyle -> {Red, Red, Yellow, Yellow, PointSize[Large], PointSize[Large]}, PlotLabel -> "Branch cut of square root"]

Null

Null

V1 = Table[{r, r^2}, {r, 0, 1, 0.01}]; , Null, V12 = Table[{r, r^2}, {r, 1, 3, 0.01}]; , Null, V21 = Table[{r, 1/r}, {r, 0.01, 1, 0.01}]; , Null, V2 = Table[{r, 1/r}, {r, 1, 3, 0.01}]; , Null, ListPlot[{V1, V12, V21, V2}, Joined -> True, PlotStyle -> {Black, {Black, Dashed}, {Black, Dashed}, Black}, AxesLabel -> {"r", "V(r)"}]

f = Table[{Cos[p], Sin[p]}, {p, 0, 2*Pi*(4/5), 2*(Pi/5)}]; , Null, l = {"A", "B", "C", "D", "E"}; , Null, Graphics[{{Transparent, EdgeForm[AbsoluteThickness[3]], Polygon[f]}, (Text[#2, #1] & ) @@@ Transpose[{0.9*f, l}]}]

GraphicsRow[{Plot[x, {x, -1, 1}, AspectRatio -> 1], Plot[x^2/2, {x, -1, 1}, AspectRatio -> 1]}]
