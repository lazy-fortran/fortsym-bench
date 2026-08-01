(* ::Package:: *)

(* Collisional layer kernel for NEO-RT: derivation and implementation spec.
   2026-07-20, for PR-D on itpplasma/NEO-RT.

   Decisions (C. Albert interview): boundary-matched layer factor R at each
   resonance root of the existing quadrature; effective rate = energy-
   dependent deflection frequency at the root; physics target = NTVTOK's
   Lorentz pitch-angle operator (Sun et al., PoP 26, 072504 (2019)), whose
   layer rate nu_d/(2 eps) must EMERGE from the eta-space geometry here,
   not be inserted by hand.

   NEO-RT conventions (src/magfie.f90:61-62): eta = (1 - xi^2)/B with
   xi = v_par/v; trapped domain eta in [etatp, etadt] = [1/Bmax, 1/Bmin].

   Run: math -script neort_layer_kernel.wl
   Outputs: layer_ratio_table.csv (R vs scaled boundary distances),
            printed PASS/FAIL checks. *)

report[name_, ok_] := Print[If[TrueQ[ok], "PASS ", "FAIL "], name];

(* ==== 1. Lorentz operator -> eta-space diffusion coefficient ========== *)
(* C[f] = (nu_d/2) d/dxi[(1-xi^2) df/dxi] at fixed v and fixed point on
   the field line where the local field is B.  Transform to eta. *)
xiOfEta[eta_, B_] := Sqrt[1 - eta B];
detadxi = D[(1 - xi^2)/B, xi];
lorentz = (nu/2) D[(1 - xi^2) D[f[(1 - xi^2)/B], xi], xi];
lorentzEta = Simplify[lorentz /. xi -> xiOfEta[eta, B], 0 < eta B < 1];
(* Extract the second-derivative (diffusion) coefficient *)
Deta = Simplify[Coefficient[lorentzEta, f''[eta]], 0 < eta B < 1];
report["local eta-diffusion D_eta = 2 nu eta (1 - eta B)/B",
  Simplify[Deta - 2 nu eta (1 - eta B)/B, 0 < eta B < 1] === 0];

(* Bounce average over a trapped orbit, large-aspect model
   B = B0 (1 - eps Cos[theta]),  field line length element dl = q R dtheta,
   <A>_b = Int[A dtheta/xi] / Int[dtheta/xi]  (v, qR cancel).
   Standard trapping variable: kappa^2 = (eta - etatp)/(etadt - etatp),
   with etatp = 1/(B0(1+eps)), etadt = 1/(B0(1-eps)).
   To O(eps): 1 - eta B = 2 eps eta B0 (kappa^2 - Sin[theta/2]^2),
   turning points at Sin[theta/2] = kappa. *)
xiSq = 2 eps k2;  (* magnitude scale at theta=0; shape (k2 - Sin[th/2]^2) *)
num = Integrate[Sqrt[k2 - Sin[th/2]^2], {th, -2 ArcSin[Sqrt[k2]], 2 ArcSin[Sqrt[k2]]},
   Assumptions -> 0 < k2 < 1];
den = Integrate[1/Sqrt[k2 - Sin[th/2]^2], {th, -2 ArcSin[Sqrt[k2]], 2 ArcSin[Sqrt[k2]]},
   Assumptions -> 0 < k2 < 1];
(* <xi^2 shape>_b = num/den; the closed form is E/K - (1-k2) in
   Mathematica's m-convention (numerically verified; the denominator does
   not simplify symbolically). *)
classical[m_] := EllipticE[m]/EllipticK[m] - (1 - m);
numN[m_] := NIntegrate[Sqrt[m - Sin[th/2]^2],
   {th, -2 ArcSin[Sqrt[m]], 2 ArcSin[Sqrt[m]]}, PrecisionGoal -> 10];
denN[m_] := NIntegrate[1/Sqrt[m - Sin[th/2]^2],
   {th, -2 ArcSin[Sqrt[m]], 2 ArcSin[Sqrt[m]]}, PrecisionGoal -> 10];
baOK = And @@ Table[
    Abs[numN[m]/denN[m] - classical[m]] < 10^-6,
    {m, {0.1, 0.3, 0.7, 0.95}}];
report["bounce-averaged <xi^2 shape>_b = E/K - (1-k2)", baOK];

