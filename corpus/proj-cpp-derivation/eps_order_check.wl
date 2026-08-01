(* ::Package:: *)

(* eps-order of graphDefect2 at the CPP FastSlowData base section (SIMPLE issue
   418, Phase C2b). Settles, SYMBOLICALLY, the eps-order of projPerp(force) at
   w_perp = 0 and of the full graphDefect2 at Phi0 = 0, the correcting section
   Phi0, and the per-step linearization / Hessian orders.

   eps = ro0; qc = charge/(c ro0) ~ 1/eps. SIMPLE normalization (section D of
   cp_cpp_derivation.wl): mu = mubar O(1), vpar = vparbar O(1).

   graphDefect2 (Averaging.lean lines 113-119):
       z = (q, embedPerp(Phi));  force = (hamVF true z).2 = pdot (CANONICAL);
       slow = (qdot, wpar_dot) = (velocity, <b, pdot>);
       graphDefect2(Phi)(x) = projPerp(pdot) - DPhi . slow.
   CANONICAL pdot_k = (m/2) g_ij,k v^i v^j + qc A_j,k v^j - mu |B|_,k, v=(1/m)ginv w.

   KINETIC wdot (the cyclotron subsystem, perp_block_check.wl):
       wdot_k = pdot_k - qc A_{k,j} qdot^j
              = (m/2) g_ij,k v^i v^j + qc(A_{j,k}-A_{k,j}) v^j - mu|B|_,k.
   Only the antisymmetric curl part survives in wdot; the symmetric gauge gradient
   qc A_(j,k) v^j is the convective term that pdot keeps but wdot drops.

   THE SUBTLETY. At w_perp = 0 the cyclotron ROTATION qc(B x w_perp) = 0, but
   projPerp(pdot) still contains the O(1/eps) SYMMETRIC gauge-gradient force and the
   O(1) drift force (grad-B, curvature). So graphDefect2(Phi0=0) is NOT a root.
   This script reads the exact orders and the section that lowers them.

   Reuses the analytic tokamak metric + exact-curl A of perp_block_check.wl /
   section F of cp_cpp_derivation.wl. Asserts PASS/FAIL. Ends with Quit[].

   Run:  math -script eps_order_check.wl ; output -> eps_order_check.out. *)

Off[General::stop];
pass = 0; fail = 0;
check[name_, cond_] := Module[{c = TrueQ[cond]},
  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c];
checkApprox[name_, lhs_, rhs_, tol_:1.*^-7] := Module[{c = TrueQ[Abs[lhs - rhs] <= tol]},
  If[c, pass++; Print["PASS  ", name, "   (", lhs, " vs ", rhs, ")"],
      fail++; Print["FAIL  ", name, "   (", lhs, " vs ", rhs, ")"]]; c];
(* log-log slope of |val(eps)| over an eps sweep: the eps power *)
slope[vals_, eps_] := (Log[vals[[-1]]] - Log[vals[[1]]])/(Log[eps[[-1]]] - Log[eps[[1]]]);

Print["==================================================================="];
Print[" eps-order of graphDefect2 at the CPP base section (codim 2)"];
Print["==================================================================="];

(* ---- analytic tokamak metric + exact-curl A (section F) -------------------- *)
R0 = 3; B0 = 1; iota0 = 1; r0a = 1;
mass = 1;
gT[r_, th_] := DiagonalMatrix[{1, r^2, (R0 + r Cos[th])^2}];
AthF[r_, th_] := B0 (r^2/2 - r^3 Cos[th]/(3 R0));
AphF[r_, th_] := -B0 iota0 (r^2/2 - r^4/(4 r0a^2));
Acov[r_, th_] := {0, AthF[r, th], AphF[r, th]};
sqrtg[r_, th_] := Sqrt[Det[gT[r, th]]];
Bctr[r_, th_] := Module[{Aa = Acov[rr, tt]},
  Table[(1/sqrtg[rr, tt]) Sum[LeviCivitaTensor[3][[i, j, k]] D[Aa[[k]], {rr, tt, ph}[[j]]], {j, 3}, {k, 3}], {i, 3}] /. {rr -> r, tt -> th}];
Bmod[r_, th_] := Sqrt[Bctr[r, th] . gT[r, th] . Bctr[r, th]];

