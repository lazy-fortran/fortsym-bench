(* Leading-order toroidal corrections to the 1D helical model.

   Ordering (stated once, used everywhere below):
     eps      = r/R0 << 1            inverse aspect ratio
     beta     = 8 pi p / B^2 ~ eps^2 tokamak ordering, so beta_p ~ 1
     q, m, n  ~ 1
     xi/r     << 1                   linear perturbation amplitude

   Sections:
     1  Grad-Shafranov operator in shifted polar coordinates (exact).
     2  cos(omega) projection of the toroidal GS equation, O(eps).
     3  Shifted-circle reduction psi_1 = -Delta psi0' -> Shafranov ODE.
     4  Integral form and the (beta_p + l_i/2) closure.
     5  Analytic oracle: flat current + parabolic pressure.
     6  O(eps^2) toroidal correction to q, and to the helical flux slope.
     7  Toroidal m -> m+-1 sideband coupling, O(eps).
     8  Bussac internal-kink delta-W and the critical poloidal beta.
     9  Ordering / eps -> 0 vanishing checks.
    10  Pins against the Fortran mhd1d toroidal implementation and the
        retained sensitivity campaign.

   CGS/Gaussian units throughout, consistent with mhd1d.  The poloidal flux
   used in sections 1-6 is the tokamak flux function psi(R,z) with
   B = grad(phi) x grad(psi) + F grad(phi), F = R B_phi, and

     Delta*psi + 4 pi R^2 P'(psi) + F F'(psi) = 0,
     Delta*psi = psi_RR - psi_R/R + psi_zz.

   The cylindrical limit R0 -> infinity of that equation is the screw-pinch
   equation already pinned in script 41. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

ClearAll[rr, ww, R0, lam, eps, psiF, psi0, chi, delta, ptil, ff, bth, pfun,
  pp, ib, ip, ipbar, aMinor, p0, Ba, qcyl, qtor, kap, mPol, nTor, betaP, li,
  betaPc, r1, xi0, B0, mu0, betaOff, gscale, qq, d2, d2p, psiHat, phiAng,
  mm, pflux2];

(* ------------------------------------------------------------------ *)
(* 1. Grad-Shafranov operator in shifted polar coordinates.            *)
(* ------------------------------------------------------------------ *)

(* R = R0 + r Cos[w], Z = r Sin[w].  Claim:
     Delta*psi = psi_rr + psi_r/r + psi_ww/r^2
                 - (1/R) (Cos[w] psi_r - Sin[w] psi_w / r).           *)

starLab = (Derivative[2, 0][psiF][RR, ZZ] -
    Derivative[1, 0][psiF][RR, ZZ]/RR +
    Derivative[0, 2][psiF][RR, ZZ]) /.
  {RR -> R0 + rr Cos[ww], ZZ -> rr Sin[ww]};

polarF[a_, b_] := psiF[R0 + a Cos[b], a Sin[b]];

starPolar = D[polarF[rr, ww], {rr, 2}] + D[polarF[rr, ww], rr]/rr +
  D[polarF[rr, ww], {ww, 2}]/rr^2 -
  (1/(R0 + rr Cos[ww])) (Cos[ww] D[polarF[rr, ww], rr] -
     Sin[ww] D[polarF[rr, ww], ww]/rr);

check["Delta* in shifted polar coordinates is exact",
  Simplify[starLab - starPolar] === 0];

(* The toroidal piece is the last group; it is O(1/R0) relative to the
   polar Laplacian, i.e. O(eps) relative when acting on radial scales r. *)

(* ------------------------------------------------------------------ *)
(* 2. cos(omega) projection at O(eps).                                  *)
(* ------------------------------------------------------------------ *)

(* Bookkeeping: R0 = 1/lam.  Tokamak pressure ordering means
   R0^2 dP/dpsi = ptil = O(1), and F F'(psi) = ff = O(1).  The
   equilibrium m=1 harmonic is the Shafranov shift, psi_1 = lam chi. *)

psiField = psi0[rr] + lam chi[rr] Cos[ww];

gsScaled = D[psiField, {rr, 2}] + D[psiField, rr]/rr +
  D[psiField, {ww, 2}]/rr^2 -
  (lam/(1 + lam rr Cos[ww])) (Cos[ww] D[psiField, rr] -
     Sin[ww] D[psiField, ww]/rr) +
  4 Pi (1 + lam rr Cos[ww])^2 ptil[psiField] + ff[psiField];

gsSeries = Normal[Series[gsScaled, {lam, 0, 1}]];

meanProj = Simplify[Integrate[gsSeries, {ww, 0, 2 Pi}]/(2 Pi)];
cosProj = Simplify[Integrate[gsSeries Cos[ww], {ww, 0, 2 Pi}]/Pi];

meanExpect = psi0''[rr] + psi0'[rr]/rr + 4 Pi ptil[psi0[rr]] + ff[psi0[rr]];
cosExpect = lam (chi''[rr] + chi'[rr]/rr - chi[rr]/rr^2 - psi0'[rr] +
    8 Pi rr ptil[psi0[rr]] +
    (4 Pi ptil'[psi0[rr]] + ff'[psi0[rr]]) chi[rr]);

check["mean projection is the cylindrical screw-pinch equation at O(eps)",
  Simplify[meanProj - meanExpect] === 0];
check["cos(omega) projection gives the Shafranov harmonic equation",
  Simplify[cosProj - cosExpect] === 0];

(* ------------------------------------------------------------------ *)
(* 3. Shifted circles: psi_1 = -Delta psi0'.                           *)
(* ------------------------------------------------------------------ *)

(* Eliminate the flux-function derivatives using the mean equation, which
   defines Q(r) = 4 pi ptil[psi0] + ff[psi0] = -(psi0'' + psi0'/r) and
   d/dr Q = (4 pi ptil' + ff') psi0'.  Write everything with a generic
   psi0 and the scaled shift dl = R0 Delta.                            *)

qsrc[x_] := -(psi0''[x] + psi0'[x]/x);
kcoef[x_] := D[qsrc[x], x]/psi0'[x];

lOp[f_, x_] := D[f[x], {x, 2}] + D[f[x], x]/x - f[x]/x^2 + kcoef[x] f[x];

chiShift[x_] := -delta[x] psi0'[x];

check["L[-Delta psi0'] collapses onto first derivatives of Delta",
  Simplify[lOp[chiShift, rr] -
    (-delta''[rr] psi0'[rr] - 2 delta'[rr] psi0''[rr] -
      delta'[rr] psi0'[rr]/rr)] === 0];

check["that collapse is the self-adjoint form (r psi0'^2 Delta')'",
  Simplify[lOp[chiShift, rr] +
    D[rr psi0'[rr]^2 delta'[rr], rr]/(rr psi0'[rr])] === 0];

(* The harmonic equation of section 2 is L[chi] = psi0' - 8 pi r ptil. *)
check["shifted circles turn the harmonic equation into the Shafranov ODE",
  Simplify[(lOp[chiShift, rr] - psi0'[rr] + 8 Pi rr ptil[psi0[rr]]) +
    (D[rr psi0'[rr]^2 delta'[rr], rr]/(rr psi0'[rr]) + psi0'[rr] -
      8 Pi rr ptil[psi0[rr]])] === 0];

(* Hence, in unscaled variables with psi0' = R0 Btheta and
   p(r) = P(psi0(r)),
     d/dr [ r Btheta^2 Delta' ] = ( -r Btheta^2 + 8 pi r^2 p'(r) ) / R0. *)

(* ------------------------------------------------------------------ *)
(* 4. Integral form, l_i and beta_p.                                   *)
(* ------------------------------------------------------------------ *)

Derivative[1][ib][x_] := bth[x]^2 x;      (* ib(r) = Int_0^r Btheta^2 s ds *)
Derivative[1][ip][x_] := x^2 pp[x];       (* ip(r) = Int_0^r s^2 p'(s) ds *)
Derivative[1][ipbar][x_] := x pfun[x];    (* ipbar(r) = Int_0^r s p(s) ds *)
Derivative[1][pfun][x_] := pp[x];

deltaPrime[x_] := -(ib[x] - 8 Pi ip[x])/(R0 x bth[x]^2);

check["the quadrature solves the Shafranov ODE",
  Simplify[D[rr bth[rr]^2 deltaPrime[rr], rr] -
    (-rr bth[rr]^2 + 8 Pi rr^2 pp[rr])/R0] === 0];

liOf[x_] := 2 ib[x]/(x^2 bth[x]^2);
betaPOf[x_] := -8 Pi ip[x]/(x^2 bth[x]^2);

check["Delta' = -(r/R0) (beta_p + l_i/2)",
  Simplify[deltaPrime[rr] + (rr/R0) (betaPOf[rr] + liOf[rr]/2)] === 0];

check["beta_p integrates by parts to 8 pi (<p> - p)/Btheta^2",
  Simplify[D[ip[rr] - (rr^2 pfun[rr] - 2 ipbar[rr]), rr]] === 0];

(* ------------------------------------------------------------------ *)
(* 5. Analytic oracle: uniform current, parabolic pressure.            *)
(* ------------------------------------------------------------------ *)

(* Btheta = Ba r/a  (uniform axial current), p = p0 (1 - r^2/a^2). *)

bthFlat[x_] := Ba x/aMinor;
pFlat[x_] := p0 (1 - x^2/aMinor^2);
ppFlat[x_] := D[pFlat[x], x];

ibFlat[x_] := Integrate[bthFlat[s]^2 s, {s, 0, x}];
ipFlat[x_] := Integrate[s^2 ppFlat[s], {s, 0, x}];

liFlat = Simplify[2 ibFlat[rr]/(rr^2 bthFlat[rr]^2)];
betaPFlat = Simplify[-8 Pi ipFlat[rr]/(rr^2 bthFlat[rr]^2)];

check["uniform current gives l_i = 1/2 at every radius",
  Simplify[liFlat - 1/2] === 0];
check["flat current + parabolic p gives radius-independent beta_p",
  Simplify[betaPFlat - 4 Pi p0/Ba^2] === 0];

deltaFlat[x_] := (aMinor^2 - x^2) (betaPFlat + 1/4)/(2 R0);

check["closed-form Delta solves Delta' = -(r/R0)(beta_p + l_i/2)",
  Simplify[D[deltaFlat[rr], rr] +
    (rr/R0) (betaPFlat + liFlat/2)] === 0];
check["closed-form Delta vanishes on the plasma boundary",
  Simplify[deltaFlat[aMinor]] === 0];
check["axis shift is the textbook (a^2/2R0)(beta_p + l_i/2)",
  Simplify[deltaFlat[0] - (aMinor^2/(2 R0)) (betaPFlat + liFlat/2)] === 0];

(* ------------------------------------------------------------------ *)
(* 6. O(eps^2) toroidal correction to q.                               *)
(* ------------------------------------------------------------------ *)

(* Shifted circles: surfaces are circles of radius r centred at
   R0 + Delta(r).  |grad r| = 1/(1 + Delta' Cos[w]) and the poloidal
   arclength is r dw, so with F = R B_phi a flux function,

     q = (r F / (2 pi psi_p')) Int dw (1 + Delta' Cos[w]) / R.        *)

(* Expand with R0 = 1/lam, Delta = lam d2, Delta' = lam d2p. *)
rGeom = 1/lam + lam d2 + rr Cos[ww];
qKernel = (1 + lam d2p Cos[ww]) (1/lam)/rGeom;
qAverage = Simplify[Integrate[Normal[Series[qKernel, {lam, 0, 2}]],
    {ww, 0, 2 Pi}]/(2 Pi)];

check["toroidal q factor is 1 + r^2/(2 R0^2) - Delta/R0 - r Delta'/(2 R0)",
  Simplify[qAverage - (1 + lam^2 (rr^2/2 - d2 - rr d2p/2))] === 0];

(* Concentric-circle limit Delta = 0 reproduces the exact 1/Sqrt[1-eps^2]. *)
check["concentric limit reproduces q_cyl/Sqrt(1 - eps^2)",
  Simplify[(qAverage /. {d2 -> 0, d2p -> 0, lam -> eps/rr}) -
    Normal[Series[1/Sqrt[1 - eps^2], {eps, 0, 2}]]] === 0];

(* Unscaled geometric factor used by the Fortran implementation.  It is a
   functional of the shift profile, so carry that profile explicitly. *)
gFactorOf[dfun_, x_] := x^2/(2 R0^2) - dfun[x]/R0 - x dfun'[x]/(2 R0);
gFactor[x_] := gFactorOf[delta, x];

(* Poloidal-beta sensitivity.  The Shafranov ODE is linear in beta_p, so
   adding a constant offset b at fixed current profile adds exactly
     Delta_b(r) = b (a^2 - r^2)/(2 R0),   G_b(r) = b (2 r^2 - a^2)/(2 R0^2),
   which is the flagged `beta_p_offset` scan knob in mhd1d. *)
deltaBeta[x_] := betaOff (aMinor^2 - x^2)/(2 R0);
check["a constant beta_p offset integrates to b (a^2 - r^2)/(2 R0)",
  Simplify[D[deltaBeta[rr], rr] + (rr/R0) betaOff] === 0 &&
  Simplify[deltaBeta[aMinor]] === 0];
check["that offset adds G_b = b (2 r^2 - a^2)/(2 R0^2) to the q factor",
  Simplify[gFactorOf[deltaBeta, rr] - rr^2/(2 R0^2) -
    betaOff (2 rr^2 - aMinor^2)/(2 R0^2)] === 0];
check["finite poloidal beta lowers the toroidal q on axis",
  Simplify[(betaOff (2 rr^2 - aMinor^2)/(2 R0^2) /. rr -> 0) < 0,
    Assumptions -> betaOff > 0 && aMinor > 0 && R0 > 0] === True];

(* The helical flux slope of the (m,n) = (1,-1) representative satisfies
   psi0' = -Btheta (1 - q) exactly in the cylinder (script 51), so the
   toroidal q correction enters it linearly. *)
check["helical flux slope responds linearly to a q correction",
  Simplify[D[-bth[rr] (1 - qcyl[rr] (1 + gFactor[rr])), qcyl[rr]] -
    bth[rr] (1 + gFactor[rr])] === 0];

(* ------------------------------------------------------------------ *)
(* 7. Toroidal m -> m+-1 sideband coupling at O(eps).                  *)
(* ------------------------------------------------------------------ *)

(* Acting with the toroidal part of Delta* on a single helical harmonic
   psiHat_m(r) Cos[m w - phi] produces exactly two sidebands.          *)

harm = psiHat[rr] Cos[mm ww - phiAng];
torPart = -(1/R0) (Cos[ww] D[harm, rr] - Sin[ww] D[harm, ww]/rr);

sidebandExpect = -(1/(2 R0)) (
    (psiHat'[rr] - mm psiHat[rr]/rr) Cos[(mm + 1) ww - phiAng] +
    (psiHat'[rr] + mm psiHat[rr]/rr) Cos[(mm - 1) ww - phiAng]);

check["toroidal operator drives exactly the m+1 and m-1 sidebands",
  Simplify[TrigExpand[torPart - sidebandExpect]] === 0];

(* Pressure/metric coupling: 4 pi R^2 P'(psi) contributes the same pair
   with coefficient 4 pi R0 r P''(psi0) per neighbour.  Project the m = 1
   driver onto the m = 2 and m = 0 sidebands by explicit Fourier integral. *)
(* Unscaled: 4 pi R^2 P'(psi) with R^2 = R0^2 (1 + 2 (r/R0) Cos[w] + ...)
   and P'(psi0 + psiHat Cos[w - phi]) expanded to first order.  pflux2 is
   P''(psi). *)
pressDrive = 4 Pi R0^2 (2 (rr/R0) Cos[ww]) pflux2[psi0[rr]] psiHat[rr] *
  Cos[ww - phiAng];
pressUp = Simplify[
  Integrate[pressDrive Cos[2 ww - phiAng], {ww, 0, 2 Pi}]/Pi];
(* The m = 0 member of Sum_m psiHat_m Cos[m w - phi] is psiHat_0 Cos[phi],
   so its projection is the w-average divided by Cos[phi]. *)
pressDown = Simplify[
  Integrate[pressDrive, {ww, 0, 2 Pi}]/(2 Pi Cos[phiAng])];
check["metric pressure coupling into the m = 2 sideband is 4 pi R0 r P''",
  Simplify[pressUp - 4 Pi R0 rr pflux2[psi0[rr]] psiHat[rr]] === 0];
check["metric pressure coupling into the m = 0 sideband is 4 pi R0 r P''",
  Simplify[pressDown - 4 Pi R0 rr pflux2[psi0[rr]] psiHat[rr]] === 0];

(* Family-specific cancellation used by the mhd1d sensitivity study: the
   force-free linear-H harmonic tends to psi1 ~ r as eps -> 0, and for that
   profile the m+1 drive (psi1' - psi1/r) vanishes identically while the
   m-1 drive (psi1' + psi1/r) does not.  The m = 2 sideband of that family
   is therefore suppressed by two extra orders in eps; the m = 0 sideband
   carries the full O(eps) coupling. *)
check["m+1 sideband drive cancels identically for psiHat ~ r",
  Simplify[(psiHat'[rr] - psiHat[rr]/rr) /. psiHat -> Function[x, cAmp x]] ===
   0];
check["m-1 sideband drive does not cancel for psiHat ~ r",
  Simplify[(psiHat'[rr] + psiHat[rr]/rr) /. psiHat -> Function[x, cAmp x]] ===
   2 cAmp];

(* Newcomb resonant factor per poloidal harmonic at fixed n: the driving
   term scales as m (1 - n q) / (m - n q) relative to the m = 1 operator
   already implemented in mhd1d (psi0' = -Btheta (1 - n q)). *)
kapRatio[m_, qq_, n_] := m (1 - n qq)/(m - n qq);
check["sideband resonant factor reduces to unity for m = 1",
  Simplify[kapRatio[1, qcyl[rr], 1] - 1] === 0];
check["m = 0 sideband carries no current-gradient drive",
  Simplify[kapRatio[0, qcyl[rr], 1]] === 0];
check["m = 2 sideband is resonant at q = 2, not at q = 1",
  Simplify[kapRatio[2, qq, 1] (2 - qq) - 2 (1 - qq)] === 0 &&
  Simplify[Limit[kapRatio[2, qq, 1], qq -> 1]] === 0];

(* ------------------------------------------------------------------ *)
(* 8. Bussac delta-W and the critical poloidal beta.                   *)
(* ------------------------------------------------------------------ *)

(* Cylindrical m = n = 1 internal kink: delta-W_cyl is proportional to
   Int r^3 (dxi/dr)^2 (1 - 1/q)^2 dr, which is positive semi-definite and
   vanishes identically for the top-hat displacement.  Toroidicity supplies
   the leading term.  Bussac, Pellat, Edery, Soule, PRL 35, 1638 (1975):

     delta-W_T = 3 pi^2 (R0 B0^2/mu0) eps_1^4 xi0^2 (13/144 - beta_p1^2)

   with eps_1 = r1/R0 the inverse aspect ratio of the q = 1 surface and
   beta_p1 the poloidal beta inside it.  The coefficient 13/144 is ADOPTED
   from that reference (their model parabolic current profile); it is not
   rederived here.  What is checked here is the algebra that follows. *)

deltaWT[bp_] := 3 Pi^2 (R0 B0^2/mu0) (r1/R0)^4 xi0^2 (13/144 - bp^2);

check["delta-W_T vanishes exactly at beta_p1 = Sqrt[13]/12",
  Simplify[deltaWT[Sqrt[13]/12]] === 0];
check["delta-W_T is destabilising above the critical poloidal beta",
  Simplify[deltaWT[bp] < 0 /. bp -> 2 Sqrt[13]/12,
    Assumptions -> R0 > 0 && B0 > 0 && mu0 > 0 && r1 > 0 && xi0 > 0] ===
   True];
check["delta-W_T is stabilising below the critical poloidal beta",
  Simplify[deltaWT[bp] > 0 /. bp -> 0,
    Assumptions -> R0 > 0 && B0 > 0 && mu0 > 0 && r1 > 0 && xi0 > 0] ===
   True];
check["critical poloidal beta is Sqrt[13]/12 = 0.30046...",
  Abs[N[Sqrt[13]/12, 20] - 0.30046260628866578485`20] < 10^-15];
check["delta-W_T scales as the fourth power of the q=1 inverse aspect ratio",
  Simplify[Exponent[deltaWT[bp] /. r1 -> eps R0, eps] - 4] === 0];

(* beta_p1 uses the same definition as section 4 evaluated at r = r1. *)
check["beta_p1 is the section-4 beta_p evaluated on the q = 1 surface",
  Simplify[(betaPOf[rr] /. rr -> r1) + 8 Pi ip[r1]/(r1^2 bth[r1]^2)] === 0];

(* ------------------------------------------------------------------ *)
(* 9. Ordering: everything vanishes at the declared power of eps.       *)
(* ------------------------------------------------------------------ *)

(* Delta/r  = O(eps),  G = O(eps^2),  sidebands = O(eps). *)

(* A shift profile of the physical form Delta = gscale r^2/R0. *)
deltaModel[x_] := gscale x^2/R0;
gScaled = Simplify[gFactorOf[deltaModel, rr] /. R0 -> rr/eps];
check["geometric q correction is exactly eps^2 (1/2 - 2 gscale)",
  Simplify[gScaled - eps^2 (1/2 - 2 gscale)] === 0];
check["geometric q correction vanishes as eps^2, not slower",
  Simplify[Limit[gScaled/eps^2, eps -> 0] - (1/2 - 2 gscale)] === 0 &&
  Simplify[Limit[gScaled/eps, eps -> 0]] === 0];

check["Shafranov shift over minor radius is O(eps) and vanishes with it",
  Simplify[Limit[(deltaFlat[rr]/rr) /. R0 -> aMinor/eps, eps -> 0]] === 0 &&
  Simplify[Limit[((deltaFlat[rr]/rr) /. R0 -> aMinor/eps)/eps,
      eps -> 0] - (aMinor^2 - rr^2) (betaPFlat + 1/4)/(2 rr aMinor)] === 0];

check["sideband amplitude is exactly first order in 1/R0",
  Simplify[D[R0 sidebandExpect, R0]] === 0 &&
  Simplify[Limit[sidebandExpect /. R0 -> rr/eps, eps -> 0]] === 0];

(* ------------------------------------------------------------------ *)
(* 10. Pins against the Fortran implementation and the retained scan.   *)
(* ------------------------------------------------------------------ *)

rootDir = DirectoryName[DirectoryName[$InputFileName]];
scan = Import[FileNameJoin[{rootDir, "runs", "mhd1d",
   "toroidal_sensitivity", "results", "summary.json"}], "RawJSON"];
rows = scan["results"];

pickA[q0_] := SelectFirst[rows,
  #["set"] == "A_forcefree_betap_scan" && #["q0_requested"] == q0 &&
    #["beta_p_offset"] == 0. &];
pickB[q0_, ee_] := SelectFirst[rows,
  #["set"] == "B_epsilon_scan" && #["q0_requested"] == q0 &&
    #["beta_p_offset"] == 0. && Abs[#["epsilon_edge"] - ee] < 10^-9 &];
pickC[aa_, bp_] := SelectFirst[rows,
  #["set"] == "C_aug_scaled" && #["r_edge_cm"] == aa &&
    #["beta_p_offset"] == bp &];

(* The toroidal-off code path must reproduce the retained independent-helical
   campaign bit for bit; these are the values pinned in script 51. *)
check["toroidal-off path reproduces the retained axis/edge responses",
  Max[Abs[(#["gain_cyl"] & /@ {pickA[1.075], pickA[1.1], pickA[1.15],
      pickA[1.2]}) - {0.2734544473618922, 0.44501684625332755,
     0.6165758906958975, 0.7023527458815959}]] < 10^-12];

(* Toroidal responses at the retained R/a = 3 operating point. *)
check["retained R/a=3 cases become amplifying when toroidicity is on",
  Max[Abs[(#["gain_tor"] & /@ {pickA[1.075], pickA[1.1], pickA[1.15],
      pickA[1.2]}) - {1.4332315494735333, 1.319578127509149,
     1.2178619402864763, 1.170865686324141}]] < 10^-9 &&
  And @@ (#["gain_cyl"] < 1 && #["gain_tor"] > 1 & /@
    {pickA[1.075], pickA[1.1], pickA[1.15], pickA[1.2]})];

(* The m = 1 flux eigenfunction is toroidally robust; the whole sensitivity
   sits in the flux-to-displacement map xi = -psi1/psi0'. *)
check["m=1 flux eigenfunction shape moves by less than 0.2 percent",
  Max[#["psi1_shape_max_rel_change"] & /@ rows] < 2 10^-3];

(* Declared eps^2 convergence of the toroidal change, measured. *)
convRatio = pickB[1.1, 0.05]["relative_gain_change"]/
  pickB[1.1, 0.02]["relative_gain_change"];
check["measured toroidal change converges as eps^2 (ratio 2.5^2)",
  Abs[convRatio - 6.25]/6.25 < 0.03];

(* Sideband ordering, measured: m=0 amplitude is exactly eps/4 of the m=1
   harmonic for this family, and m=2 is suppressed to eps^3. *)
check["m=0 sideband over m=1 amplitude equals eps/4",
  Max[Abs[(#["sideband0_over_psi1"]/(#["epsilon_edge"]/4) - 1) & /@
     {pickB[1.1, 1/3.], pickB[1.1, 0.2], pickB[1.1, 0.1],
      pickB[1.1, 0.05], pickB[1.1, 0.02]}]] < 0.01];
sb2Ratio = pickB[1.1, 0.05]["sideband2_over_psi1"]/
  pickB[1.1, 0.02]["sideband2_over_psi1"];
check["m=2 sideband is suppressed to eps^3 for this family (ratio 2.5^3)",
  Abs[sb2Ratio - 15.625]/15.625 < 0.05];

(* AUG-scaled clamping margin: the toroidal correction eats a large fraction
   of q0 - 1 at the reported poloidal beta. *)
check["AUG-scaled q0-1 loses 2.5-4.4 percent at zero poloidal beta",
  Abs[pickC[15., 0.]["delta_q_over_q_minus_one"] + 0.0248624120941995] <
    10^-9 &&
  Abs[pickC[20., 0.]["delta_q_over_q_minus_one"] + 0.0442404719808493] <
    10^-9];
check["AUG-scaled q0-1 loses 17-31 percent at the report bracket beta_p=1.5",
  Abs[pickC[15., 1.5]["delta_q_over_q_minus_one"] + 0.17386114071412365] <
    10^-9 &&
  Abs[pickC[20., 1.5]["delta_q_over_q_minus_one"] + 0.3091271005795958] <
    10^-9];
check["AUG-scaled toroidal correction always lowers q on axis",
  And @@ (#["delta_q_axis"] < 0 & /@
    Select[rows, #["set"] == "C_aug_scaled" &])];

(* Access condition. *)
access = Import[FileNameJoin[{rootDir, "runs", "mhd1d",
   "toroidal_sensitivity", "results", "bussac_access.json"}], "RawJSON"];
check["access evaluation uses the derived critical poloidal beta",
  Abs[access["beta_p_critical"] - N[Sqrt[13]/12, 20]] < 10^-14];
diiid = access["cases"][[1]];
augCase = access["cases"][[2]];
check["DIII-D 164661 sits above the Bussac critical poloidal beta",
  diiid["beta_p1"] > access["beta_p_critical"] &&
  Abs[diiid["beta_p1"] - 0.6531722037916594] < 10^-9 &&
  diiid["dW_T_over_xi0sq_J_per_m2"] < 0];
check["every scanned AUG hybrid point sits above the critical value",
  augCase["fraction_unstable"] == 1. &&
  augCase["beta_p1_min"] > access["beta_p_critical"]];

reportAndExit[];
