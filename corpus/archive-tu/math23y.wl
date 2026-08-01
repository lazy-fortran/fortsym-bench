$Version

BeginPackage["SinSer`"]*SinSer::usage = " Series expansion for Sin[x]."*Begin["Private`"]*SinSer[x_, n_] := Module[{i}, Print[Sum[I*(((-I)*x)^i/(2*i - 1)!), {i, 1, n, 2}]]]*End[]*EndPackage[]

SinSer[x, 5]

SinSer[0.1, 5]

Sin[0.1]

BeginPackage["SinSer`"]*SinSerr::usage = "Series expansion for Sin[x]  ."*Begin["Private`"]*SinSerr[x_, n_] := Module[{i, a[1] = 1, a[3] = -6^(-1), a[5] = 1/120}, Sum[a[i]*x^i, {i, 1, n, 2}]]*End[]*EndPackage[]

SinSerr[x, 5]

points = Table[N[x + I*y], {x, -Pi/2, Pi/2, Pi/14}, {y, -1, 1, 2/10}]; Short[points, 3]

coords = Map[{Re[#1], Im[#1]} & , points, {2}]; Short[coords, 3]

vlines = Line /@ coords; 

Short[FullForm[vlines], 13]

hlines = Line /@ Transpose[coords]; 

Show[Graphics[Join[vlines, hlines]]]

points = Table[N[(x + I*y)^2], {x, -1, 1, 2/10}, {y, -1, 1, 2/10}]; coords = Map[{Re[#1], Im[#1]} & , points, {2}]; lines = Line /@ Join[coords, Transpose[coords]]; 

pv = Show[Graphics[lines], Axes -> Automatic]

points = Table[N[Sin[x + I*y]], {x, -(Pi/2), Pi/2, Pi/14}, {y, -1, 1, 2/10}]; coords = Map[{Re[#1], Im[#1]} & , points, {2}]; lines = Line /@ Join[coords, Transpose[coords]]; Show[Graphics[lines], Axes -> Automatic]

CartesianMap[func_, {x0_, x1_, dx_}, {y0_, y1_, dy_}] := Module[{x, y, coords, ulines, vlines}, coords = Table[N[func[x + I*y]], {x, x0, x1, dx}, {y, y0, y1, dy}]; coords = Map[{Re[#1], Im[#1]} & , coords, {2}]; ulines = Line /@ coords; vlines = Line /@ Transpose[coords]; Show[Graphics[Join[ulines, vlines], AspectRatio -> Automatic, Axes -> Automatic]]]

ve = CartesianMap[Exp, {0, 3, 0.3}, {-3, 3, Pi/20}]; 

vs = CartesianMap[Sqrt, {0, Pi, Pi/15}, {-2, 2, 4/16}]; 

Show[GraphicsRow[{ve, vs}]]

CartesianMap[#1^2 & , {0, Pi, Pi/15}, {-2, 2, 4/16}]

BeginPackage["MyCartesianMap`"]*MyCartesianMap::usage = "MyCartesianMap[f, {x0,x1,dx}, {y0,y1,dy}]\n   plots the image of the cartesian coordinate lines under\n   the function  f."*Begin["`Private`"]*MyCartesianMap[func_, {x0_, x1_, dx_}, {y0_, y1_, dy_}] := Module[{x, y, coords, lines}, coords = Table[N[func[x + I*y]], {x, x0, x1, dx}, {y, y0, y1, dy}]; coords = Map[{Re[#1], Im[#1]} & , coords, {2}]; lines = Line /@ Join[coords, Transpose[coords]]; Show[Graphics[lines], AspectRatio -> Automatic, Axes -> Automatic]]*End[]*EndPackage[]

Context[MyCartesianMap]

$ContextPath

points = Table[N[r*Exp[I*phi]], {r, 0, 1, 0.1}, {phi, 0, 2*Pi, (2*Pi)/24}]; coords = Map[{Re[#1], Im[#1]} & , points, {2}]; vlines = Line /@ coords; hlines = Line /@ Transpose[coords]; Show[Graphics[Join[hlines, vlines]], AspectRatio -> Automatic]

BeginPackage["MyComplexMap`"]*MyCartesianMap::usage = "MyCartesianMap[f, {x0,x1,dx},{y0,y1,dy}]\n   plots the image of the cartesian coordinate lines under\n   the function  f."*MyPolarMap::usage = "MyPolarMap[f, {r0,r1,dr}, {phi0,phi1,dphi}]\n   plots the image of the polar coordinate lines under the\n   function f."*Begin["`Private`"]*MakeLines[points_] := Module[{coords, lines}, coords = Map[{Re[#1], Im[#1]} & , points, {2}]; lines = Line /@ Join[coords, Transpose[coords]]; Graphics[lines]]*MyCartesianMap[func_, {x0_, x1_, dx_}, {y0_, y1_, dy_}] := Module[{x, y, coords}, coords = Table[N[func[x + I*y]], {x, x0, x1, dx}, {y, y0, y1, dy}]; Show[MakeLines[coords], AspectRatio -> Automatic, Axes -> Automatic]]*MyPolarMap[func_, {r0_, r1_, dr_}, {phi0_, phi1_, dphi_}] := Module[{r, phi, coords}, coords = Table[N[func[r*Exp[I*phi]]], {r, r0, r1, dr}, {phi, phi0, phi1, dphi}]; Show[MakeLines[coords], AspectRatio -> Automatic, Axes -> Automatic]]*End[]*EndPackage[]

MyPolarMap[#1 & , {0, 1, 0.1}, {-Pi, Pi, Pi/8}]

MyPolarMap[(-I)*((#1 + 1)/(#1 - 1)) & , {0, 1, 0.1}, {-Pi, Pi, Pi/8}]

mp = MyPolarMap[(-I)*((#1 + 1)/(#1 - 1)) & , {0.0001, 1 + 0.0001, 0.1}, {-Pi, Pi, Pi/8}]; , Null, Show[mp, PlotRange -> {0, 4}]

MyCartesianMap[(Exp[#1] - 1)/(Exp[#1] + 1) & , {-Pi/2, Pi/2, Pi/16}, {-Pi, Pi, Pi/16}]

ny = MyCartesianMap[(Exp[#1] - 1)/(Exp[#1] + 1) & , {-Pi/2, Pi/2, Pi/16}, {-Pi, Pi, Pi/16}]; Show[ny, PlotRange -> {4*{-1, 1}, 3*{-1, 1}}, ImageSize -> 450]

ParametricPlot[Through[{Re, Im}[Exp[x + I*y]]], {x, -1, 1}, {y, -2, 2}, PlotStyle -> None, ImageSize -> 200]

ParametricPlot[Through[{Re, Im}[Sqrt[r*Exp[I*t]]]], {r, 0, 1}, {t, 0, 2*Pi}, PlotStyle -> None, ImageSize -> 200]

ParametricPlot[Through[{Re, Im}[x + I*y + 1 + Exp[x + I*y]]], {x, -3*Pi, 0.6*Pi}, {y, -Pi, Pi}]

ParametricPlot[Through[{Re, Im}[x + I*y + 1 + Exp[x + I*y]]], {x, -3*Pi, 0.6*Pi}, {y, -Pi, Pi}, PlotStyle -> None]

fc = -Conjugate[2*I*Sqrt[Exp[x + I*y] - 1] - Log[(1 + I*Sqrt[Exp[x + I*y] - 1])/(1 - I*Sqrt[Exp[x + I*y] - 1])]]; 

c1 = ListPlot[{{-5, 0}, {0, 0}, {0, 7}}, Joined -> True, PlotStyle -> {Black, Thick}]; , Null, c2 = ListPlot[N[{{-5, -Pi}, {9, -Pi}}], Joined -> True, PlotStyle -> {Black, Thick}]; 

ParametricPlot[Through[{Re, Im}[fc]], {x, -5, 3}, {y, 0.0001, Pi}, PlotStyle -> None]

conf = ParametricPlot[Through[{Re, Im}[fc]], {x, -5, 3}, {y, 0.0001, Pi}, PlotStyle -> None]; , Null, Show[conf, c1, c2, Axes -> None]