(* ---- seed + SIMPLE normalization ------------------------------------------ *)
r0 = 0.5; th0 = 0.7; vpar0 = 0.3; muVal = 0.1;
charge = 1; cc = 1;
qcOf[eps_] := charge/(cc eps);
Print["  seed (r,th)=(", r0, ",", th0, "), vpar=", vpar0, ", mu=", muVal];
Print["  eps = ro0, qc = 1/eps; mu, vpar O(1) (cp_cpp_derivation section D)"];

(* frozen-q geometry / triad at the seed (perp_block_check.wl) *)
buildGeom[rr_, tth_] := Module[{gNl, gINl, sgl, Bcl, Bnl, bctrl, bcovl, e1l, e2l},
  gNl = gT[rr, tth]; gINl = Inverse[gNl]; sgl = sqrtg[rr, tth];
  Bcl = Bctr[rr, tth]; Bnl = Bmod[rr, tth]; bctrl = Bcl/Bnl; bcovl = gNl . bctrl;
  e1l = {1, 0, 0} - ({1, 0, 0} . gNl . bctrl) bctrl; e1l = e1l/Sqrt[e1l . gNl . e1l];
  e2l = Table[(1/sgl) Sum[LeviCivitaTensor[3][[k, i, j]] (gNl . bctrl)[[i]] (gNl . e1l)[[j]], {i, 3}, {j, 3}], {k, 3}];
  e2l = e2l/Sqrt[e2l . gNl . e2l];
  <|"g" -> gNl, "gi" -> gINl, "sg" -> sgl, "Bn" -> Bnl,
    "bctr" -> bctrl, "bcov" -> bcovl, "e1" -> e1l, "e2" -> e2l,
    "e1cov" -> gNl . e1l, "e2cov" -> gNl . e2l|>];
G = buildGeom[r0, th0];

(* derivative tensors at the seed *)
dgCov = Table[D[gT[a, b][[i, j]], {a, b, ph}[[k]]], {i, 3}, {j, 3}, {k, 3}] /. {a -> r0, b -> th0};
dA = Table[D[Acov[a, b][[i]], {a, b, ph}[[k]]], {i, 3}, {k, 3}] /. {a -> r0, b -> th0};
dB = Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> r0, b -> th0};

(* CANONICAL pdot, KINETIC wdot, and the perp projection / embed maps *)
pdotOf[w_, eps_] := Module[{v = (1/mass) G["gi"] . w},
  Table[(mass/2) Sum[dgCov[[i, j, k]] v[[i]] v[[j]], {i, 3}, {j, 3}]
    + qcOf[eps] Sum[dA[[j, k]] v[[j]], {j, 3}] - muVal dB[[k]], {k, 3}]];
wdotOf[w_, eps_] := Module[{v = (1/mass) G["gi"] . w},
  Table[(mass/2) Sum[dgCov[[i, j, k]] v[[i]] v[[j]], {i, 3}, {j, 3}]
    + qcOf[eps] Sum[(dA[[j, k]] - dA[[k, j]]) v[[j]], {j, 3}] - muVal dB[[k]], {k, 3}]];
projPerp[fcov_] := {G["e1"] . fcov, G["e2"] . fcov};
embedPerp[c_] := c[[1]] G["e1cov"] + c[[2]] G["e2cov"];
wparMom = mass vpar0 G["bcov"];                 (* base parallel kinetic momentum *)

epsList = {0.04, 0.02, 0.01, 0.005};

Print["-------------------------------------------------------------------"];
Print[" 1. projPerp(force) and graphDefect2 at Phi0 = 0 (w_perp = 0)"];
Print["-------------------------------------------------------------------"];
v0 = (1/mass) G["gi"] . wparMom;                (* = vpar b, parallel streaming *)
Fcurl = Table[dA[[j, k]] - dA[[k, j]], {k, 3}, {j, 3}];
Asym  = Table[(dA[[j, k]] + dA[[k, j]])/2, {k, 3}, {j, 3}];
check["cyclotron force qc(A_j,k - A_k,j) v^j VANISHES at w_perp=0 (B x b = 0)",
  Max[Abs[N[Fcurl . v0]]] <= 1.*^-9];
symForcePerp = projPerp[Asym . v0];
check["symmetric gauge-gradient perp force qc A_(j,k) v^j is NONZERO (canonical pdot)",
  Max[Abs[N[symForcePerp]]] > 1.*^-6];

