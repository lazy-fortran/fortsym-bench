sqg := r*(Subscript[R, 0] + r*Cos[ϑ]), Null, Subscript[B, φ] := Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[ϑ])^2), Null, psidot = (1/(2*Pi))*Integrate[sqg*Subscript[B, φ], {ϑ, 0, 2*Pi}, Assumptions -> r > 0 && Subscript[R, 0] > r]

dnudth := sqg*Subscript[B, φ], Null, dpsitildedth = dnudth - psidot, Null

nt2 = Integrate[dpsitildedth, ϑ, Assumptions -> {r > 0, Subscript[R, 0] > r, -Pi < ϑ < Pi}]

(nutilde := (-r)*Subscript[R, 0]*Subscript[B, 0]*((ϑ + 2*ArcTan[((r - Subscript[R, 0])*Tan[ϑ/2])/Sqrt[Subscript[R, 0]^2 - r^2]])/Sqrt[Subscript[R, 0]^2 - r^2]))*With[{y1 = nt2, y2 = nutilde}, Manipulate[Plot[{y1, y2}, {ϑ, -Pi, Pi}], {{r, 0.5}, 0, 0.99}, {Subscript[R, 0], 2}, {Subscript[B, 0], 2}]]

Subscript[ϑ, f] = FullSimplify[ϑ + nutilde/psidot, -Pi < ϑ < Pi]

FullSimplify[Solve[Subscript[ϑ, f] == thf, ϑ]]

thfofth[r_, R0_, th_] := -2*ArcTan[((r - R0)*Tan[th/2])/Sqrt[-r^2 + R0^2]], Null, thofthf[r_, R0_, thf_] := -2*ArcCot[(Cot[thf/2]*(r - R0))/Sqrt[-r^2 + R0^2]], Null, FullSimplify[thfofth[r, R0, thofthf[r, R0, thf]], -Pi < thf < Pi], Null, FullSimplify[thofthf[r, R0, thfofth[r, R0, th]], -Pi < th < Pi]

Manipulate[Plot[{thfofth[r, Subscript[R, 0], ϑ], thofthf[r, Subscript[R, 0], ϑ]}, {ϑ, -Pi, Pi}], {{r, 0.5}, 0.001, 0.999}, {Subscript[R, 0], 2}]

th2dr = FullSimplify[D[Subscript[ϑ, f], r]]

