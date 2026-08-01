$Version

(p1 = Plot[x^3, {x, -3, 3}]; )*(p2 = Show[p1, PlotRange -> {-30, 30}]; )*Show[GraphicsArray[{p1, p2}], ImageSize -> 450]

p1 = Plot[1/x, {x, -1, 1}, PlotRange -> {-15, 15}]; , Null, p2 = Show[p1, PlotRange -> {-10, 10}]; , Null, Show[GraphicsArray[{p1, p2}], ImageSize -> 450]

Clear[f, x]; f[x_] = x^8 + x - 1; , Null, p1 = Plot[f[y], {y, -2, 2}]; , Null, p2 = Show[p1, PlotRange -> {-1.6, 1}]; , Null, Show[GraphicsArray[{p1, p2}], ImageSize -> 450]

Plot[{Sin[x], Sin[2*x], Sin[3*x]}, {x, 0, Pi}, ImageSize -> 160]

pp = Table[Plot[Sin[n*x], {x, 0, Pi}, ImageSize -> 150], {n, 4}]

p1 = Show[pp, ImageSize -> 160]; , Null, p2 = Show[Reverse[pp], ImageSize -> 160]; , Null, Show[GraphicsArray[{p1, p2}]]

pt = Table[Sin[n*x], {n, 4}]

p1 = Plot[pt, {x, 0, 2*Pi}]

lc = Table[{Thick, Hue[k*0.1]}, {k, 0, 9, 3}]

p1 = Plot[pt, {x, 0, 2*Pi}, PlotStyle -> lc]

af[z_] = (3/Pi)*(I*(Pi + 2*Sqrt[Exp[z] - 1]) - Log[(1 + I*Sqrt[Exp[z] - 1])/(1 - I*Sqrt[Exp[z] - 1])]); neq = 11; b = 3.37465; e = -8.46758; 

styli = {{Thickness[0.01], GrayLevel[0]}, Hue[1.], Hue[0.9], Hue[0.8], Hue[0.7], Hue[0.6], Hue[0.5], Hue[0.4], Hue[0.3], Hue[0.2], Hue[0.1], {Thickness[0.01], GrayLevel[0]}}; 

fuli = Table[{Re[af[(k/neq)*Pi*I + x]], Im[af[(k/neq)*Pi*I + x]]}, {k, 0, neq}]; 

ParametricPlot[fuli, {x, b, e}, PlotStyle -> styli, ImageSize -> 450]

t = (-8)^(1/3)

N[%]

p2 = Plot[x^(1/3), {x, -8, 8}]

l1 = {{1, 1}, {-2, 1.5}, {-1.5, -1}, {0.8, 0.5}}; , Null, p1 = ListPlot[l1, PlotRange -> {-1, 1.5}]; , Null, l2 = {2, 3, 1, 4, 2.5, 1.5}; , Null, p2 = ListPlot[l2, PlotRange -> {0, 4}]; , Null, Show[GraphicsArray[{p1, p2}], ImageSize -> 450], Null

ps1 = ListPlot[l1, PlotJoined -> True]; ps2 = ListPlot[l2, PlotJoined -> True]; Show[GraphicsArray[{p1, p2}], ImageSize -> 450]*Show[GraphicsArray[{ps1, ps2}], ImageSize -> 450]

ListLinePlot[l1, ImageSize -> 150]

ListPlot[l1, Prolog -> Table[Disk[l1[[k]], 0.03], {k, Length[l1]}], AspectRatio -> Automatic]

f = x^8 + x - 1; s8 = Solve[f == 0., x]

r8 = {Re[x], Im[x]} /. s8

p1 = ListPlot[r8]; p2 = ListPlot[r8, PlotJoined -> True]; 

Show[GraphicsArray[{p1, p2}]]

n8 = {r8[[1]], r8[[2]], r8[[4]], r8[[6]], r8[[8]], r8[[7]], r8[[5]], r8[[3]], r8[[1]]}

