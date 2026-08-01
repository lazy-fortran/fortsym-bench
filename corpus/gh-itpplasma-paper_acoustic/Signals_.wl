Clear[fs]

fs[τv_] = τv + τg

τg = 3/4

Table[fs[v], {v, -τg, τg, τg}]

ev[τ_] = E^(-12.5*τ^2)

Clear[τ, evs]

evs[s_] = E^(-12.5*(s - τg)^2)

Plot[evs[s], {s, -1 + τg, 1 + τg}, PlotRange -> All]

subs = {τ -> s - τg}

uss[s_] = Cos[10*Pi*τ] /. subs

Plot[uss[s], {s, 0, 2*τg}, AxesLabel -> {"s", ""}]

ϵ

ev[τ_] = E^(-12.5*τ^2)

us[τ_] = Cos[10*Pi*τ]

fu[τ_] = UnitBox[2*(τ/3)]

tu[τ_] = ev[τ]*us[τ]*fu[τ]

subs = {τ -> -(3/4) + s}

evs[s_] = ev[τ] /. subs

uss[s_] = us[τ] /. subs

fus[s_] = fu[τ] /. subs

tus[s_] = tu[τ] /. subs

ess[s_] = evs[s]*uss[s]

uss[0]

uss[τg]

uss[2*τg]

tus[2*τg + ϵ]

tus[2*τg + 0.1]

tus[2*τg]

Plot[ess[s], {s, 0, 2*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 1.6, 0.1], Automatic}, PlotRange -> {0.8*{0, 2}, Automatic}, ImageSize -> 800]

ess[s]

ess[s - τ]

ess[s - τg]

Plot[ess[s - τg], {s, τg, 3*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 2*1.6, 0.1], Automatic}, PlotRange -> {0.8*{1, 3}, {-1, 1}}, ImageSize -> 800]

τg

fus[s_] = UnitBox[2*(τ/3)] /. subs

endls = {Line[{{0, 0}, {0, 1}}], Line[{{1.5, 0}, {1.5, 1}}]}

Plot[fus[s], {s, -1, 2.4}, PlotRange -> {{-1, 2.4}, {-0.1, 1.1}}, Epilog -> endls]

tus[s_] = fus[s]*ess[s]

Plot[tus[s], {s, 0, 2*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 1.6, 0.1], Automatic}, PlotRange -> {0.8*{0, 2}, Automatic}]

Plot[tus[s - τg], {s, τg, 3*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 2*1.6, 0.1], Automatic}, PlotRange -> {0.8*{0, 3}, Automatic}, ImageSize -> 800]

Plot[evs[s]*fus[s], {s, 0, 2*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 2.6, 0.1], Automatic}, PlotRange -> {0.8*{0, 2}, Automatic}]

Plot[evs[s], {s, 0, 2*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 2.6, 0.1], Automatic}, PlotRange -> {0.8*{0, 2}, Automatic}]

Plot[evs[s]*fus[s], {s, -τg, 3*τg}, AxesLabel -> {"s", ""}, PlotRange -> {0.8*{0, 2}, {-0.1, 1}}]

Plot[tus[s], {s, -τg, 3*τg}, AxesLabel -> {"s", ""}, AspectRatio -> 1, Ticks -> {Range[0, 1.6, 0.1], Automatic}, PlotRange -> {τg*{-1, 3}, {-1, 1}}, ImageSize -> 800]

tus[s]

Table[{s, tus[s]}, {s, 0, 1.5, 0.1}]

Table[{s, tus[s]}, {s, 0, 1.5, 0.01}]

ListLinePlot[%]

tus[0]

tus[0.75]

tus[1.5]

ϵ = 10.^(-12)

τg = 3/4

uss[s]

evs[s]

fus[s]

tus[s]

UnitStep[s - sp - ρ - ϵ]*(1/Sqrt[(s - sp)^2 - ρ^2 + ϵ])

intGa[s_, sf_, ρ_] := NIntegrate[tus[sp]*(UnitStep[-1.*^-12 + s - sp - ρ]/Sqrt[1.*^-12 + (s - sp)^2 - ρ^2]), {sp, 0, sf}]

tus[sp]

τg

UnitStep[-1.*^-12 + s - sp - ρ]/Sqrt[1.*^-12 + (s - sp)^2 - ρ^2] /. {sp -> 0, ρ -> 0, s -> 0}

1/Sqrt[-ρ^2 + (sp - τg)^2] /. {sp -> 0, ρ -> 0}

Table[UnitStep[-1.*^-12 + 1.5 - sp + 0.], {sp, 0, 1.5, 0.1}]