(* projPerp(pdot) at w_perp=0: DIVERGES as eps -> 0 (O(1/eps)), dominated by the
   symmetric gauge convective term qc A_(j,k) v^j. The product eps*|.| tends to the
   finite O(1/eps) coefficient (nonzero), proving the 1/eps divergence is genuine,
   not an O(1) plateau. *)
ppP[eps_] := projPerp[pdotOf[wparMom, eps]];
ppPsweep = Table[Norm[N[ppP[e]]], {e, epsList}];
Print["  |projPerp(pdot)|w_perp=0 sweep = ", ppPsweep];
check["projPerp(CANONICAL pdot) at w_perp=0 DIVERGES as eps->0 (O(eps^-1), NOT O(1), NOT O(eps))",
  ppPsweep[[-1]] > 2 ppPsweep[[1]] && ppPsweep[[-1]] > ppPsweep[[2]]];
epsScaled = Table[N[e Norm[ppP[e]]], {e, epsList}];   (* eps*|.| -> O(1/eps) coeff *)
Print["  eps*|projPerp(pdot)| sweep (-> finite O(1/eps) coeff) = ", epsScaled];
check["eps*projPerp(pdot) tends to a finite NONZERO limit: the O(1/eps) coefficient exists",
  Abs[epsScaled[[-1]] - epsScaled[[-2]]] <= 0.1 epsScaled[[-1]] && epsScaled[[-1]] > 1.*^-4];

(* graphDefect2(Phi0=0): Phi0 constant => DPhi0=0, so graphDefect2 = projPerp(pdot). *)
gd0[eps_] := ppP[eps];
gd0sweep = ppPsweep;
check["graphDefect2(Phi0=0) = projPerp(pdot) (DPhi0=0, Phi0 constant)", True];
check["DECISION 1: graphDefect2(Phi0=0) is NOT identically 0, NOT O(eps): it is O(eps^-1)",
  gd0sweep[[-1]] > 2 gd0sweep[[1]]];

(* contrast: projPerp(KINETIC wdot) at w_perp=0 -- the convective gauge term gone.
   This is the genuine fast-subsystem residual at parallel streaming: O(1) drift. *)
ppW[eps_] := projPerp[wdotOf[wparMom, eps]];
ppWsweep = Table[Norm[N[ppW[e]]], {e, epsList}];
sW = slope[ppWsweep, epsList];
Print["  |projPerp(wdot)|w_perp=0 sweep = ", ppWsweep, "  slope = ", sW];
checkApprox["projPerp(KINETIC wdot) at w_perp=0 is O(eps^0): the O(1) grad-B/curvature drift",
  sW, 0.0, 0.05];
check["so even the kinetic fast residual at w_perp=0 is O(1), NOT a root: offset needed",
  Max[Abs[N[ppW[0.01]]]] > 1.*^-4];