p8 = ListPlot[n8, PlotJoined -> True]

list1 = Table[{x, Sin[Pi*x]}, {x, 0, 1, 0.05}]; , Null, list2 = Table[{x, Cos[2*Pi*x]}, {x, 0, 1, 0.03}]; , Null, list3 = Table[{x, 1.5*Cos[4*Pi*x]}, {x, 0, 1, 0.05}]; , Null, list4 = Table[{x, 1.5*Sin[4*Pi*x]}, {x, 0, 1, 0.05}]; , Null, ims = 350; 

ListPlot[{list1, list2, list3, list4}, ImageSize -> ims]

lc = Table[{Thick, Hue[k*0.1]}, {k, 0, 9, 3}]

ListPlot[{list1, list2, list3, list4}, Joined -> True, PlotStyle -> lc, ImageSize -> ims]

p1 = ParametricPlot[{Sin[t], Sin[2*t]}, {t, 0, 2*Pi}]; 

Clear[x, y, t]; x = t - Sin[t]; y = 1 + Cos[t]; p2 = ParametricPlot[{x, y}, {t, 0, 4*Pi}, Ticks -> {Pi*Range[0, 4], Range[0, 2]}]; 

Show[GraphicsRow[{p1, p2}], ImageSize -> 450]

r = t; PolarPlot[r, {t, 0, 4.1*Pi}, ImageSize -> 130]

PolarPlot[{t^2, -(Pi - t)^2}, {t, 0, Pi}]

Clear[x, y]*p1 = ContourPlot[x^2 + 2*y^2 == 3, {x, -2, 2}, {y, -2, 2}, ImageSize -> 150, Axes -> True]

ContourPlot[y*x == x + Sin[x], {x, -3, 3}, {y, 1, 2}, ImageSize -> 200]

p1 = ContourPlot[y*Sin[x] == 1/x^2, {x, -3, 3}, {y, -1, 1}, Axes -> True, PlotRange -> {-1, 1}]; p2 = ContourPlot[y*Sin[x] == 1/x^2, {x, -3, 3}, {y, -5, 5}, Axes -> True, PlotRange -> 5*{-1, 1}]; Show[GraphicsRow[{p1, p2}]]

ContourPlot[{(x^2 + y^2)^2 == x^2 - y^2, (x^2 + y^2)^2 == 2*x*y}, {x, -1, 1}, {y, -1, 1}, ContourStyle -> {GrayLevel[0], Dashing[{0.03}]}, ImageSize -> 200]

p1 = ContourPlot[Sin[2*x] + Cos[3*y] == 1, {x, -2*Pi, 2*Pi}, {y, -2*Pi, 2*Pi}, PlotPoints -> 50]; 

p2 = ContourPlot[{Sin[2*x] + Cos[3*y] == 1, Cos[2*x] + Sin[3*y] == 1}, {x, -2*Pi, 2*Pi}, {y, -2*Pi, 2*Pi}, PlotPoints -> 50]; 

Show[GraphicsRow[{p1, p2}]]

p1 = LogPlot[x^2, {x, 0.1, 4}]; , Null, p2 = LogLinearPlot[x^2, {x, 0.1, 4}, PlotRange -> All]; , Null, p3 = LogLogPlot[x^2, {x, 0.1, 4}]; , Null, Show[GraphicsArray[{p1, p2, p3}], ImageSize -> 550]

list = Table[x^2, {x, 0.2, 4, 0.2}]

p1 = ListLogPlot[list]; , Null, p2 = ListLogLinearPlot[list]; , Null, p3 = ListLogLogPlot[list]; , Null, Show[GraphicsArray[{p1, p2, p3}], ImageSize -> 550]

Information["Plot", LongForm -> False]

Information["Plot", LongForm -> True]

Information["ParametricPlot", LongForm -> True]

Information["ListPlot", LongForm -> True]

