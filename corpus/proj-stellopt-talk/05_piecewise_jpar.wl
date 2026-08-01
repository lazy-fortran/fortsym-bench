(* Slide 5: piecewise omnigenity. J_par(alpha) piecewise-constant on two
   field-line-label regions P1 = (0,1), P2 = (1,2) with J1 != J2.
   Verify: dJ/dalpha = 0 in the interior of each region (so the
   bounce-averaged radial drift <psidot> ~ -dJ/dalpha vanishes there),
   while J jumps across the region boundary alpha = 1. *)

failed = 0;
check[name_String, cond_] := Module[{ok = TrueQ[cond]},
    Print[If[ok, "PASS: ", "FAIL: "], name];
    If[! ok, failed++]; ok];

(* ---------- symbolic, with formal constants j1 != j2 ---------- *)
jp[a_] := Piecewise[{{j1, 0 < a < 1}, {j2, 1 < a < 2}}, Indeterminate];
djp[a_] = D[jp[a], a];

check["interior P1: dJ/dalpha = 0 at alpha = 1/4",
    (djp[1/4]) === 0];
check["interior P1: dJ/dalpha = 0 at alpha = 3/4",
    (djp[3/4]) === 0];
check["interior P2: dJ/dalpha = 0 at alpha = 3/2",
    (djp[3/2]) === 0];
check["interior P2: dJ/dalpha = 0 at alpha = 9/5",
    (djp[9/5]) === 0];

limLeft = Limit[jp[a], a -> 1, Direction -> "FromBelow"];
limRight = Limit[jp[a], a -> 1, Direction -> "FromAbove"];
check["left limit at boundary equals J1", limLeft === j1];
check["right limit at boundary equals J2", limRight === j2];
check["jump across boundary is J2 - J1 (nonzero whenever J1 != J2)",
    Simplify[limRight - limLeft - (j2 - j1)] === 0];

(* ---------- concrete values: J1 = 1, J2 = 3/2 ---------- *)
vals = {j1 -> 1, j2 -> 3/2};
check["concrete case: J discontinuous across alpha = 1 (J1 != J2)",
    (limLeft /. vals) =!= (limRight /. vals)];

(* no secular drift within each region: <psidot> = -(1/(q taub)) dJ/dalpha *)
psidotP1 = -(djp[1/2])/(q taub);
psidotP2 = -(djp[3/2])/(q taub);
check["<psidot> = 0 inside P1 (no secular radial drift within region)",
    Simplify[psidotP1] === 0];
check["<psidot> = 0 inside P2 (no secular radial drift within region)",
    Simplify[psidotP2] === 0];

If[failed > 0,
    Print["RESULT: FAIL (", failed, " checks failed)"]; Quit[1],
    Print["RESULT: PASS"]; Quit[0]];
