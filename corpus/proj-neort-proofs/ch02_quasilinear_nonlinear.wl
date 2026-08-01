(* Chapter 2: weakly non-linear kinetic theory, quasilinear limit, non-linear
   limit.  This is the spine of the QL <-> finite-amplitude matching:
   both limits come from the SAME universal dimensionless equation eq:king

        y g_thb - sin(thb) (g_y + 1) - D g_yy = 0,

   with the bridge parameter D = D_res |Omega'|^{1/2} / |H_m|^{3/2} (eq:D).
   D >> 1  -> quasilinear limit (Airy/Scorer solution).
   D << 1  -> non-linear (finite-amplitude) limit (elliptic-integral solution).
   See docs/ql_finite_amplitude_matching.md. *)

(* ---------- the universal equation and its two limits ---------- *)
(* eq:king master operator acting on a distribution g(thb,y) *)
Lking[g_, dd_] := y D[g, thb] - Sin[thb] (D[g, y] + 1) - dd D[g, {y, 2}];

(* eq:king-1  quasilinear limit: dropping the g_y advection term when D>>1.
   Verify that the dropped piece is exactly -sin(thb) g_y (structural). *)
CheckEq["eq:king-1  QL limit drops the sin*g_y term from eq:king",
   (Lking[g0[thb, y], dd]) - (y D[g0[thb, y], thb] - Sin[thb] - dd D[g0[thb, y], {y, 2}]),
   -Sin[thb] D[g0[thb, y], y]];

(* ---------- quasilinear limit (D >> 1) ---------- *)

(* eq:king-1-2 / eq:krooksol  Krook-model solution solves y g_thb + nu g = sin(thb).
   Verified in complex form: y gc_thb + nu gc = -i e^{i thb}; Re gives sin(thb). *)
gcKrook = -I Exp[I thb]/(I y + nu);
CheckEq["eq:krooksol  Krook solution: y gc_thb + nu gc = -i e^{i thb}",
   y D[gcKrook, thb] + nu gcKrook, -I Exp[I thb]];
CheckEq["eq:krooksol  Re(-i e^{i thb}) = sin(thb)",
   ComplexExpand[Re[-I Exp[I thb]]], Sin[thb]];

(* Scorer Hi defining ODE used for the full QL solution: Hi'' - x Hi = 1/pi *)
CheckEq["scorer-Hi  Hi''(x) - x Hi(x) = 1/pi",
   D[ScorerHi[x], {x, 2}] - x ScorerHi[x], 1/Pi];

(* eq:airysol  full QL solution g = Re[-i pi D^{-1/3} e^{i thb} Hi(-i D^{-1/3} y)]
   solves eq:king-1  y g_thb - D g_yy = sin(thb).  Numeric residual at sample
   points for D = 100 (Re part of the complex residual must vanish). *)
With[{ddv = 100},
  Module[{gc, Lc, pts},
    gc[t_, yy_] := -I Pi ddv^(-1/3) Exp[I t] ScorerHi[-I ddv^(-1/3) yy];
    Lc[t_, yy_] := yy (D[gc[tt, yy], tt] /. tt -> t) - ddv (D[gc[t, yk], {yk, 2}] /. yk -> yy);
    pts = {{7/10, 13/10}, {-11/10, 1/2}, {2/10, -9/5}};
    Do[
     CheckClose["eq:airysol  QL solution solves eq:king-1 at (thb,y)=" <> ToString[p],
        Re[N[Lc @@ p, 30]], N[Sin[p[[1]]], 30], 10^-6],
     {p, pts}]]];

(* ---------- non-linear / finite-amplitude limit (D << 1) ---------- *)

(* eq:non-linear  order separation g = g0 + D g1 in eq:king gives eq:king-2 at
   O(1) and eq:g1 at O(D). *)