Information["ListLinePlot", LongForm -> True]

Information["PolarPlot", LongForm -> True]

Information["AspectRatio", LongForm -> False]

{Plot[Sqrt[1 - x^2], {x, 0, 1}], Plot[Sqrt[1 - x^2], {x, 0, 1}, AspectRatio -> Automatic]}

p = Plot[1/x, {x, -2, 2}]; p1 = Show[p, AspectRatio -> 1]; p2 = Show[p, AspectRatio -> Automatic]; Show[GraphicsArray[{p, p1, p2}], ImageSize -> 500]

Information["GoldenRatio", LongForm -> False]

Information["Axes", LongForm -> False]

k = ParametricPlot[{2*Cos[ϕ], 1*Sin[ϕ]}, {ϕ, 0, 2*Pi}]; k1 = Show[k, Axes -> False]; k2 = Show[k, Axes -> {True, False}]; k3 = Show[k, Axes -> {False, True}]; Show[GraphicsArray[{k1, k2, k3}], ImageSize -> 400]

Information["AxesLabel", LongForm -> False]

x = "cos(t)"; y = "sin(t)"; k1 = Show[k, AxesLabel -> {"x", "y"}]; k2 = Show[k, AxesLabel -> {x, y}]; Show[GraphicsArray[{k1, k2}], ImageSize -> 400]

Information["AxesOrigin", LongForm -> False]

k1 = ParametricPlot[{0.5 + Cos[t], 1 + Sin[t]}, {t, 0, 2*Pi}]; k2 = Show[k1, AxesOrigin -> {0.5, 1}]; Show[GraphicsArray[{k1, k2}]]

Information["AxesStyle", LongForm -> False]

k1 = Show[k, AxesStyle -> Thickness[0.02]]; k2 = Show[k, AxesStyle -> {{Thickness[0.015]}, {Thickness[0.001]}}]; k3 = Show[k, AxesStyle -> {{Thickness[0.015], Hue[0]}, {Thickness[0.01], Hue[0.6]}}]; Show[GraphicsArray[{k1, k2, k3}], ImageSize -> 500]

Information["Background", LongForm -> False]

k1 = Show[k, Background -> GrayLevel[0.9]]; k2 = Show[k, Background -> GrayLevel[0]]; k3 = Show[k, Background -> RGBColor[0., 0.999, 0.]]; Show[GraphicsArray[{k1, k2, k3}], ImageSize -> 500]

k1 = ParametricPlot[{2*Cos[ϕ], 1*Sin[ϕ]}, {ϕ, 0, 2*Pi}, BaseStyle -> RGBColor[0.9, 0, 0], Background -> RGBColor[0., 0.999, 0.]]; , Null, k2 = ParametricPlot[{2*Cos[ϕ], 1*Sin[ϕ]}, {ϕ, 0, 2*Pi}, Background -> GrayLevel[0], PlotStyle -> {Thick, GrayLevel[1]}, BaseStyle -> GrayLevel[1]]; , Null, k3 = ParametricPlot[{2*Cos[ϕ], 1*Sin[ϕ]}, {ϕ, 0, 2*Pi}, Background -> RGBColor[0., 0.999, 0.], PlotStyle -> {Red}]; , Null, Show[GraphicsArray[{k2, k1, k3}], ImageSize -> 500]

Information["BaseStyle", LongForm -> False]

k4 = ParametricPlot[{2*Cos[ϕ], 1*Sin[ϕ]}, {ϕ, 0, 2*Pi}, PlotStyle -> {Hue[0], Thickness[0.01]}]; k1 = Show[k4, AxesLabel -> {"x", "y"}, Background -> GrayLevel[0.3], BaseStyle -> Hue[0.3], PlotLabel -> Style["Ellipse\n", FontSize -> 16, FontFamily -> Helvetica]]

Graphics[{Circle[{0, 0}, 1], Disk[{3, 0}, 1]}, BaseStyle -> Blue]

