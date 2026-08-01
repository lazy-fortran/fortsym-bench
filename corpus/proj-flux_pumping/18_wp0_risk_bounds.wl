(* WP0 risk bounds: executable numerical dispositions for the four open
   risks of the local helical-current model -- toroidal (2,1) sideband,
   ECRH/ECCD suprathermal electrons, near-axis m=1 regularity, and
   trapped-ion nonlocality. Each risk gets either a bounded exclusion with
   an explicit numerical bound or a pinned handoff to a planned WP2/WP4
   test. Parameters are the AUG helical-core numbers used in
   flux_pumping.tex (scripts 04, 09, 06) and the AUG #36663 anchor. *)

Get[FileNameJoin[{DirectoryName[$InputFileName], "checklib.wl"}]];

(* shared AUG helical-core reference numbers (CGS, keV, MA) *)
R0 = 165;                 (* major radius, cm *)
rCore = 10;               (* helical-core radius, cm *)
rhoLiD = 72/100;          (* D Larmor radius at 5 keV, B=2 T, cm *)
meOverMD = 1/3672;        (* m_e / m_D, m_D = 2*1836 m_p *)
Eref = 5;                 (* reference energy for rhoLiD, keV *)
TeCore = 5/2;             (* core electron temperature, keV *)
ZDelta = 4/100;           (* normalized ExB frequency, |Z_Delta| *)
IECCD = 1/10;             (* central ECCD current, MA *)
Ip = 8/10;                (* plasma current, MA *)

(* Larmor radius scales as sqrt(mass * energy); electron radius at energy
   Efast (keV) relative to the 5 keV deuterium reference. *)
rhoLe[Ekev_] := rhoLiD Sqrt[meOverMD (Ekev/Eref)];

(* ========================================================= *)
(* Risk 1: toroidal (2,1) sideband coupling of the (1,1) mode *)
(* ========================================================= *)
(* Toroidal geometry couples a primary poloidal harmonic m to its m+-1
   neighbours with strength epsilon = r/R. The (2,1) neighbour of the
   (1,1) helical mode is non-resonant in the core (its rational surface
   q=2 does not occur where q~1), so it carries no layer amplification,
   unlike the near-resonant primary with detuning Dq=|q-1|. *)
epsCore = rCore/R0;
DqPrimary = 1/100;                       (* primary (1,1) detuning |q-1| *)
DqSideband = Abs[2 - 1];                 (* (2,1) detuning at q~1, O(1) *)
sidebandGeometric = epsCore;             (* coupling-only upper bound *)
sidebandResonant = epsCore (DqPrimary/DqSideband);  (* with detuning *)

check["Risk1 sideband: toroidal coupling epsilon=r/R is below 10%",
  N[sidebandGeometric] < 1/10];
check["Risk1 sideband: (2,1) is off-resonant, detuning >= 100x the primary",
  N[DqSideband/DqPrimary] >= 100];
check["Risk1 sideband: detuned current ratio below 0.1% of the primary",
  N[sidebandResonant] < 1/1000];
check["Risk1 sideband: bounded exclusion, WP2 targeted (2,1) run planned",
  N[sidebandGeometric] < 1/10 && N[sidebandResonant] < N[sidebandGeometric]];

(* ========================================================= *)
(* Risk 2: ECRH/ECCD suprathermal electrons                   *)
(* ========================================================= *)
(* Locality: even 100 keV electrons have orbit widths far below the core,
   so the local kinetic description holds geometrically. Response: fast
   electrons are less collisional (nu ~ v^-3), so |Z_Delta| stays on the
   collisionless plateau W->1. Drive: the non-Maxwellian correction is
   bounded by the ECCD current fraction; a two-population extension is the
   planned WP2 refinement. *)
widthRatio[Ekev_] := rhoLe[Ekev]/rCore;
ZDeltaFast = ZDelta (TeCore/30)^(3/2);       (* nu ~ v^-3 for 30 keV tail *)
driveFraction = IECCD/Ip;

check["Risk2 suprathermal: 30 keV electron orbit width below 1% of core",
  N[widthRatio[30]] < 1/100];
check["Risk2 suprathermal: even 100 keV stays local, margin above 100",
  N[rCore/rhoLe[100]] > 100];
check["Risk2 suprathermal: fast |Z_Delta| stays below thermal, plateau W->1",
  N[ZDeltaFast] < ZDelta && N[ZDeltaFast] < 1/10];
check["Risk2 suprathermal: drive error bounded by ECCD fraction ~12.5%",
  N[driveFraction] == 1/8 && N[driveFraction] < 3/20];

(* ========================================================= *)
(* Risk 3: near-axis m=1 regularity (r -> 0 in every solver)  *)
(* ========================================================= *)
(* The m=1 current envelope starts proportional to r for regularity
   (flux_pumping.tex, l=1 model). Then the redistribution boundary current
   vanishes as r^2 at the axis (no spurious axis current) and the averaged
   redistributed current stays finite. The analytic m=1 vector potential
   is regular at the axis with a linear approach. *)
Clear[Jc, d0, alpha, rc, r];
Jenv[rr_] := Jc rr;                          (* regular m=1 envelope ~ r *)
boundaryCurrent[rr_] := Pi R0 rr d0 Jenv[rr] Cos[alpha];  (* pi R r d0 j_m *)
jBarAxis = d0 Cos[alpha]/(2 rr) D[rr Jenv[rr], rr] /. rr -> r;  (* memo redistribution *)
aPot[rr_] := (rc^3/(4 rr)) (1 - Exp[-(rr/rc)^2]);  (* analytic m=1 A_z *)
bcSeries = Normal@Series[boundaryCurrent[rr], {rr, 0, 2}];

check["Risk3 near-axis: redistribution boundary current has no linear term",
  Coefficient[bcSeries, rr, 1] === 0 && Coefficient[bcSeries, rr, 2] =!= 0];
check["Risk3 near-axis: boundary current vanishes as r^2 at the axis",
  Limit[boundaryCurrent[rr]/rr, rr -> 0] == 0];
check["Risk3 near-axis: averaged redistributed current is finite on axis",
  Limit[jBarAxis, r -> 0] === d0 Cos[alpha] Jc];
check["Risk3 near-axis: analytic m=1 potential is regular (linear) on axis",
  Limit[aPot[rr], rr -> 0] == 0 && Limit[aPot[rr]/rr, rr -> 0] === rc/4];

(* ========================================================= *)
(* Risk 4: trapped-ion nonlocality                            *)
(* ========================================================= *)
(* Trapped ions are nonlocal in the core, so they are handed to GORILLA
   full-f inside the potato boundary; electrons stay local everywhere, so
   the WP2 NEO-2-QL electron calculation is valid. The handoff radius is
   pinned by the closed potato-boundary formula. This risk is a planned
   WP4 test with a pinned boundary, not a bounded exclusion. *)
qAxis = 1;
rPot = (2 qAxis rhoLiD)^(2/3) R0^(1/3);           (* potato boundary, cm *)
trappedDWidth = 6;                                (* trapped-D width, cm *)
trappedEWidth = Sqrt[R0/rCore] rhoLe[TeCore];     (* trapped-e banana, cm *)

check["Risk4 trapped-ion: potato boundary formula gives ~7 cm",
  N[Abs[rPot - 7]] < 1/2];
check["Risk4 trapped-ion: trapped-D width is not small vs core, nonlocal",
  N[trappedDWidth/rCore] > 1/10];
check["Risk4 trapped-ion: trapped-electron width stays below 3% of core",
  N[trappedEWidth/rCore] < 3/100];
check["Risk4 trapped-ion: electrons local (WP2), ions handed to GORILLA (WP4)",
  N[trappedEWidth/rCore] < 3/100 && N[trappedDWidth/rCore] > 1/10];

reportAndExit[];