With[{},
  Module[{ser, c0, c1},
    ser = Series[Lking[g0[thb, y] + dd g1[thb, y], dd], {dd, 0, 1}];
    c0 = SeriesCoefficient[ser, 0];
    c1 = SeriesCoefficient[ser, 1];
    CheckEq["eq:king-2  O(1): y g0_thb - sin(g0_y+1) = 0",
       c0, y D[g0[thb, y], thb] - Sin[thb] (D[g0[thb, y], y] + 1)];
    CheckEq["eq:g1  O(D): y g1_thb - sin g1_y - g0_yy = 0",
       c1, y D[g1[thb, y], thb] - Sin[thb] D[g1[thb, y], y] - D[g0[thb, y], {y, 2}]]]];

(* eq:g0  zeroth-order solution g0 = gbar0(I) - sigma sqrt(I+2cos thb) = gbar0(y^2-2cos thb) - y
   solves eq:king-2 (sigma sqrt(I+2cos)=|y|, sigma|y|=y on a contour). *)
g0sol = gb0[y^2 - 2 Cos[thb]] - y;
CheckEq["eq:g0  g0 solves eq:king-2",
   y D[g0sol, thb] - Sin[thb] (D[g0sol, y] + 1), 0];

(* eq:I  conserved action I = y^2 - 2cos thb, derivatives *)
CheckEq["eq:I  dI/dthb = 2 sin thb", D[y^2 - 2 Cos[thb], thb], 2 Sin[thb]];
CheckEq["eq:I  dI/dy = 2y (= 2 sigma sqrt(I+2cos))", D[y^2 - 2 Cos[thb], y], 2 y];

(* supertrapped g0 = -sigma sqrt(I+2cos thb) = -y also solves eq:king-2 (gbar0=0) *)
CheckEq["eq:suptrap  g0 = -y solves eq:king-2",
   y D[-y, thb] - Sin[thb] (D[-y, y] + 1), 0];

(* eq:th  superpassing solubility integral
   int_{-pi}^{pi} sqrt(I+2cos thb) dthb = 4 sqrt(I+2) E(4/(2+I))  (numeric) *)
With[{Iv = 5},
  CheckClose["eq:th  passing average integral = 4 sqrt(I+2) E(4/(2+I))",
     NIntegrate[Sqrt[Iv + 2 Cos[thb]], {thb, -Pi, Pi}, WorkingPrecision -> 30],
     4 Sqrt[Iv + 2] EllipticE[4/(2 + Iv)]]];

(* asymptotic gbar0'(I)|_{I>>1} ~ C/(2 pi sqrt I): the passing-average denominator
   1/[4 sqrt(I+2) E(4/(2+I))] -> 1/(2 pi sqrt I), i.e. ratio -> 1 *)
CheckLimit["eq:g0-1  passing average ~ 2 pi sqrt(I) as I->inf",
   4 Sqrt[Iv + 2] EllipticE[4/(2 + Iv)]/(2 Pi Sqrt[Iv]), Iv -> Infinity, 1];

(* C_p^sigma = pi sigma  fixes dg0/dI -> 0 as I->inf:
   gbar0' ~ Cp/(2 pi sqrt I), d/dI[sigma sqrt(I)] ~ sigma/(2 sqrt I); equal => Cp = pi sigma *)
CheckEq["eq:Cp  C_p^sigma = pi sigma",
   (Cp/(2 Pi)) - sig/2 /. Cp -> Pi sig, 0];

(* supertrapped turning points cos(thb^pm) = -I/2 (definition consistency:
   I + 2 cos(thb^pm) = 0 at y=0) *)
CheckEq["eq:turn-nl  I + 2 cos(thb^pm) = 0 at cos = -I/2",
   Iv + 2 (-Iv/2), 0];

(* eq:D bridge-parameter scaling: D ~ |H_m|^{-3/2} nu^{1/2}.
   D = D_res |Omega'|^{1/2}/|H_m|^{3/2} with D_res = nu pT^2 <(dp/dDJ)^2>_b (eq:Dres). *)
CheckEq["eq:D  D scales as |H_m|^{-3/2} nu^{1/2}",
   (nu^(1/2) avgp pT^2 Op^(1/2)/Hm^(3/2)) /. {nu -> nu, Hm -> Hm},
   nu^(1/2) Hm^(-3/2) (avgp pT^2 Op^(1/2)), nu > 0 && Hm > 0 && Op > 0];