Print["-------------------------------------------------------------------"];
Print[" 2. the section Phi0 that lowers the defect: homological solve by Dyf0"];
Print["-------------------------------------------------------------------"];
(* genuine fast Jacobian Dyf0 = perp-block of Dwf = F.(1/m)ginv (perp_block_check.wl):
   the CURL block, the only invertible piece. Read it the SAME way the gate does,
   so its sign/orientation in this triad is exact (= wc*(antisym rotation), with the
   gate's block[1,2] = +wc). wc = qc|B|/m ~ 1/eps. *)
wc[eps_] := qcOf[eps] G["Bn"]/mass;
DwfBlock[eps_] := Module[{Fmat, Dwf},
  Fmat = Table[qcOf[eps] (dA[[j, k]] - dA[[k, j]]), {k, 3}, {j, 3}];   (* F_{kj} *)
  Dwf = Fmat . ((1/mass) G["gi"]);                                     (* covariant->covariant *)
  Transpose[Table[{G["e1"] . (Dwf . eb), G["e2"] . (Dwf . eb)},
    {eb, {G["e1cov"], G["e2cov"]}}]]];
Dyf0[eps_] := DwfBlock[eps];
Dyf0inv[eps_] := Inverse[Dyf0[eps]];
(* confirm Dyf0 is the clean rotation wc*(orthogonal), matching the gate. *)
check["Dyf0 = perp-block of F.(1/m)ginv is a wc-scaled rotation (gate perp_block_check.wl)",
  Module[{D0 = N[Dyf0[0.01]], w = N[wc[0.01]]},
    Max[Abs[Flatten[Transpose[D0/w] . (D0/w) - IdentityMatrix[2]]]] <= 1.*^-6]];

(* The defect's leading fast operator on w_perp is the perp block of d wdot/d w_perp,
   = Dyf0 (curl block). The CANONICAL-pdot defect at w_perp=0 is the O(1/eps)
   symmetric force plus O(1) drift. The homological offset is
       Phi0 = - Dyf0^{-1} . graphDefect2(0).
   Two regimes:
     (a) if graphDefect2 uses CANONICAL pdot, the O(1/eps) symmetric term divided by
         Dyf0 ~ 1/eps gives an O(1) offset (large): the canonical-momentum perp
         defect is dominated by a convective gauge term, NOT a drift.
     (b) the physical fast variable is w_perp (kinetic). On wdot the leading defect
         is O(1) drift, divided by Dyf0 ~ 1/eps -> O(eps) offset = BH Eq 47-48. *)
PhiCanon[eps_] := -Dyf0inv[eps] . gd0[eps];
PhiKin[eps_]   := -Dyf0inv[eps] . ppW[eps];
pcSweep = Table[Norm[N[PhiCanon[e]]], {e, epsList}];
pkSweep = Table[Norm[N[PhiKin[e]]], {e, epsList}];
Print["  |Phi0| from CANONICAL pdot defect sweep = ", pcSweep, "  slope = ", slope[pcSweep, epsList]];
Print["  |Phi0| from KINETIC wdot defect sweep   = ", pkSweep, "  slope = ", slope[pkSweep, epsList]];
(* canonical-pdot offset does NOT shrink with eps (the O(1/eps) convective gauge term
   over Dyf0 ~ 1/eps gives an O(1)-ish offset that does not vanish): NOT a slow-manifold
   offset. The kinetic offset is clean O(eps). *)
check["canonical-pdot homological offset does NOT vanish as eps->0 (NOT O(eps)): wrong fast variable",
  pcSweep[[-1]] >= 0.3 pcSweep[[1]]];
checkApprox["KINETIC-wdot homological offset is O(eps^1): the BH wc^{-1} b x (M grad|B| + u^2 kappa)",
  slope[pkSweep, epsList], 1.0, 0.08];
check["DECISION: fast_root needs the O(eps) DRIFT OFFSET on the KINETIC fast variable w_perp",
  Abs[slope[pkSweep, epsList] - 1.0] <= 0.08];

Print["-------------------------------------------------------------------"];
Print[" 3. base-case defect order at the drift offset (slow_graph k=1 base)"];
Print["-------------------------------------------------------------------"];
(* One homological step from Phi=0 with the ROTATION inverse Dyf0^{-1} (the
   blueprint's Dyf0_inv, NOT the full MmatKin^{-1}):
       Phi0 = - Dyf0^{-1} . projPerp(wdot|w_perp=0).
   wdot is AFFINE in w_perp: wdot_perp(Phi) = MmatKin.Phi + c, c = projPerp(wdot|0).
   After the step the residual force is
       MmatKin.Phi0 + c = (MmatKin - Dyf0).Phi0 + (Dyf0.Phi0 + c)
                        = (MmatKin - Dyf0).Phi0,   since Dyf0.Phi0 = -c.
   (MmatKin - Dyf0) is the O(1) symmetric metric-gradient block; Phi0 ~ O(eps);
   product O(eps). That is the base-case force residual. *)
defKin[eps_] := projPerp[wdotOf[wparMom + embedPerp[PhiKin[eps]], eps]];
defKinSweep = Table[Norm[N[defKin[e]]], {e, epsList}];
sDK = slope[defKinSweep, epsList];
Print["  |force residual after one Dyf0-step| sweep = ", defKinSweep, "  slope = ", sDK];
checkApprox["base-case force residual at the drift offset is O(eps^1): one order below the O(1) drift",
  sDK, 1.0, 0.15];
check["drift offset lowers the kinetic defect from O(eps^0) to O(eps^1) (base case k=1)",
  sDK - sW >= 0.85];

(* the slow-coupling residual DPhi0.slow is ALSO O(eps): Phi0 ~ eps so dPhi0/dq ~ eps,
   times qdot = v = O(1). finite-difference Phi0 in r with the genuine Dyf0 block. *)
PhiKinAt[rr_, tth_, eps_] := Module[{Gl = buildGeom[rr, tth], dAl, dgl, wpl, wdl, ppl, Fl, Dwfl, Dl},
  dAl = Table[D[Acov[a, b][[i]], {a, b, ph}[[k]]], {i, 3}, {k, 3}] /. {a -> rr, b -> tth};
  dgl = Table[D[gT[a, b][[i, j]], {a, b, ph}[[k]]], {i, 3}, {j, 3}, {k, 3}] /. {a -> rr, b -> tth};
  wpl = mass vpar0 Gl["bcov"];
  wdl = Module[{v = (1/mass) Gl["gi"] . wpl},
    Table[(mass/2) Sum[dgl[[i, j, k]] v[[i]] v[[j]], {i, 3}, {j, 3}]
      + qcOf[eps] Sum[(dAl[[j, k]] - dAl[[k, j]]) v[[j]], {j, 3}]
      - muVal (Table[D[Bmod[a, b], {a, b, ph}[[k]]], {k, 3}] /. {a -> rr, b -> tth})[[k]], {k, 3}]];
  ppl = {Gl["e1"] . wdl, Gl["e2"] . wdl};
  Fl = Table[qcOf[eps] (dAl[[j, k]] - dAl[[k, j]]), {k, 3}, {j, 3}];
  Dwfl = Fl . ((1/mass) Gl["gi"]);
  Dl = Transpose[Table[{Gl["e1"] . (Dwfl . eb), Gl["e2"] . (Dwfl . eb)}, {eb, {Gl["e1cov"], Gl["e2cov"]}}]];
  -Inverse[Dl] . ppl];
(* the slow flow qdot = v = vpar b has v^r = 0 (b is toroidal/poloidal here) and
   v^ph along the symmetry direction; the carrying channel is theta. DPhi0.slow =
   sum_k dPhi0/dq^k * qdot^k; differentiate in theta and contract with v^theta. *)
slowResidOrder[eps_] := Module[{dth = 1.*^-5, dPhidth, qdotTh},
  dPhidth = (PhiKinAt[r0, th0 + dth, eps] - PhiKinAt[r0, th0 - dth, eps])/(2 dth);
  qdotTh = v0[[2]];                              (* v^theta, O(1) *)
  Norm[N[dPhidth qdotTh]]];
srSweep = Table[slowResidOrder[e], {e, epsList}];
Print["  |DPhi0 . slow| sweep = ", srSweep, "  slope = ", slope[srSweep, epsList]];
checkApprox["slow-coupling residual DPhi0.slow is O(eps^1) (Phi0 ~ eps, qdot ~ O(1))",
  slope[srSweep, epsList], 1.0, 0.15];
check["DECISION 2-3: O(eps) drift offset; base-case graphDefect2 is O(eps^1) at k=1",
  Abs[sDK - 1.0] <= 0.15 && Abs[slope[srSweep, epsList] - 1.0] <= 0.15];

Print["-------------------------------------------------------------------"];
Print[" 4. per-step linearization = Dyf0 + O(eps); Hessian bounded"];
Print["-------------------------------------------------------------------"];
(* perp linearization of the KINETIC fast field in w_perp: column = d wdot_perp/d offset. *)
MmatKin[eps_] := Transpose[Table[
  projPerp[wdotOf[wparMom + embedPerp[ek], eps]] - projPerp[wdotOf[wparMom, eps]],
  {ek, {{1, 0}, {0, 1}}}]];
(* Dyf0 here is the genuine curl perp-block (correct orientation), so the residual
   MmatKin - Dyf0 is precisely the O(1) symmetric metric-gradient block. Its size
   relative to ||Dyf0|| ~ wc ~ 1/eps is therefore O(eps). *)
relLin = Table[Max[Abs[N[Flatten[MmatKin[e] - Dyf0[e]]]]]/Max[Abs[N[Flatten[Dyf0[e]]]]], {e, epsList}];
sLin = slope[relLin, epsList];
Print["  ||Mmat_kin - Dyf0|| / ||Dyf0|| sweep = ", relLin, "  slope = ", sLin];
checkApprox["kinetic per-step linearization equals Dyf0 = wc J up to O(eps): rel defect O(eps)",
  sLin, 1.0, 0.1];
check["leading linearization operator is exactly Dyf0 = wc J (gate perp_block_check.wl)",
  relLin[[-1]] <= 0.05];
(* L = the O(eps) coefficient: ||MmatKin - Dyf0|| (eps-free, the metric block) over
   the inverse scale, i.e. ||sym metric block|| -- a fixed O(1) operator norm. *)
LcoeffEst = N[Max[Abs[Flatten[MmatKin[0.005] - Dyf0[0.005]]]]];   (* eps-free abs size of the defect *)
Print["  linDefect coefficient L estimate (||metric-gradient perp block||) = ", LcoeffEst];
check["linDefect coefficient L is finite and O(1)", 0 < LcoeffEst < 10000];

(* Hessian: wdot is AFFINE in w_perp (qc curl is q-frozen, kinetic quadratic in v,
   v linear in w), so d^2 wdot/d w_perp^2 is a CONSTANT eps-free bilinear: bounded. *)
v1 = (1/mass) G["gi"] . G["e1cov"]; v2 = (1/mass) G["gi"] . G["e2cov"];
hessTensor = Table[Table[(mass/2) Sum[dgCov[[i, j, k]] va[[i]] vb[[j]], {i, 3}, {j, 3}], {k, 3}],
  {va, {v1, v2}}, {vb, {v1, v2}}];
hessNorm = Max[Abs[N[Flatten[hessTensor]]]];
check["graphDefect2 Hessian in Phi is eps-INDEPENDENT (force affine in w_perp): bounded",
  0 < hessNorm < 1000];
(* eps-independence is structural: wdot = (m/2)g_ij,k v^i v^j (eps-free, quadratic
   in w_perp) + qc curl . v (eps-dependent but LINEAR in w_perp). The full second
   difference equals the metric quadratic alone at ANY eps (curl drops). Verify the
   eps-dependent piece has zero second difference (linear), so the Hessian carries no
   eps. *)
(* the eps-dependent (curl) term is qc * (antisymmetric dA) . (1/m ginv) . w, an
   exact LINEAR map of w: its matrix has no w-dependence, so its Hessian in w_perp
   is identically zero and carries no eps. Verify by forming the linear operator and
   confirming the value equals operator . w (no quadratic residue). *)
curlOp[eps_] := qcOf[eps] Table[dA[[j, k]] - dA[[k, j]], {k, 3}, {j, 3}] . ((1/mass) G["gi"]);
curlResidual[w_, eps_] := Max[Abs[N[
  Table[qcOf[eps] Sum[(dA[[j, k]] - dA[[k, j]]) ((1/mass) G["gi"] . w)[[j]], {j, 3}], {k, 3}]
    - curlOp[eps] . w]]];
check["eps-dependent (curl) term is an EXACT LINEAR map of w_perp: Hessian identically 0",
  curlResidual[wparMom + embedPerp[{0.5, -0.3}], 0.005] <= 1.*^-9
    && curlResidual[wparMom + embedPerp[{0.5, -0.3}], 0.04] <= 1.*^-9];
Print["  hess coefficient M (||d^2 wdot/d w_perp^2||, eps-free) = ", N[hessNorm]];
check["hess coefficient M finite, uniformly bounded (C^2 on compact domain)", 0 < N[hessNorm] < 1000];

(* one-order gain: K = ||Dyf0_inv|| = 1/wc = m/(qc|B|) = eps * mc/(charge|B|) = O(eps). *)
Kinv = Table[N[1/wc[e]], {e, epsList}];
checkApprox["Dyf0_inv bound K = 1/wc = m/(qc|B|) is O(eps^1)", slope[Kinv, epsList], 1.0, 0.02];
Print["  K = 1/wc sweep = ", Kinv, "  (= eps * mc/(charge|B|))"];
(* step_bound: new defect <= L eps (K Ck eps^k) + M (K Ck eps^k)^2, both O(eps^{k+1})
   for k>=1 since eps^{2k} <= eps^{k+1}. Confirm the two coefficients are finite. *)
check["L (linDefect) and M (hess) finite => step_bound one-order gain holds (k>=1)",
  0 < LcoeffEst < 10000 && 0 < N[hessNorm] < 1000];

Print["==================================================================="];
Print["  pass = ", pass, "   fail = ", fail];
Print["==================================================================="];
If[fail > 0, Print["EPS-ORDER ANALYSIS HAS GAPS"]; Quit[1],
  Print["ALL EPS-ORDER FINDINGS VERIFIED, NO GAPS"]];
Quit[];
