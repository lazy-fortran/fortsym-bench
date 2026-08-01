$Version

x = Pi

f[x_] = Sin[a*x]

Sum[x, {x, 3}]

x

t = 17

Module[{t}, t = 8; Print[t]]

t

Remove[f, v, a, b]

f[v_] := Module[{t}, t = (1 + v)^2; Expand[t]]

f[a + b]

t

Expand[(1 + t)^3]

FullForm[%]

Head[%%]

Length[Expand[(1 + t)^3]]

Module[{t}, Length[Expand[(1 + t)^3]]]

fac3[k_] := Module[{f, n}, f[1] = 1; f[n_] := k + n*f[n - 1]; f[3]]

fac3[0]

fac3[Pi]

p = 33

Module[{t}, t = 8 + p; Print[t]]

Module[{t, p}, t = 8 + p; Print[t]]

p

t = 17

facn[u_] := Module[{t = u}, f[1] = 1; f[n_] := t + n*f[n - 1]; f[3]]

facn[Pi]

Clear[g]; Remove[g]; g[u_] := Module[{t = u}, t += t/(1 + u)]

g[a]

Module[{t = 6, u = t}, u^2]

17^2

Module[{t}, Print[t]]

Module[{t, u}, Print[t]; Print[u]]

$ModuleNumber

t

Module[{t, u}, Print[t]; Print[u]]

Clear[x, t, a]

x^2 + 3

Block[{x = a + 1}, %]

x

t = 17

Module[{t}, Print[t]]

t

Block[{t}, Print[t]]

la = {33, 17}; 

Block[{t}, Print[la[[1]]*t^2 + la[[2]]*t + 7]]

%

Block[{t}, la[[1]]*t^2 + la[[2]]*t + 7]

la[[1]]*t^2 + la[[2]]*t + 7

Block[{}, Print[la[[1]]*t^2 + la[[2]]*t + 7]]

Block[{t = 6}, Print[la[[1]]*t^2 + la[[2]]*t + 7]]

t

Block[{t}, t = 6; la[[1]]*t^2 + la[[2]]*t + 7]

t

li1 = {1.1, 2.2, 3.5, 4.3}; , Null, li2 = {0, 1.5, 2.5, 3.2, 5}; , Null, li = {li1, li2}; 

fi[nnn_] := Block[{t}, gr1 = ListPlot[li[[nnn]]]; gf = Fit[li[[nnn]], {1, t, t^2, t^3}, t]; gr2 = Plot[gf, {t, 1, 5}, PlotStyle -> Hue[nnn*0.3]]; Show[gr1, gr2]]

fi[2]

t

t

Clear[u, x]; u := x^2 + t^2

u

Block[{t = 5}, u + 7]

x^2 + 25 + 7

u

Block[{t = 5, u}, u + 7]

Block[{t = 5}, u + 7]

Block[{t}, u + 7]

x^2 + 17^2 + 7

u

Module[{t = 5}, u + 7]

Module[{t, u}, u + 7]

Module[{t = 2, u}, u + 7]

t = 17

Expand[(1 + t)^3]

Length[Expand[(1 + t)^3]]

FullForm[Expand[(1 + t)^3]]

Head[%]

Module[{t}, Length[Expand[(1 + t)^3]]]

FullForm[Expand[(1 + x)^3]]

Block[{t}, Length[Expand[(1 + t)^3]]]

FullForm[Module[{t}, Expand[(1 + t)^3]]]

FullForm[Block[{t}, Expand[(1 + t)^3]]]

FullForm[Block[{x}, Expand[(1 + x)^3]]]

FullForm[Block[{x = t}, Expand[(1 + x)^3]]]

a`x

aaa`x

%^2 - %

a`b`x

$Context

{x, x}

$ContextPath

Context[Pi]

Contexts[]

SetDirectory[ToFileName[Extract["FileName" /. NotebookInformation[EvaluationNotebook[]], {1}, FrontEnd`FileName]]]

x1 = 2; x2 = 3; x3 = 4; x4 = 5; y = 7; z = 19; 

z

Clear["@"]

a

z

N[Pi]

Information["*", LongForm -> False]

$Version, Null, cmdList = Names["*"]; , Null, Length[cmdList]

Needs["Combinatorica`"]

V = 5

V

Unprotect["Combinatorica`*"]; 

Remove["Combinatorica`*"]

V = 5

PowerSum[x_, n_] := Sum[x^i, {i, 1, n}]

PowerSum[y, 5]

PowerSum[i, 5]

SerSum[x_, n_] := Sum[a[i]*x^i, {i, 1, n}]

SerSum[y, 5]

SerSum[i, 5]

SerSum[n, 5]

Context[i]

$Context

$ContextPath

PowerSumm[x_, n_] := Module[{i}, Sum[x^i, {i, 1, n}]]

PowerSumm[i, 5]

PowerSumb[x_, n_] := Block[{i}, Sum[x^i, {i, 1, n}]]

PowerSumb[i, 5]

Remove[i]; PowerSumb[i, 5]

PowerSummi::usage = "this function returns the first   n  \n\tpowers of  x .\t"*Begin["Private`"]*PowerSummi[x_, n_] := Module[{i}, Sum[x^i, {i, 1, n}]]*End[]

Context[i]

Contexts[]

SerSummp::usage = "  "*Begin["Private`"]*SerSummp[x_, n_] := Module[{i}, Sum[a[i]*x^i, {i, 1, n}]]*End[]

SerSummp[i, 5]

SerSumbp::usage = "  "*Begin["Private`"]*SerSumbp[x_, n_] := Block[{i}, Sum[a[i]*x^i, {i, 1, n}]]*End[]

Remove[i]; SerSumbp[i, 5]

Contexts[]

a[1] = Pi

FunSer[func_, x_, n_] := Module[{i}, Sum[a[i]*func[i*x], {i, 1, n}]]

FunSer[Cos, x, 5]

FunSerm[func_, x_, n_] := Module[{i, a}, Sum[a[i]*func[i*x], {i, 1, n}]]

FunSerm[Cos, x, 5]

FunSerb[func_, x_, n_] := Block[{i, a}, Sum[a[i]*func[i*x], {i, 1, n}]]

FunSerb[Cos, x, 5]