Table[Cos[10*Pi*(-(3/4) + sp)], {sp, 0, 1.5, 0.01}]

Table[tus[sp], {sp, 0, 1.5, 0.01}]

intGa[1.5, 1.5, 0.]

intGa[1.6, 1.5, 0.0001]

intGa[1.5, 1.5, 0.01]

intGa[1.5, 1.5, 0.45]

titg = Table[0, {i, 11}]

titg[[1]]*

titg[[1]] = Plot[intGa[100, 1.5, ρ], {ρ, 98.5, 100.}, PlotLabel -> "s = 100.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Red]

titg[[1]]

(* UNCONVERTED CELL *)

titg[[3]] = Plot[intGa[101, 1.5, ρ], {ρ, 99.5, 101.}, PlotLabel -> "s = 101.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Red, PlotRange -> 0.025*{-1, 1}]

(* UNCONVERTED CELL *)

tita[[4]]* = Plot[intGa[101.5, 1.5, ρ], {ρ, 100., 101.5}, PlotLabel -> "s = 101.5", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotRange -> 0.025*{-1, 1}, PlotStyle -> Red]

tus[sp]

intHa[s_, sf_, ρ_] := NIntegrate[(UnitBox[(2/3)*(-(3/4) + sp)]*Cos[10*Pi*(-(3/4) + sp)]*(UnitStep[-ϵ - Sqrt[(ρ - 200.)^2] + s - sp]/Sqrt[-(ρ - 200.)^2 + (s - sp)^2]))/E^(12.5*(-(3/4) + sp)^2), {sp, 0, sf}]

tus[100.5]

titH = Table[0, {i, 11}]

titH[[1]] = Plot[intHa[100., 1.5, ρ], {ρ, 98.5, 102.}, PlotLabel -> "s = 100.", AxesLabel -> {"ρ", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Blue, PlotRange -> 0.022*{-1, 1}]

titH[[2]] = Plot[intHa[100.5, 1.5, ρ], {ρ, 99, 101.5}, PlotLabel -> "s = 100.5", AxesLabel -> {"ρ", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Blue, PlotRange -> 0.022*{-1, 1}]

titH[[3]] = Plot[intHa[101., 1.5, ρ], {ρ, 99, 101.}, PlotLabel -> "s = 101.", AxesLabel -> {"ρ", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Blue, PlotRange -> 0.022*{-1, 1}]

titH[[4]] = Plot[intHa[101.5, 1.5, ρ], {ρ, 98.5, 101.5}, PlotLabel -> "s = 101.5", AxesLabel -> {"ρ", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Blue, PlotRange -> 0.022*{-1, 1}]

Show[titg[[1]], titH[[1]]]

Show[titg[[2]], titH[[2]]]

Show[titg[[3]], titH[[3]]]

titGH = Table[0, {i, 11}]

titg[[1]]* = Plot[intGa[100, 1.5, ρ], {ρ, 98.5, 100.}, PlotLabel -> "s = 100.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Red]

titGH[[1]] = Plot[intGa[100., 1.5, ρ] + intHa[100., 1.5, ρ], {ρ, 98.5, 101.5}, PlotLabel -> "s = 100.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.025*{-1, 1}]

titGH[[2]] = Plot[intGa[100.5, 1.5, ρ] + intHa[100.5, 1.5, ρ], {ρ, 98.7, 101.5}, PlotLabel -> "s = 100.5", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.025*{-1, 1}]

titGH[[3]] = Plot[intGa[101., 1.5, ρ] + intHa[101., 1.5, ρ], {ρ, 98.5, 101.5}, PlotLabel -> "s = 101.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.025*{-1, 1}]

titGH[[4]] = Plot[intGa[101.5, 1.5, ρ] + intHa[101.5, 1.5, ρ], {ρ, 98.5, 101.5}, PlotLabel -> "s = 101.5", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.035*{-1, 1}]

titGH[[5]] = Plot[intGa[102., 1.5, ρ] + intHa[102., 1.5, ρ], {ρ, 97., 102.5}, PlotLabel -> "s = 102.", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.025*{-1, 1}]

titGH[[6]] = Plot[intGa[102.5, 1.5, ρ] + intHa[102.5, 1.5, ρ], {ρ, 97., 102.5}, PlotLabel -> "s = 102.5", AxesLabel -> {"s", "p/\!\(\*SubscriptBox[\(p\), \(0\)]\)"}, PlotStyle -> Black, PlotRange -> 0.025*{-1, 1}]
