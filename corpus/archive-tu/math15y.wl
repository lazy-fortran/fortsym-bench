∂ f(x, t)         ∂ f(x, t)
HoldForm[$Version]                                                                                                                                                                                                                                   f]        -----------]        -----------]
                                                                                                                                                                                                                                                                  ∂ t               ∂ t
HoldForm["7.0 for Mac OS X x86 (64-bit) (February 19, 2009)"]                                                                                                                                                                                         HoldForm[           HoldForm[           HoldForm[A = {{a1, b1, c1, d1}, {a2, b2, c2, d2}, {a3, b3, c3, d3}}; , Null, B = Transpose[A]; ]

Clear[a, b, c, x]]                                                                                                                                                                                                                                                                   HoldForm[Export["test1.txt", Prepend[B, {"Spalte1", "Spalte2", "Spalte3"}], "Table"]; 

Print[a, b]; Print[c]]                                                                                                                                                                                                                                                               HoldForm[Export["test2.txt", B, "List"]; 

Do[Print[i, "  ", i^2], {i, 5}]]                                                                                                                                                                                                                                                     HoldForm[i1 = Derivative[1][y[x]]; i2 = Sin[x]; 

Print[TableForm[{{11, 2}, {3.141, 444}}]]]                                                                                                                                                                                                                                           HoldForm[i3 = Hold[Integrate[x^2, {x, 1, 2}]]; 

Print[MatrixForm[{{11, 2}, {3.141, -444}}]]]                                                                                                                                                                                                                                         HoldForm[Export["test3.txt", {i1, i2, i3}, "Lines"]; 

Print[Column[{11, 3.141, 444}]]]                                                                                                                                                                                                                                                     HoldForm[zz = N[RandomReal[{-99, 99}, {3, 5}], 6]

Print[Column[{11, 3.141, 444}, Left]]]                                                                                                                                                                                                                                               HoldForm[Export["zz.txt", zz, "Text"]

Print[Column[{11, 3.141, 444}, Center]]]                                                                                                                                                                                                                                             HoldForm[Export["zzt.txt", zz, "Table"]

Print[Column[{11, 3.141, 444}, Right]]]                                                                                                                                                                                                                                              HoldForm[zzs = {{-40.26066849685475, -97.16586911187056, -95.38992712488499, 78.01086305551189, 26.209569354568146}, {98.24543561601837, -38.442614834196036, -69.85730459204922, 26.28483009122988, 0.6726973742467521}, {-56.24646417038906, -67.59242501805886, -63.07203919468884, 89.04416998904975, 30.49052856339341}}

Information["Grid", LongForm -> True]]                                                                                                                                                                                                                                               HoldForm[FullForm[zzs]

Grid[{{a, b, c}, {x, y, z}}]]                                                                                                                                                                                                                                                        HoldForm[Export["zzs.txt", zzs]

Grid[{{a, b, c}, {x, y^2, z^3}}, Frame -> All]]                                                                                                                                                                                                                                      HoldForm[plo = Plot[{Sin[x], Sin[2*x]}, {x, 0, 2*Pi}, Ticks -> {{{Pi/2, "\!\(\*FractionBox[\(π\), \(2\)]\)"}, {Pi, "π"}, {3*(Pi/2), "\!\(\*FractionBox[\(3  π\), \(2\)]\)"}, {2*Pi, "2π"}}, 0.5*Range[-2, 2]}, AxesLabel -> {"x", "y"}, PlotStyle -> {Hue[0], Hue[0.6]}, TextStyle -> {FontSize -> 16}]

Table[(i + 44)^j, {i, 3}, {j, 3}]]                                                                                                                                                                                                                                                   HoldForm[Export["pic.pdf", plo]

TableForm[%]]                                                                                                                                                                                                                                                                        HoldForm[i1 = Import["test1.txt"]

Grid[%]]                                                                                                                                                                                                                                                                             HoldForm[i1 = Import["test1.txt", "Table"]

Column[Range[1, 15, 3]]]                                                                                                                                                                                                                                                             HoldForm[FullForm[i1]

Print[StringForm["x = ``, y = ``", a^2, b^2]]]                                                                                                                                                                                                                                       HoldForm[MatrixForm[Drop[Drop[i1, 1], -1]]

Print[Row[{"x = ", a^2, ", y = ", b^2}]]]                                                                                                                                                                                                                                            HoldForm[Det[%]

p = Print["Evaluating this won't make p into a string."]]                                                                                                                                                                                                                            HoldForm[FullForm[%]

Information["p"]]                                                                                                                                                                                                                                                                    HoldForm[FullForm[i2]

ou = {6.7^(-4), 6.7^6, 6.7^8}]                                                                                                                                                                                                                                                       HoldForm[i3 = ToExpression //@ Drop[i1, 1]

NumberForm[ou]]                                                                                                                                                                                                                                                                      HoldForm[FullForm[%]

ScientificForm[ou]]                                                                                                                                                                                                                                                                  HoldForm[i2 = Import["test1.txt", "Words"]

ScientificForm[ou, 3]]                                                                                                                                                                                                                                                               HoldForm[i2 = Import["test2.txt", "Lines"]

EngineeringForm[ou]]                                                                                                                                                                                                                                                                 HoldForm[MatrixForm[i2]

pp = N[Pi^10, 25]]                                                                                                                                                                                                                                                                   HoldForm[FullForm[i2]

NumberForm[pp, 12]]                                                                                                                                                                                                                                                                  HoldForm[i2e = ToExpression //@ i2

NumberForm[pp, {9, 2}]]                                                                                                                                                                                                                                                              HoldForm[FullForm[i2e]

EngineeringForm[%%, 12]]                                                                                                                                                                                                                                                             HoldForm[MatrixForm[i2e]

ScientificForm[%%%, 5]]                                                                                                                                                                                                                                                              HoldForm[Import["pic.pdf"]

NumberForm[N[Pi^4, 20], DigitBlock -> 5], Null, NumberForm[N[Pi^4, 20], DigitBlock -> 5, NumberSeparator -> " "]]                                                                                                                                                                    HoldForm[$Path

NumberForm[1.734565229876*^7, DigitBlock -> 5]]                                                                                                                                                                                                                                      HoldForm[Export["/Users/schnizer/test15.txt", {{2.5, 5, 8.}, {3., 4, 7.}}, "Table"]

l1 = {7.99*10^12, 5.3, 9.2/10^6, 2.44/10^15}; ]                                                                                                                                                                                                                                      HoldForm["/Users/schnizer/test15.txt"

NumberForm[l1, ExponentFunction -> (If[-10 < #1 < 10, Null, #1] & )]]                                                                                                                                                                                                                HoldForm[ip = Import["/Users/schnizer/test15.txt"]

NumberForm[l1, NumberFormat -> (Row[{#1, "E", #3}] & )]]                                                                                                                                                                                                                             HoldForm[ipp = ReadList["/Users/schnizer/test15.txt", {Number, Number, Number}]

Information["NumberPadding", LongForm -> True]]                                                                                                                                                                                                                                      HoldForm[SetDirectory["/Users/schnizer"]

NumberForm[1.23456789*^6, 10]]                                                                                                                                                                                                                                                       HoldForm[Export["testsch.txt", {{x1, x2, x3}, {y1, y2, y3}}, "Table"]

NumberForm[1.23456789*^6, 10, NumberPadding -> {"\t", ""}]]                                                                                                                                                                                                                          HoldForm[$Path

PaddedForm[1.23456789*^7, 10, NumberPadding -> {"\t", ""}]]                                                                                                                                                                                                                          HoldForm[Export["schnizer\\test15.txt", {{2.5, 5, 8}, {3, 4, 7}}, "Table"]

EngineeringForm[1.23456789*^7, 10, NumberPadding -> {"\t", ""}]]                                                                                                                                                                                                                     HoldForm["schnizer\\test15.txt"

ScientificForm[1.23456789*^7, 10, NumberPadding -> {"\t", ""}]]                                                                                                                                                                                                                      HoldForm[Export["test2.txt", {{x1, x2, x3}, {y1, y2, y3}}, "Table"]

Information["SignPadding", LongForm -> False]]                                                                                                                                                                                                                                       HoldForm[ !( !test2 . txt)

NumberForm[{-1.23, 2.46}, 5, NumberPadding -> {" ", " "}]]                                                                                                                                                                                                                           HoldForm[Accuracy /@ {123, 123/2, Sqrt[123], Pi, E, I}

NumberForm[{-1.23, 2.46}, 5, SignPadding -> True, NumberPadding -> {" ", " "}]]                                                                                                                                                                                                      HoldForm[$MachinePrecision

(Grid[#1, Frame -> All, Alignment -> Center] & )[(Prepend[#1, {Style["x", Bold], Style["100 Sin x", Bold]}] & )[Table[((NumberForm[#1, {6, 3}, NumberPadding -> {" ", "0"}] & ) /@ #1 & )[N[{x, 100*Sin[x]}]], {x, -Pi, Pi - Pi/8, Pi/8}]]]]                                         HoldForm[Accuracy /@ {1.618034, 21.618034, 321.618034}

Clear[a, b, c]]                                                                                                                                                                                                                                                                      HoldForm[Precision /@ {1.618034, 21.618034, 321.618034}

Set(f,a*b/c**2)]                                                                                                                                                                                                                                                                     HoldForm[Accuracy /@ {1.1234567890123456789012345678899999999999999999999999999999`29.050556373012924, 21.1234567890123456789012345678899999999999999999999999999999`30.324764990639604, 321.1234567890123456789012345678899999999999999999999999999999`31.50667203020667}

Column[FortranForm /@ l1]]                                                                                                                                                                                                                                                           HoldForm[Precision /@ {1.1234567890123456789012345678899999999999999999999999999999`29.050556373012924, 21.1234567890123456789012345678899999999999999999999999999999`30.324764990639604, 321.1234567890123456789012345678899999999999999999999999999999`31.50667203020667}

f = a*b/Power(c,2)]                                                                                                                                                                                                                                                                  HoldForm[Accuracy /@ {2.3451234567834987678`19.370165710670932*^19}

f=\frac{a b}{c^2}]                                                                                                                                                                                                                                                                   HoldForm[xp = 234.389879479373987397`20.369938855719987; 

ma = {{(1/4)*(-2*Subscript[α, 0] + Subscript[α, 2]), -((3*Subscript[α, 2])/(4*Sqrt[10]))}, {-((3*Subscript[α, 2])/(4*Sqrt[10])), (1/10)*(-5*Subscript[α, 0] - 2*Subscript[α, 2])}}; , Null, MatrixForm[ma]]                                                                    HoldForm[Precision[xp]

\text{ma}]                                                                                                                                                                                                                                                                           HoldForm[N[Pi^25, 30]

Clear[t, x], Null, f = x^3 + 5*x^2 - 2*x + 4]                                                                                                                                                                                                                                        HoldForm[Precision[%]

                                                                                                                                                                                                                                                                                     HoldForm[Precision[3.]

$MachinePrecision

Precision[3.]

N[Gamma[1/7], 30]

Precision[%]

N[Gamma[0.142], 30]

Precision[%]

N[Gamma[142/1000], 30]

Precision[%]

$MinPrecision

$MaxPrecision

lst = RandomReal[{0, 1}, 10]

lplst = (SetPrecision[#1, 20] & ) /@ lst

SetPrecision[0.3, 40]

x = SetPrecision[0.3`39.47712125471966, 40]

x^2

Accuracy[%]

Precision[%%]

k = N[Exp[-60], 20]

k1 = Evaluate[1 + k] - 1

$MinPrecision = $MaxPrecision = 20

k2 = Evaluate[1 + k] - 1

k1 - k2

$MinPrecision = $MaxPrecision = 40

k = N[Exp[-60], 40]

k3 = Evaluate[1 + k] - 1

k1 - k3

$MinPrecision = 50; 

$MinPrecision = $MaxPrecision = 50

xn = SetPrecision[0.3`49.47712125471967, 50]

Precision[%]

xn^2

Accuracy[%]

Precision[%%]