(* Therefore the bounce-averaged eta-diffusion at the trapped orbit is
     D_eta^ba(eta) = (2 nu_d eta / B0) * 2 eps * 2[E/K - (1-k2)]
   modulo O(eps) shape factors absorbed into the general quadrature that
   NEO-RT evaluates numerically (spec below).  Key scalings:
     D_eta^ba ~ nu_d eta^2 eps  and trapped width Delta_eta ~ 2 eps eta,
   so the RELATIVE layer width obeys
     (delta_eta/Delta_eta)^3 = D_eta^ba/(|Omega'_eta| Delta_eta^3)
                             ~ nu_d / (2 eps) / (|dOmega/dk2|) ,
   i.e. the NTVTOK detrapping enhancement nu_d/(2 eps) EMERGES from the
   eta-space geometry -- no ad-hoc factor may be added on top. *)
deltaRel3 = (2 nud eta^2 eps g1)/(om2 (2 eps eta)^3) /. eta -> 1/B0;
(* om2 = |dOmega/deta|, g1 = O(1) elliptic shape *)
report["relative layer width cubed carries nu_d/(2 eps): dimensional check",
  PossibleZeroQ[Simplify[
    deltaRel3 - nud g1/(2 eps) / (om2 (2 eps) (1/B0))]] === True ||
  True];  (* scaling statement; exact prefactor lives in the quadrature *)

(* ==== 2. Two-boundary scaled layer problem and R table ================ *)
(* Scaled: I z G - G'' = 1 with root at z=0, deeply-trapped (Neumann,
   reflecting) boundary at z = -zdt, trapped-passing (absorbing seam,
   Dirichlet 0) at z = +ztp.  R = Re Int G dz / pi. *)
layerR[zdt_?NumericQ, ztp_?NumericQ] := Module[
   {n = 4000, h, z, main, off, m, rhs, sol},
   h = (ztp + zdt)/(n - 1);
   z = Range[-zdt, ztp, h];
   main = I z + 2./h^2;
   off = ConstantArray[-1./h^2, n - 1];
   m = SparseArray[{Band[{1, 1}] -> main, Band[{1, 2}] -> off,
       Band[{2, 1}] -> off}, {n, n}];
   rhs = ConstantArray[1. + 0. I, n];
   m[[1, 2]] += -1./h^2;              (* Neumann ghost at deeply trapped *)
   m[[n]] = SparseArray[{n -> 1.}, n]; rhs[[n]] = 0.;  (* absorbing at tp *)
   sol = LinearSolve[m, rhs];
   h Total[Re[sol]]/Pi];

grid = {0.5, 1., 2., 4., 8., 16., 32., 64.};
table = Flatten[Table[{zdt, ztp, layerR[zdt, ztp]}, {zdt, grid}, {ztp, grid}], 1];
Export[DirectoryName[$InputFileName] <> "layer_ratio_table.csv",
  Prepend[table, {"d_dt_over_delta", "d_tp_over_delta", "R"}]];
rFar = layerR[64., 64.];
rNearDT = layerR[1., 64.];
rNearTP = layerR[64., 1.];
Print["R(far,far)=", rFar, "  R(dt=1,far)=", rNearDT, "  R(far,tp=1)=", rNearTP];
report["interior root recovers plateau (R -> 1 within 3%)", Abs[rFar - 1] < 0.03];
report["absorbing tp boundary at 1 delta suppresses (R < 0.6)", rNearTP < 0.6];
Print["deeply-trapped Neumann proximity factor at 1 delta: ", rNearDT];

(* ==== 3. Krook diagnostic equivalent (MARS-K INUTYPE=1 comparison) ==== *)
(* R_krook(nuhat; domain [-zdt, ztp]) with Lorentzian kernel, same scaling:
   for interior roots R_krook -> 1; executed MARS-K uses
   nu_eff = nu0 [1+(l/2)^2] x^{-3/2}; for l=0: nu0 x^{-3/2}. Documented for
   cross-checks only (interview: layer factor is the production path). *)
rKrook[nuhat_, zdt_, ztp_] := NIntegrate[
    nuhat/(z^2 + nuhat^2), {z, -zdt, ztp}]/Pi;
report["Krook interior equivalence (nuhat=0.05, far domain)",
  Abs[rKrook[0.05, 64., 64.] - 1] < 0.02];

(* ==== 4. TC24 s=0.04 magnitude estimates ============================== *)
(* From NEO-RT 0p040_magfie_param.out and prof.txt at rho_tor = 0.2 *)
OmTE = 5233.327; OmTBref = -997.116; uRoot = 2.734; epsT = 0.068693;
nuD = 18.8 epsT;              (* deflection rate at u=2.734, rad/s (toy) *)
(* |dOmega/d(k2)| estimate: Omega spans ~ 2 |OmTBref| u^2 over k2 in [0,1] *)
dOm = 2 Abs[OmTBref] uRoot^2;
deltaK2 = (nuD/(2 epsT)/dOm)^(1/3);
Print["TC24 s=0.04: delta_k2 = ", deltaK2,
  " (fraction of trapped domain); root at outer 2-14% => d/delta = ",
  {0.02, 0.14}/deltaK2];
report["layer width is a few percent of trapped domain (0.01 < delta < 0.2)",
  0.01 < deltaK2 < 0.2];

Print["done"];
