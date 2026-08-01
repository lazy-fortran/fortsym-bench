Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* Sergei's memo uses phiS=z/R, iotaS=+1/q, and the FP mode
   (m,n)S=(-1,+1).  HELCORE uses phiH=phiS and the conjugate member
   (+1,-1) of the same real harmonic.  Since 2026-07-18 the report has
   adopted the memo orientation (phi=phiS, iota=1/q, representative
   (-1,1) written (1,-1) for m>0), so the maps verified below now relate
   the memo/HELCORE labels to each other and to the report's HISTORICAL
   convention zetaR=-phiS with the conjugate harmonic (+1,+1) and
   iotaR=-1/q, under which earlier revisions were written.  Scalar
   coefficients conjugate under that phase reversal; toroidal
   contravariant components acquire an additional Jacobian minus sign.
   In the adopted orientation no vector-component sign remains and real
   cosine amplitudes are identical across memo, HELCORE, and report. *)
ClearAll[phiH, phiS, theta, theta0, zetaR, iotaH, iotaS, iotaR,
  mH, nH, mS, nS, mR, nR, ar, ai];

bcPath = FileNameJoin[{DirectoryName[$InputFileName], "..", "sources",
    "faepcr35", "NEO2", "HELCORE", "simple_l1", "reference",
    "helcore.bc"}];
tokens = StringSplit /@ ReadList[bcPath, String];
number[s_] := ToExpression[StringReplace[s, "E" -> "*^"]];
modeRows = Map[number,
  Select[tokens, Length[#] == 6 &&
      StringMatchQ[#[[1]], NumberString] &&
      StringMatchQ[#[[2]], NumberString] &], {2}];
firstSurface = Take[modeRows, 6];
axisRows = Select[firstSurface, #[[1]] == 0 &];

rAxis[u_] := Total[#[[3]] Cos[#[[1]] theta - #[[2]] u] & /@ axisRows];
zAxis[u_] := Total[#[[4]] Sin[#[[1]] theta - #[[2]] u] & /@ axisRows];
rMajor = (rAxis[0] + rAxis[Pi])/2;
dAxis = (rAxis[0] - rAxis[Pi])/2;

check["Map1: HELCORE first-surface spectrum was read from the Boozer file",
  Length[modeRows] >= 6 && Length[axisRows] == 3];
check["Map2: HELCORE axis rotates as R-R0=d cos(phiH)",
  Max[Abs@Table[
      (rAxis[u] - rMajor) - dAxis Cos[u], {u, 0, 2 Pi, Pi/8}]] <
    10^-12];
check["Map3: HELCORE axis rotates as Z=d sin(phiH)",
  Max[Abs@Table[zAxis[u] - dAxis Sin[u], {u, 0, 2 Pi, Pi/8}]] <
    10^-12];
check["Map4: HELCORE axis radius is 5 cm",
  Abs[dAxis - 0.05] < 10^-12];

helcoreAxis = {dAxis Cos[phiH], dAxis Sin[phiH]};
reportAxis = {dAxis Cos[zetaR], -dAxis Sin[zetaR]};
check["Map5: report zetaR=-phiH reproduces the HELCORE Boozer axis",
  FullSimplify[(reportAxis /. zetaR -> -phiH) == helcoreAxis,
    Element[phiH, Reals]]];

mS = -1; nS = 1;
mR = 1; nR = 1;
mH = 1; nH = -1;
sergeiPhase = mS theta + nS phiS;
reportPhase = mR theta + nR zetaR;
helcorePhase = mH theta + nH phiH;

check["Map6: report (1,1) phase is minus Sergei (-1,1)",
  FullSimplify[(reportPhase /. zetaR -> -phiS) == -sergeiPhase]];
check["Map7: report (1,1) maps to HELCORE (1,-1)",
  FullSimplify[(reportPhase /. zetaR -> -phiH) == helcorePhase]];
check["Map8: scalar harmonic amplitudes conjugate under the phase reversal",
  FullSimplify[ComplexExpand[
      Re[(ar + I ai) Exp[I sergeiPhase]] -
      Re[(ar - I ai) Exp[I (reportPhase /. zetaR -> -phiS)]],
    TargetFunctions -> {Re, Im}] == 0,
    Element[{ar, ai, theta, phiS}, Reals]]];

(* A field line theta = theta0 + iotaH phiH, expressed in each convention's
   toroidal angle (phiS = phiH, zetaR = -phiH), fixes the transforms by
   differentiation instead of by assignment. *)
thetaLine = theta0 + iotaH phiH;
iotaS = D[thetaLine /. phiH -> phiS, phiS];
iotaR = D[thetaLine /. phiH -> -zetaR, zetaR];
check["Map9: field-line slopes give iotaS=iotaH and iotaR=-iotaH",
  FullSimplify[iotaS == iotaH && iotaR == -iotaH]];
check["Map10: all three resonance denominators have the same zero",
  FullSimplify[mS iotaS + nS == mR iotaR + nR &&
    mR iotaR + nR == -(mH iotaH + nH)]];
check["Map11: field-line phase derivatives map with the phase sign",
  FullSimplify[
    D[sergeiPhase /. {theta -> theta0 + iotaS phiS}, phiS] ==
      -D[helcorePhase /. theta -> thetaLine, phiH]]];
check["Map12: HELCORE iota=0.99 gives q just above one in all conventions",
  Abs[(1/iotaS /. iotaH -> 0.99) - 1/0.99] < 10^-12 &&
    Abs[(-1/iotaR /. iotaH -> 0.99) - 1/0.99] < 10^-12];

check["Map13: toroidal contravariant coefficient gains conjugation and a minus sign",
  FullSimplify[ComplexExpand[
      -Re[(ar + I ai) Exp[I sergeiPhase]] -
      Re[-(ar - I ai) Exp[I (reportPhase /. zetaR -> -phiS)]],
    TargetFunctions -> {Re, Im}] == 0,
    Element[{ar, ai, theta, phiS}, Reals]]];
check["Map14: surface-current pitch is +1 Sergei, -1 report, +1 HELCORE",
  {-nS/mS, -nR/mR, -nH/mH} == {1, -1, 1}];

reportAndExit[];