Information["BaselinePosition", LongForm -> False]

Clear[x, y], Null, p1 = {x, Graphics[Circle[], BaselinePosition -> Center, BaselinePosition -> Center, ImageSize -> 30], y}; , Null, p2 = {x, Graphics[Circle[], BaselinePosition -> Top, BaselinePosition -> Center, ImageSize -> 30], y}; , Null, p3 = {x, Graphics[Circle[], BaselinePosition -> Bottom, BaselinePosition -> Center, ImageSize -> 30], y}; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 450]

Information["ClippingStyle", LongForm -> False]

SetOptions[Plot, ImageSize -> 140]; , Null, pp = Table[Plot[Sin[x], {x, -3, 3}, PlotRange -> {-0.7, 0.7}, ClippingStyle -> cs], {cs, {None, Automatic, Red}}]

Information["ColorFunction", LongForm -> False]

pp = Plot[2*Sin[x], {x, -3, 3}, PlotStyle -> AbsoluteThickness[3], ColorFunction -> Hue]

Information["ColorFunctionScaling", LongForm -> False]

pp = Plot[2*Sin[x], {x, -3, 3}, PlotStyle -> AbsoluteThickness[3], ColorFunction -> Hue, ColorFunctionScaling -> False, ImageSize -> 200]

Information["DisplayFunction", LongForm -> False]

