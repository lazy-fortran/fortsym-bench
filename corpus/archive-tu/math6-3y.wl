$Version]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         {x, y}, "InlineMath"], " dimensions"}], "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendShadow, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendShadow"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["specify shadow", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendTextSpace, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendTextSpace"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["space in the legend box for text", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendTextDirection, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendTextDirection"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell[Row[{"\tdirection text is rotated, as in ", ExpressionCell[Button[Text, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Text"], "InlineFormula"], " graphics primitive"}], "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendTextOffset, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendTextOffset"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell[Row[{"offset", " ", "of", " ", "text,", " ", "as", " ", "in", " ", ExpressionCell[Button[Text, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Text"], "InlineFormula"], " ", "graphics", " ", "primitive"}], "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendLabel, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendLabel"], Button[None, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/None"], TextCell["label for legend", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendLabelSpace, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendLabelSpace"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell[Row[{"specify", " space for ", ExpressionCell[Button[LegendLabel, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendLabel"], "InlineFormula"]}], "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendOrientation, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendOrientation"], Vertical, TextCell["direction in which key boxes are laid out", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendSpacing, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendSpacing"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["specify the amount of space around each key box", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendBorder, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendBorder"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["style of border of key boxes and text", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendBorderSpace, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendBorderSpace"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["specify space around all boxes and text", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendBackground, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendBackground"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell["style of the background", "TableText"]}}

Information["Integrate", LongForm -> True]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             HoldForm[p3 = Plot3D[-Sin[x*y], {x, -2, 2}, {y, -1, 1}, AxesLabel -> {"x", "y", "f"}, ViewPoint -> {-0.469, -2.689, 2.}]; , Null, dp = DensityPlot[Sin[x*y], {x, -2, 2}, {y, -1, 1}, ColorFunction -> (GrayLevel[1 - #1] & ), PlotPoints -> 28, FrameLabel -> {"x", "y"}]; , Null, Show[GraphicsRow[{p3, dp}], ImageSize -> 500]

bp = Plot[Sin[x], {x, 0, 3.2}, Ticks -> {(1/4)*Pi*{1, 2, 3, 4}, {0.5, 1}}, ImageSize -> 200]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                           HoldForm[maxf = 1; minf = -1; , Null, ShowLegend[dp, {GrayLevel[1 - #1] & , 6, ToString[maxf], ToString[minf], LegendPosition -> {1.1, -0.4}}, FrameLabel -> {"x", "y"}]

AbsoluteOptions[bp]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    HoldForm[c = ContourPlot[Sin[x*y], {x, -2, 2}, {y, -1, 1}, ColorFunction -> (GrayLevel[1 - #1] & ), PlotPoints -> 28, Contours -> 7, FrameLabel -> {"x", "y"}, ImageSize -> 300]

Options[bp]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            HoldForm[maxf = 1; minf = -1; , Null, ShowLegend[c, {GrayLevel[1 - #1] & , 6, ToString[maxf], ToString[minf], LegendPosition -> {1.1, -0.4}}]

AbsoluteOptions[bp, Ticks]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             HoldForm[maxf = 1; minf = -1; , Null, dd = DensityPlot[Sin[x*y], {x, -2, 2}, {y, -1, 1}, ColorFunction -> (Hue[#1] & ), PlotPoints -> 28, FrameLabel -> {"x", "y"}]; 

p1 = Plot[1/x, {x, -3, 3}]; p2 = Plot[1/x, {x, -3, 3}, PlotRange -> {-10, 10}]; Show[GraphicsRow[{p1, p2}], ImageSize -> 450]]                                                                                                                                                                                                                                                                                                                                                                                                                                          HoldForm[dm = DensityPlot[Sin[x*y], {x, -2, 2}, {y, -1, 1}, ColorFunction -> (Hue[#1/(maxf - minf - 0.82)] & ), PlotPoints -> 28, FrameLabel -> {"x", "y"}]; 

Information["SetOptions", LongForm -> False]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           HoldForm[Show[GraphicsRow[{dd, dm}], ImageSize -> 500]

Information["Plot", LongForm -> True]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  HoldForm[a1 = ShowLegend[dd, {Hue[#1/(maxf - minf - 0.82)] & , 9, ToString[maxf], ToString[minf], LegendPosition -> {1.1, -0.4}}, FrameLabel -> {"x", "y"}]; 

SetOptions[Plot, Background -> Yellow]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 HoldForm[c = ContourPlot[Sin[x*y], {x, -2, 2}, {y, -1, 1}, ColorFunction -> (Hue[#1/(maxf - minf - 0.82)] & ), PlotPoints -> 28, Contours -> 9, DisplayFunction -> Identity, FrameLabel -> {"x", "y"}]; 

curves = Table[Sin[n*x], {n, 3}]; , Null, plosty = Thread[Table[PlotStyle, {3}] -> Table[Dashing[{3*(n - 1)*0.01}], {n, 3}]]; , Null, Table[Plot[curves[[n]], {x, 0, 2*Pi}, plosty[[n]]], {n, 3}]]                                                                                                                                                                                                                                                                                                                                                                      HoldForm[a2 = ShowLegend[c, {Hue[#1/(maxf - minf - 0.82)] & , 10, ToString[maxf], ToString[minf], LegendPosition -> {1.1, -0.4}}, FrameLabel -> {"x", "y"}, RotateLabel -> True]; 

Table[Plot[curves[[n]], {x, 0, 2*Pi}, Evaluate[plosty[[n]]], ImageSize -> 150], {n, 3}]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                HoldForm[Show[GraphicsArray[{a1, a2}], ImageSize -> 500]

SetOptions[Plot, Background -> None]; ]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 HoldForm[GraphicsRow[{Plot3D[Sin[x*y], {x, 0, Pi}, {y, 0, Pi}, ColorFunction -> "Rainbow"], Graphics[Legend[ColorData["Rainbow"][1 - #1] & , 10, " 1", "-1"]]}]

nu = Table[N[k/9], {k, 0, 9}]; , Null, Print["  ", NumberForm[nu, {3, 2}]], Null, Show[Graphics[Table[{Hue[k/9], Rectangle[{k, 0}, {k + 1.5, 1}]}, {k, 0, 9}]], AspectRatio -> 0.15, ImageSize -> 430]]                                                                                                                                                                                                                                                                                                                                                                 HoldForm[Information["Animate", LongForm -> True]

Show[Graphics[{Hue[0.6], Rectangle[{0, 0}, {1, 1}], Hue[0.6, 0.1, 0.1], Rectangle[{1, 0}, {2, 1}], Hue[0.6, 0.1, 0.9], Rectangle[{2, 0}, {3, 1}], Hue[0.6, 0.3, 0.9], Rectangle[{3, 0}, {4, 1}], Hue[0.6, 0.5, 0.9], Rectangle[{4, 0}, {5, 1}], Hue[0.6, 0.7, 0.9], Rectangle[{5, 0}, {6, 1}], Hue[0.6, 0.9, 0.9], Rectangle[{6, 0}, {7, 1}], Hue[0.6, 0.3, 0.8], Rectangle[{7, 0}, {8, 1}]}], AspectRatio -> 0.2]]                                                                                                                                                     HoldForm[deqn = {-x[t] + x[t]^3 + Derivative[1][p][t] == γ*Cos[ω*t] - ε*p[t], Derivative[1][x][t] == p[t]}; 

colist = {Black, Blue, Brown, Cyan, Gray, Green, LightBlue, LightGray, LightPink, LightYellow, Magenta, Orange, Pink, Purple, Red, White, Yellow}]                                                                                                                                                                                                                                                                                                                                                                                                                      HoldForm[param = {ε -> 0.25, γ -> 0.3, ω -> 1.}; , Null, initial = {x[0] == 0, p[0] == -0.8}; 

Table[Show[Graphics[{colist[[k]], Rectangle[{k - 1, 0}, {k, 1}]}], ImageSize -> 50, Frame -> True, FrameTicks -> None], {k, Length[colist]}]]                                                                                                                                                                                                                                                                                                                                                                                                                           HoldForm[traj = NDSolve[Join[deqn, initial] /. param, {x[t], p[t]}, {t, 0, 22*Pi}]; 

Get["Graphics`Colors`"]; ]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              HoldForm[Animate[ParametricPlot[{x[t], p[t]}/traj, {t, 0, te}, PlotRange -> {{-2, 2}, {-1, 1}}, PlotPoints -> 100, AxesLabel -> {"x", "p"}, FormatType -> {FontSize -> 18}, ImageSize -> 500], {te, 0, 15*Pi}]

AllColors]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              HoldForm[a = 3; b = 2; c = 1; , Null, lr = {x = a*Sin[th]*Cos[ph], y = b*Sin[th]*Sin[ph], z = c*Cos[th]}; , Null, lieps = Table[ParametricPlot3D[lr, {th, 0, Pi}, {ph, 0, 2*Pi}, PlotRange -> 3.2*{{-1, 1}, {-1, 1}, {-1, 1}, SphericalRegion -> True}, ViewPoint -> 5*{Cos[α], Sin[α], 0.2}], {α, 0, Pi, Pi/10}]

Navajo]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 HoldForm[Animate[ParametricPlot3D[lr, {th, 0, Pi}, {ph, 0, 2*Pi}, PlotRange -> 3.2*{{-1, 1}, {-1, 1}, {-1, 1}}, SphericalRegion -> True, ViewPoint -> 5*{Cos[α], Sin[α], 0.2}, Ticks -> None], {α, 0, 2*Pi}]

Show[Graphics[{Navajo, Disk[{0, 0}, 1]}], ImageSize -> 100]

Information["Opacity", LongForm -> False]

Opacity[0] = Invisble, Null, Opacity[1] = Intransparent = opaque

p1 = Graphics[{Red, Disk[], Blue, Disk[{1, 0}]}, ImageSize -> 150]; , Null, p2 = Graphics[{Blue, Disk[], Red, Disk[{1, 0}]}, ImageSize -> 150]; , Null, p3 = Graphics[{Opacity[0.5, Red], Disk[], Opacity[0.5, Blue], Disk[{1, 0}]}, ImageSize -> 150]; , Null, GraphicsRow[{p1, p2, p3}]

Table[Graphics3D[{Opacity[a], Sphere[]}, ImageSize -> 100], {a, 0, 1, 1/3}]

Plot3D[x^2 + y^2, {x, -3, 3}, {y, -3, 3}, AxesLabel -> {"x", "y", "  \!\(\*SuperscriptBox[\(x\), \(2\)]\) + \!\(\*SuperscriptBox[\(y\), \(2\)]\)"}, ColorFunction -> (Directive[Opacity[#1], Blue] & ), PlotPoints -> 40, Mesh -> None]

SetOptions[Plot, Background -> None]; 

(y = Sin[x]; )*(p1 = Plot[Sin[x], {x, 0, 2*Pi}, AxesLabel -> {x, y}]; p2 = Plot[Sin[x], {x, 0, 2*Pi}, AxesLabel -> {"x", "y"}]; Show[GraphicsRow[{p1, p2}]])

Information["Row", LongForm -> False]

Table[Plot[Sin[n*x], {x, 0, 2*Pi}, PlotLabel -> Row[{"Sin(", n, "x)"}], ImageSize -> 200], {n, 3}]

Row[Range[50], "."]

Row[Range[50], "+"]

%

ToExpression[%%]

p1 = Plot[Sin[x]^2, {x, 0, 2*Pi}, PlotLabel -> Sin[x]^2]; , Null, p2 = Plot[Sin[x]^2, {x, 0, 2*Pi}, PlotLabel -> Sin[x]^2, BaseStyle -> {FontSlant -> Italic, FontSize -> 15}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 400]

Clear[x, y], Null, p1 = Plot[Sin[x]^2, {x, 0, 2*Pi}, PlotLabel -> Style[Sin[x]^2, FontSize -> 11, FontSlant -> "Italic", FontWeight -> Bold]]; , Null, p2 = Plot[Sin[x]^2, {x, 0, 2*Pi}, PlotLabel -> Sin[x]^2, AxesLabel -> {Style[x, FontSize -> 16, FontFamily -> "Helvetica"], Style[y, FontSize -> 14, FontFamily -> "Times"]}]; , Null, Show[GraphicsRow[{p1, p2}], ImageSize -> 500]

Information["Style", LongForm -> False]

Information["GraphicsRow", LongForm -> False]

Information["GraphicsGrid", LongForm -> False]

pp = Table[Plot[(-1)^n*(Sin[n*x]/n), {x, -Pi, Pi}, ImageSize -> 140, PlotRange -> {-1, 1}, Ticks -> {{-Pi, 0, Pi}, {-1, 0, 1}}], {n, 4}]

GraphicsRow[pp]

Show[GraphicsRow[pp], ImageSize -> 450]

pt = Table[{pp[[k]]}, {k, Length[pp]}]; 

Show[GraphicsGrid[pt], ImageSize -> 100]

pp22 = {{pp[[1]], pp[[2]]}, {pp[[3]], pp[[4]]}}; p1 = Show[GraphicsGrid[pp22]]

Information["Spacings ", LongForm -> False]

graph1 = Plot[x^2, {x, -1, 1}]

graph2 = Plot[Sin[x], {x, 0, 4*Pi}, Ticks -> {Pi*Range[0, 4, 1/2], {-1, 0, 1}}]

graph3 = Plot[Sin[x], {x, 0, 4*Pi}, Ticks -> {Pi*Range[0, 4, 1/2], {-1, 0, 1}}, AspectRatio -> 0.7]; 

Show[GraphicsRow[{graph1, graph2}, Spacings -> {Scaled[0.1], Scaled[1]}]]

Show[GraphicsRow[{graph1, graph2}, Spacings -> {Scaled[0.5], Scaled[1]}]]

Get["PlotLegends`"]

th = Thick; , Null, Plot[{JacobiSN[t, 0.9], JacobiDN[t, 0.9], JacobiCN[t, 0.9]}, {t, 0, 10.}, PlotRange -> {{0, 10.5}, {-1.1, 1.1}}, PlotPoints -> 30, GridLines -> Automatic, AxesLabel -> {"u", "y"}, PlotStyle -> {{th, Dashing[{}]}, {th, Dashing[{0.03, 0.025, 0.005, 0.025}]}, {th, Dashing[{0.03}]}}, PlotLabel -> Style["Jacobian Elliptic Functions", 16], LegendPosition -> {1.1, -0.5}, ImageSize -> 580, PlotLegend -> {Style["y=sn u", 16], Style["y=dn u", 16], Style["y=cn u", 16]}]

Plot[{Sin[x], Cos[x]}, {x, -2*Pi, 2*Pi}, PlotStyle -> {GrayLevel[0], Dashing[{0.03}]}, PlotLegend -> (Style[#1, FontSize -> 16] & ) /@ {"sin x", "cos x"}, ImageSize -> 300]

p1 = Plot[{Sin[x], Cos[x]}, {x, -2*Pi, 2*Pi}, PlotStyle -> {GrayLevel[0], Dashing[{0.03}]}, PlotLegend -> {"Sine", "Cosine"}, LegendShadow -> None]; , Null, p2 = Plot[{Sin[x], Cos[x]}, {x, -2*Pi, 2*Pi}, PlotStyle -> {GrayLevel[0], Dashing[{0.03}]}, PlotLegend -> {"Sine", "Cosine"}, LegendShadow -> {-0.1, -0.1}]; , Null, p3 = Plot[{Sin[x], Cos[x]}, {x, -2*Pi, 2*Pi}, PlotStyle -> {GrayLevel[0], Dashing[{0.03}]}, PlotLegend -> {"Sine", "Cosine"}, LegendBorder -> Directive[Thick, Red]]; , Null, Show[GraphicsRow[{p1, p2, p3}], ImageSize -> 550]

HoldForm[{{TextCell["      ", "TableRowIcon"], Button[LegendPosition, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendPosition"], {-1, -1}, TextCell["position of legend in relation to graphic", "TableText"]}, {TextCell["      ", "TableRowIcon"], Button[LegendSize, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:PlotLegends/ref/LegendSize"], Button[Automatic, Inherited, BaseStyle -> "Link", ButtonData -> "paclet:ref/Automatic"], TextCell[Row[{"length of ", ExpressionCell[