dthfdr[r_, R0_, thf_] := -((R0*Sin[thf])/(-r^2 + R0^2)), Null, FullSimplify[dthfdr[r, Subscript[R, 0], thf] - (th2dr /. ϑ -> thofthf[r, Subscript[R, 0], thf]), Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

th2dth = FullSimplify[D[Subscript[ϑ, f], ϑ], Reals]

dthfdth[r_, R0_, thf_] := (R0 - r*Cos[thf])/Sqrt[-r^2 + R0^2], Null, FullSimplify[dthfdth[r, Subscript[R, 0], thf] - (th2dth /. ϑ -> thofthf[r, Subscript[R, 0], thf]), Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

Ji = FullSimplify[{{1, 0, 0}, {0, 1, 0}, {dthfdr[r, Subscript[R, 0], thf], 0, dthfdth[r, Subscript[R, 0], thf]}}, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r], Null, J = FullSimplify[Inverse[Ji], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r], Null

FullSimplify[{D[thofthf[r, Subscript[R, 0], thf], r], D[thofthf[r, Subscript[R, 0], thf], thf]}]

FullSimplify[2*(((r - Subscript[R, 0])*Tan[th/2])/Sqrt[-r^2 + Subscript[R, 0]^2]/(1 + (((r - Subscript[R, 0])*Tan[th/2])/Sqrt[-r^2 + Subscript[R, 0]^2])^2))]

Manipulate[Plot[{(Sin[2*ArcTan[((r - Subscript[R, 0])*Tan[th/2])/Sqrt[-r^2 + Subscript[R, 0]^2]]]*Subscript[R, 0])/(-r^2 + Subscript[R, 0]^2), -((Sin[th]*Subscript[R, 0])/((r*Cos[th] + Subscript[R, 0])*Sqrt[-r^2 + Subscript[R, 0]^2])), -(((Subscript[R, 0]/(-r^2 + Subscript[R, 0]^2))*Sin[th]*Sqrt[-r^2 + Subscript[R, 0]^2])/(r*Cos[th] + Subscript[R, 0]))}, {th, -2*Pi, 2*Pi}], {{r, 0.5}, 0, 1}, {{Subscript[R, 0], 1}, 0, 2}]

grr = FullSimplify[1 + r^2*J[[3,1]]^2, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

grth = FullSimplify[r^2*J[[3,1]]*J[[3,3]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

gthth = FullSimplify[r^2*J[[3,3]]^2, Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

FullSimplify[gthth*Ji[[3,1]]*Ji[[3,3]]]

TrigReduce[(r^2*Sin[thf]*Subscript[R, 0])/((r*Cos[thf] - Subscript[R, 0])*Sqrt[-r^2 + Subscript[R, 0]^2])]

Rff = FullSimplify[Subscript[R, 0] + r*Cos[thofthf[r, Subscript[R, 0], thf]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

Rfa = FullSimplify[r*((1/Sqrt[1/((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])^2 + 1])^2 - (1/(((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])*Sqrt[1/((Cot[thf/2]*(r - Subscript[R, 0]))/Sqrt[-r^2 + Subscript[R, 0]^2])^2 + 1]))^2) + Subscript[R, 0]]

Rf := (r^2 - Subscript[R, 0]^2)/(r*Cos[thf] - Subscript[R, 0])

Plot[{Rf, Rff} /. {Subscript[R, 0] -> 2, r -> 1}, {thf, -Pi, Pi}]

gij = {{grr, 0, grth}, {0, Rf^2, 0}, {grth, 0, gthth}}

sqgf = FullSimplify[Sqrt[Det[gij]], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r]

Bphtest := Subscript[B, 0]*(Subscript[R, 0]/Rf^2), Null, sqgtest = FullSimplify[psidot/Bphtest]

With[{y1 = sqgf, y2 = sqgtest}, Manipulate[Plot[{y1, y2}, {thf, -Pi, Pi}], {{Subscript[R, 0], 1}, 0, 2}, {{r, 0.5}, 0, Subscript[R, 0]}, {Subscript[B, 0], 1}]]

With[{y1 = sqg /. ϑ -> thofthf[r, Subscript[R, 0], thf], y2 = sqgf}, Manipulate[Plot[{y1, y2}, {r, 0, 1}], {Subscript[R, 0], 1.1}, {{thf, 0}, -Pi, Pi}]]

With[{y1 = 1, y2 = (Subscript[R, 0] + r*Cos[thofthf[r, Subscript[R, 0], thf]])^2, y3 = gthth, y4 = grth, y5 = sqgf^2}, Manipulate[Plot[{y1, y2, y3, y4, y5}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {{r, 0.5}, 0, 1}]]

With[{y1 = 1, y2 = (Subscript[R, 0] + r*Cos[ϑ])^2, y3 = gthth /. thf -> thfofth[r, Subscript[R, 0], ϑ], y4 = grth /. thf -> thfofth[r, Subscript[R, 0], ϑ], y5 = sqgf^2 /. thf -> thfofth[r, Subscript[R, 0], ϑ]}, Manipulate[Plot[{y1, y2, y3, y4, y5}, {ϑ, -Pi, Pi}], {Subscript[R, 0], 1}, {{r, 0.5}, 0, 1}]]

With[{y1 = 1, y2 = (Subscript[R, 0] + r*Cos[ϑ])^2, y3 = r^2, y4 = 0, y5 = sqg^2}, Manipulate[Plot[{y1, y2, y3, y4}, {ϑ, -Pi, Pi}], {Subscript[R, 0], 1}, {{r, 0.5}, 0, 1}]]

With[{y1 = sqg /. ϑ -> thofthf[r, Subscript[R, 0], thf], y2 = sqgf}, Manipulate[PolarPlot[{y1, y2}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {{r, 0.5}, 0, 1}]]

Bth0 := Subscript[R, 0]/(r*(Subscript[R, 0] + r*Cos[ϑ])), Null, Bth1 := Subscript[R, 0]/g

Bph0 := Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[ϑ])^2)

Bph1 = FullSimplify[psidot/(sqgf /. thf -> thfofth[r, Subscript[R, 0], ϑ])]

With[{y1 = Bph0, y2 = Bph1}, Manipulate[Plot[{y1, y2}, {ϑ, -Pi, Pi}], {Subscript[R, 0], 2}, {Subscript[B, 0], 2}, {{r, 0.5}, 0, 1}]]

Bph2 = Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[thofthf[r, Subscript[R, 0], thf]])^2)

With[{y1 = Bph2, y2 = psidot/sqgf}, Manipulate[PolarPlot[{y1, y2}, {thf, -Pi, Pi}], {Subscript[R, 0], 2}, {Subscript[B, 0], 1}, {{r, 0.5}, 0, 1}]]

Bph = Subscript[B, 0]*(Subscript[R, 0]/(Subscript[R, 0] + r*Cos[th])^2), Null, Bth = Bph*((Subscript[R, 0] + r*Cos[th])/(Subscript[R, 0]*qa))

Btot0 = FullSimplify[Sqrt[(Subscript[R, 0] + r*Cos[th])^2*Bph^2 + r^2*Bth^2]]

With[{y1 = Btot0}, Manipulate[PolarPlot[y1, {th, -Pi, Pi}], {Subscript[R, 0], 1}, {Subscript[B, 0], 1}, {{qa, 3}, 2, 4}, {{r, 0.5}, 0, 1}]]

Bph2 := Subscript[B, 0]*(Subscript[R, 0]/Rf^2), Null, Bth2test := Bth*th2dth /. {ϑ -> thofthf[r, Subscript[R, 0], thf], th -> thofthf[r, Subscript[R, 0], thf]}, Null, Bth2 := Bph2/qa, Null, FullSimplify[Bth2test/Bth2]

Btot1 = FullSimplify[Sqrt[Rf^2*Bph2^2 + gthth*Bth2^2], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r && qa > 0]

Btot2 = FullSimplify[Sqrt[Rf^2*(Subscript[B, 0]*(Subscript[R, 0]/Rf^2))^2 + r^2*((Subscript[B, 0]*(Subscript[R, 0]/Rf^2))/(Sqrt[Subscript[R, 0]^2 - r^2]*(qa/Rf)))^2], Reals && -Pi < thf < Pi && r > 0 && Subscript[R, 0] > r && qa > 0]

FullSimplify[Btot1/Btot2]

With[{y1 = Btot1, y2 = Btot2}, Manipulate[PolarPlot[{y1, y2}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {Subscript[B, 0], 1}, {{qa, 3}, 2, 4}, {{r, 0.5}, 0, 1}]]

Bpha := Subscript[B, 0]*(Subscript[R, 0]/Rf^2), Null, Btha := Bpha*(Rf/(Sqrt[Subscript[R, 0]^2 - r^2]*qa))

Bthat = FullSimplify[Btha*dthfdth[r, Subscript[R, 0], thf]]

Bthatest = FullSimplify[psidot/(qa*sqgf)]

With[{y1 = Bthat, y2 = Bthatest}, Manipulate[PolarPlot[{y1, y2}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {Subscript[B, 0], 1}, {{qa, 3}, 2, 4}, {{r, 0.5}, 0, 1}]]

Bphatest := FullSimplify[psidot/sqgf]

With[{y1 = Bpha, y2 = Bphatest}, Manipulate[PolarPlot[{y1, y2}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {Subscript[B, 0], 1}, {{r, 0.5}, 0, 1}]]

Subscript[B, ϑ] = FullSimplify[r*(Subscript[B, 0]/(Sqrt[Subscript[R, 0]^2 - r^2]*qa))*(Subscript[R, 0]/(r*(Subscript[R, 0] + r*Cos[ϑ])))]

Btot3 = FullSimplify[Sqrt[FullSimplify[(Subscript[R, 0] + r*Cos[ϑ])^2*Subscript[B, φ]^2 + r^2*Subscript[B, ϑ]^2]], qa > 0 && r > 0 && Subscript[R, 0] > r && Subscript[B, 0] > 0]

With[{y1 = Btot1, y2 = Btot2, y3 = Btot3 /. ϑ -> thofthf[r, Subscript[R, 0], thf]}, Manipulate[PolarPlot[{y1, y2, y3}, {thf, -Pi, Pi}], {Subscript[R, 0], 1}, {Subscript[B, 0], 1}, {{qa, 3}, 2, 4}, {{r, 0.5}, 0, 1}]]