Show[Graphics[{Blue, Disk[{0, 0}, 1]}], DisplayFunction -> (PopupWindow[Button["Click here"], #1] & )]

Information["Epilog", LongForm -> False]

pp = Plot[Sin[x], {x, -3, 3}, Epilog -> Line /@ Table[{{n, 1.1}, {n, -1.1}}, {n, -3, 3}]]

Information["Exclusions", LongForm -> False]

p1 = Plot3D[Im[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}]; , Null, p2 = Plot3D[Im[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, Exclusions -> None]; , Null, p3 = Plot3D[Im[Sqrt[x + I*y]], {x, -2, 2}, {y, -2, 2}, ExclusionsStyle -> Opacity[0.5]]; , Null, GraphicsRow[{p1, p2, p3}, Spacings -> Scaled[0.4], ImageSize -> 550]

Information["ExclusionsStyle", LongForm -> False]

p1 = DensityPlot[Tan[x*y], {x, -2, 2}, {y, -2, 2}, ColorFunction -> "Rainbow"]; , Null, p2 = DensityPlot[Tan[x*y], {x, -2, 2}, {y, -2, 2}, ColorFunction -> "Rainbow", Exclusions -> {Cos[x*y] == 0}]; , Null, GraphicsRow[{p1, p2}, Spacings -> Scaled[0.4], ImageSize -> 500]

Information["Filling", LongForm -> False]

Table[Plot[Sin[x], {x, 0, 2*Pi}, Filling -> f], {f, {Top, Bottom, Axis, 0.3}}]

GraphicsRow[Table[Plot[BesselJ[n, x], {x, 0, 10}], {n, 4}], ImageSize -> 550]

p1 = Plot[Table[BesselJ[n, x], {n, 4}], {x, 0, 10}, Filling -> Axis]; , Null, p2 = Plot[Evaluate[Table[BesselJ[n, x], {n, 4}]], {x, 0, 12}, Filling -> Axis]; , Null, p3 = Plot[Sin[3*x]^2, {x, 0, 3*Pi}, Filling -> Axis, FillingStyle -> Orange]; , Null, GraphicsRow[{p1, p2, p3}, Spacings -> Scaled[0.4], ImageSize -> 500]

Information["FillingStyle  (*  see  p3 above *)", LongForm -> False]

Information["FormatType", LongForm -> False]

Clear[x, y], Null, p1 = Graphics[{Circle[], Text[Style[x^2 + y^2 == 1, 15]]}]; , Null, p2 = Graphics[{Circle[], Text[Style[x^2 + y^2 == 1, 15]]}, FormatType -> StandardForm]; , Null, p3 = Graphics[Circle[], Axes -> True, AxesLabel -> {Cos[θ], Sin[θ]}]; , Null, p4 = Graphics[Circle[], Axes -> True, AxesLabel -> {Cos[θ], Sin[θ]}, FormatType -> StandardForm]; , Null, GraphicsRow[{p1, p2, p3, p4}, ImageSize -> 570]

Information["Frame", LongForm -> False]

p1 = Plot[Sin[x^2], {x, 0, 3}]; p2 = Show[p1, Frame -> True]; GraphicsRow[{p1, p2}]

Information["FrameLabel", LongForm -> False]

p1 = Plot[x^2, {x, 0, 3}, Frame -> True, FrameLabel -> {"x", "x^2"}]; p2 = Plot[{x^2, Sin[x^3]}, {x, 0, 3}, Frame -> True, FrameLabel -> {"x", "x^2", "x", "Sin[x^3]"}]; GraphicsRow[{p1, p2}, ImageSize -> 450]

p3 = Show[p1, RotateLabel -> False]; p4 = Show[p2, RotateLabel -> False]; , Null, GraphicsRow[{p3, p4}, ImageSize -> 450]

Information["FrameStyle", LongForm -> False]

p2 = Plot[Sqrt[x], {x, 0, 4}, Frame -> True, FrameStyle -> {{Thickness[0.02]}, {Thickness[0.02], Hue[0.6]}, {Thickness[0.01], RGBColor[0.8, 0, 0]}, {Thickness[0.01]}}]

Information["FrameTicks", LongForm -> False]

pr = Plot[Sqrt[x], {x, 0, 4}, Frame -> True]; GraphicsRow[{p2, pr}, ImageSize -> 400]*p1 = Show[pr, FrameTicks -> None]; p2 = Show[pr, FrameTicks -> {{0, 1, 2, 3, 4}, {0, 1, 2}}]; p3 = Plot[Sin[x], {x, -2*Pi, 2*Pi}, Frame -> True, FrameTicks -> {Pi*{-2, -1, 0, 1, 2}, {-1, 0, 1}, {}, {}}]; GraphicsRow[{p1, p2, p3}, ImageSize -> 490]

bp1 = Plot[Sin[x], {x, 0, 10}, Frame -> True, FrameTicks -> {Pi*(Range[0, 6]/2), Automatic, None, None}]; , Null, bp2 = Plot[Sin[x], {x, 0, 10}, Frame -> True, FrameTicks -> {{0, {Pi/2, ""}, Pi, {3*(Pi/2), ""}, {4.5, "λ", {0.05, 0.02}}, 2*Pi, {5*(Pi/2), ""}, 3*Pi}, Automatic, {{7.6, "μ", {0.05, 0.01}}}, None}]; , Null, GraphicsRow[{bp1, bp2}, ImageSize -> 400]

Information["FrameTicksStyle", LongForm -> False]

p1 = Plot[Sin[x], {x, 0, 10}, Frame -> True, FrameTicks -> Automatic, FrameTicksStyle -> Directive[Orange, 12]]; , Null, p2 = Plot[Cos[x], {x, 0, 10}, Frame -> True, FrameTicks -> All, FrameTicksStyle -> {{Black, Blue}, {Red, Green}}]; , Null, p3 = Plot[Sin[x], {x, 0, 10}, Frame -> True, FrameTicksStyle -> Directive[Thick, Italic]]; , Null, Show[GraphicsArray[{p1, p2, p3}], ImageSize -> 550]

Information["GridLines", LongForm -> False]

p1 = Plot[Sin[x^2], {x, 0, 4}, Frame -> True, GridLines -> Automatic]; p2 = Show[p1, GridLines -> {{0, Pi/2, Pi}, {-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75}}]; th = Thickness[0.0075]; p3 = Plot[1.5*(1 + Sin[x]), {x, 0, 3}, PlotRange -> All, GridLines -> {{{0.5, {Hue[0.25], th}}, {1.5, {Hue[0.5], th}}, {2.5, {Hue[0.75]}}}, {{1.5, {Hue[0.3]}}, {2.5, {Hue[0]}}, {3, {Hue[0.9]}}}}]; Show[GraphicsArray[{p1, p2, p3}], ImageSize -> 550]

Information["GridLinesStyle", LongForm -> False]

p1 = Plot[Cos[x], {x, 0, 10}, Ticks -> {None, Automatic}, GridLines -> {{Pi, 2*Pi, 3*Pi}, {-1, -0.5, 0.5, 1}}, GridLinesStyle -> Directive[Red, Dashed]]; , Null, p2 = Plot[Cos[x], {x, 0, 10}, Ticks -> {None, Automatic}, GridLines -> {{Pi, 2*Pi, 3*Pi}, {-1, -0.5, 0.5, 1}}, GridLinesStyle -> {{Red, Dashed}, {Blue}}]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 450]

Information["ImageMargins", LongForm -> False]

Plot[{Sqrt[1 - x^2], -Sqrt[1 - x^2]}, {x, -1, 1}, Frame -> True, AspectRatio -> 1, ImageMargins -> {5, 10}]

p1 = Framed[Graphics[Circle[{0, 0}, 1], ImageSize -> 100]]; , Null, p2 = Framed[Graphics[Circle[{0, 0}, 1], ImageMargins -> 20, ImageSize -> 100]]; , Null, p3 = Framed[Graphics[Circle[{0, 0}, 1], ImageMargins -> {{5, 20}, {20, 30}}, ImageSize -> 100]]; , Null, GraphicsRow[{p1, p2, p3}, ImageSize -> 500, PlotRange -> All]

Information["ImageSize ", LongForm -> False]

p1 = Plot[Sin[x], {x, 0, 2*Pi}, ImageSize -> 200]; , Null, pp := Plot[Sin[x], {x, 0, 3*Pi}, ImageSize -> 29*xcm], Null, xcm = 6; GraphicsRow[{p1, pp}]

Information["MaxRecursion", LongForm -> False]

SetOptions[Plot, ImageSize -> 130]; , Null, Table[Plot[Sin[x^2], {x, 0, 10}, PlotPoints -> 5, MaxRecursion -> mr], {mr, {0, 2, 4, 6}}]

Information["Mesh", LongForm -> False]

p1 = ListLinePlot[Table[Prime[n], {n, 20}]]; , Null, p2 = ListLinePlot[Table[Prime[n], {n, 20}], Mesh -> All]; , Null, p3 = ListLinePlot[Table[Prime[n], {n, 20}], MeshStyle -> Hue[0]]; , Null, Show[GraphicsArray[{p1, p2, p3}], ImageSize -> 400]

Information["MeshStyle  (* see preceeding  p3 *)", LongForm -> False]

Information["PlotLabel", LongForm -> False]

Clear[x], Null, p1 = Plot[Sin[x^2], {x, 1, 3}, AxesLabel -> {"x", "y"}, PlotLabel -> Sin[x^2]]; , Null, p2 = Plot[Sin[x^2], {x, 1, 3}, AxesLabel -> {"x", "y"}, PlotLabel -> "Graph der Funktion Sin[x^2]\n"]; , Null, Show[GraphicsArray[{p1, p2}], ImageSize -> 400]

Information["PlotPoints", LongForm -> True]

p1 = Plot[Sin[1000*x], {x, 0, Pi}]; p2 = Plot[Sin[1000*x], {x, 0, Pi}, PlotPoints -> 800]; Show[GraphicsGrid[{{p1}, {p2}}], ImageSize -> 620]

Information["PlotRange", LongForm -> False]

PlotRange -> ymax

p1 = Plot[1/x, {x, -2, 2}, PlotRange -> {-5, 12}]; p2 = Show[p1, PlotRange -> {{-2, 2}, {-10, 10}}]; Show[GraphicsArray[{p1, p2}], ImageSize -> 400]

p1 = Plot3D[Sqrt[1 - x^2 - y^2], {x, -2, 2}, {y, -2, 2}, PlotRange -> All]; , Null, p2 = Plot3D[Sqrt[1 - x^2 - y^2], {x, -2, 2}, {y, -2, 2}, PlotRange -> Full]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 450]

Information["PlotRegion", LongForm -> False]

pr = Plot[Sqrt[x], {x, 0, 4}, Frame -> True, FrameLabel -> {x, Sqrt[x], x, "x^(1/2)"}, PlotRegion -> {{0.2, 0.8}, {0.2, 0.8}}, ImageSize -> 300]

Information["PlotStyle", LongForm -> False]

th = AbsoluteThickness[1]; p1 = Plot[{Sin[x], Sin[2*x], Sin[3*x], Sin[4*x]}, {x, 0, 2*Pi}, PlotStyle -> {{th, RGBColor[1, 0, 0]}, {th, RGBColor[0, 1, 0]}, {th, RGBColor[0, 0, 1]}}]; pi = Table[Plot[Sin[k*x], {x, 0, 2*Pi}, PlotStyle -> {Thick, Hue[k*0.25]}], {k, 4}]; p2 = Show[pi]; GraphicsRow[{p1, p2}, ImageSize -> 550]

Information["Prolog", LongForm -> False]

p1 = Plot[x^2, {x, -1.5, 1.5}, Prolog -> {Pink, Disk[{0, 1}, 1]}, PlotStyle -> Thick, AspectRatio -> Automatic]; , Null, p2 = Plot[x^2, {x, -1.5, 1.5}, Epilog -> {Pink, Disk[{0, 1}, 1]}, PlotStyle -> Thick, AspectRatio -> Automatic]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 350]

Information["RotateLabel", LongForm -> False]

Information["Style", LongForm -> False]

Information["Ticks", LongForm -> False]

s = Plot[Sin[t], {t, 0, 2*Pi}]; p1 = Show[s, Ticks -> None]; Show[GraphicsArray[{s, p1}], ImageSize -> 450]

p1 = Show[s, Ticks -> {Pi*(Range[4]/2), Range[-1, 1, 1/2]}]; p2 = Show[s, Ticks -> {{{Pi/2, "λ/4"}, {Pi, "λ/2"}, {3*(Pi/2), "3λ/4"}, {2*Pi, "λ"}}, {-1, 0, 1}}]; Show[GraphicsArray[{p1, p2}], ImageSize -> 450]

Information["TicksStyle", LongForm -> False]

p1 = Plot[Sin[x], {x, 0, 10}]; , Null, p2 = Plot[Sin[x], {x, 0, 10}, TicksStyle -> Directive[Orange, 14]]; , Null, p3 = Plot[Sin[x], {x, 0, 10}, TicksStyle -> Directive[Thick, Orange, 14]]; , Null, GraphicsRow[{p1, p2, p3}, ImageSize -> 550]

Plot[Cos[x], {x, 0, 10}, TicksStyle -> {{16, Red}, {12, Blue}}, ImageSize -> 250]

Plot[Sin[x], {x, 0, 10}, Ticks -> {{0, {Pi, Pi, 1, Directive[Blue, Thick]}, 2*Pi, 3*Pi}, Automatic}, AxesStyle -> Directive[Gray, Dashed], TicksStyle -> Directive[Orange, 12]]

p1 = Graphics[Circle[], Frame -> True, FrameTicks -> All, TicksStyle -> Orange]; , Null, p2 = Graphics[Circle[], Frame -> True, FrameTicks -> All, FrameTicksStyle -> Orange]; , Null, GraphicsRow[{p1, p2}, ImageSize -> 300]
