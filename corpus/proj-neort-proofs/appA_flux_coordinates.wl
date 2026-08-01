(* Appendix A: Construction of magnetic flux coordinates.
   Verified against Diss_Albert.tex, chap:Construction-of-magnetic.
   Topics: Clebsch form B = grad r x grad nu, contravariant components,
   div B = 0, periodicity of nu, toroidal/poloidal flux <-> a(r),b(r),
   straight field lines / safety factor, flux-coordinate vector potential,
   the angle transformation that cancels the periodic part of nu.

   Strategy.  The differential-geometry identities are made mechanizable by
   an EXPLICIT, invertible curvilinear map (r,phi,theta) -> Cartesian, with
   contravariant basis e_k = d x/d u^k, covariant (reciprocal) basis grad u^k,
   sqrt(g) = det of the Jacobian, and the standard cross-product / curl
   relations.  Everything else (Stokes equivalence of surface and volume flux,
   non-uniqueness of A = -nu grad r) is a derivation or modeling step recorded
   as a Note. *)

(* ---------- explicit invertible curvilinear coordinate model ----------
   A generic (non-axisymmetric-friendly) smooth invertible map with a
   non-trivial, position-dependent Jacobian so that the identities are real
   tests, not accidents of an orthonormal frame.  u1=r, u2=ph, u3=th. *)
(* y carries a minus sign so the ordered triple (r,phi,theta) reproduces the
   thesis orientation convention eps^{r phi theta}: with this handedness the
   Clebsch field has contravariant components B^phi = +d_th nu / sqrt(g),
   B^th = -d_ph nu / sqrt(g) exactly as in eq:contra1/eq:contra2.  sqrt(g) is
   defined positive as -Det of the column Jacobian (see sg below). *)
xmap[r_, ph_, th_] := {
   (R0 + r Cos[th]) Cos[ph],
   -(R0 + r Cos[th]) Sin[ph],
   r Sin[th] + eps r^2 Sin[ph]};   (* eps-term breaks orthogonality *)

uvars = {r, ph, th};
xc = xmap[r, ph, th];

(* vector/matrix equality reduced to a scalar so the harness symZeroQ (which
   tests Simplify[lhs-rhs]==0 on a SCALAR) can decide it: sum of squared
   component differences vanishes iff every component matches. *)
sq[t_] := Total[Flatten[t]^2];
CheckVec[label_, a_, b_, assum_: True] := CheckEq[label, sq[a - b], 0, assum];

(* contravariant (tangent) basis  e_k = d x / d u^k  (Jacobian columns).
   ecov[[All,k]] = e_k as a Cartesian vector. *)
jacM = Transpose[Table[D[xc, u], {u, uvars}]];  (* column k = e_k *)
ecov = jacM;
er  = ecov[[All, 1]];
eph = ecov[[All, 2]];
eth = ecov[[All, 3]];

(* sqrt(g): positive metric volume element.  The (r,phi,theta) triple of the
   model map is left-handed (Det<0), matching the thesis orientation that gives
   B^phi = +d_th nu/sqrt(g); take sqrt(g) = -Det so it is positive. *)
sg = -Det[jacM];

(* covariant (reciprocal) basis  grad u^k = rows of inverse Jacobian. *)
gradu = Inverse[jacM];                      (* row k = grad u^k *)
gradr  = gradu[[1]];
gradph = gradu[[2]];
gradth = gradu[[3]];

(* reciprocal-basis identity grad u^i . e_j = delta_ij (sanity, structural) *)
CheckVec["recip  grad u^i . e_j = delta_ij  (reciprocal basis is exact)",
   gradu . jacM, IdentityMatrix[3]];

(* sqrt(g) cross-product identity.  Left-handed triple: e_r x e_phi = -sqrt(g) grad th. *)
CheckVec["sqrtg  e_r x e_ph = -sqrt(g) grad th  (orientation of the triple)",
   Cross[er, eph], -sg gradth];

(* ---------- nu and the Clebsch field ---------- *)
(* nu in the general periodicity form eq:nu_allgemein:
   nu = a(r) ph + b(r) th + nut(r,ph,th), nut 2pi-periodic in ph and th. *)
nu = af[r] ph + bf[r] th + nut[r, ph, th];
(* gradient of a scalar f(r,ph,th) in Cartesian *)
gradScalar[f_] := D[f, r] gradr + D[f, ph] gradph + D[f, th] gradth;

(* eq:clebsch  B = grad r x grad nu *)
Bclebsch = Cross[gradr, gradScalar[nu]];

(* eq:contra1/eq:contra2  contravariant components.
   B^k = B . grad u^k.  Claim: B^r=0, B^ph=(1/sqrt g) d_th nu,
   B^th = -(1/sqrt g) d_ph nu. *)
Br  = Simplify[Bclebsch . gradr];
Bph = Simplify[Bclebsch . gradph];
Bth = Simplify[Bclebsch . gradth];

CheckEq["eq:contra0  B^r = 0", Br, 0];
CheckEq["eq:contra1  B^ph = (1/sqrt g) d_th nu",
   Bph, Simplify[D[nu, th]/sg]];
CheckEq["eq:contra2  B^th = -(1/sqrt g) d_ph nu",
   Bth, Simplify[-D[nu, ph]/sg]];

(* div B = 0:  div B = (1/sqrt g) d_k (sqrt(g) B^k).  With B^r=0 and B^ph,B^th
   above, sqrt(g) B^ph = d_th nu, sqrt(g) B^th = -d_ph nu, so
   d_ph(d_th nu) + d_th(-d_ph nu) = 0 identically (mixed partials). *)
CheckEq["divB  div B = (1/sqrt g)(d_ph(d_th nu) - d_th(d_ph nu)) = 0",
   D[D[nu, th], ph] - D[D[nu, ph], th], 0];

(* ---------- periodicity (eq:nu_allgemein, eq:Bper) ----------
   For the linear-in-angle part nu_lin = c(r)+a(r)ph+b(r)th, B = grad r x grad nu
   reduces to a(r) grad r x grad ph + b(r) grad r x grad th, which is manifestly
   2pi-periodic in ph and th (no explicit ph,th prefactor survives). *)
nulin = cf[r] + af[r] ph + bf[r] th;
Blin = Cross[gradr, gradScalar[nulin]];
Blinreduced = af[r] Cross[gradr, gradph] + bf[r] Cross[gradr, gradth];
CheckVec["eq:periodic-lin  grad r x grad(c+a ph+b th) = a grad r x grad ph + b grad r x grad th",
   Blin, Blinreduced];

(* eq:Bper  the linear-form field is single-valued/periodic:
   B(r,ph,th) = B(r,ph+2pi,th) = B(r,ph,th+2pi) as a Cartesian vector.
   This holds because no secular ph/th prefactor survives (eq:periodic-lin);
   the contravariant components B^ph=b/sqrt g, B^th=-a/sqrt g inherit only the
   2pi-periodic metric.  Verified at a rational sample point. *)
With[{pt = {r -> 7/10, ph -> 2/5, th -> 11/10, R0 -> 3, eps -> 1/4,
            af -> Function[x, x^2], bf -> Function[x, 1 + x], cf -> Function[x, x]}},
  Module[{b0, bph, bth},
    b0 = Blin /. pt;
    bph = (Blin /. ph -> ph + 2 Pi) /. pt;
    bth = (Blin /. th -> th + 2 Pi) /. pt;
    CheckClose["eq:Bper  B(ph) = B(ph+2pi)", sq[b0 - bph] // N, 0, 10^-20];
    CheckClose["eq:Bper  B(th) = B(th+2pi)", sq[b0 - bth] // N, 0, 10^-20]]];

(* eq:nonperiodic  adding a phi^2 term d(r) ph^2 yields grad r x grad(d ph^2)
   = 2 d(r) ph (grad r x grad ph), which carries an explicit ph factor and is
   therefore NON-periodic.  (Thesis prints the coefficient as d ph/2; the
   correct coefficient is 2 d ph -- see Note eq:nonper-typo.) *)
CheckVec["eq:nonperiodic  grad r x grad(d ph^2) = 2 d ph (grad r x grad ph)",
   Cross[gradr, gradScalar[df[r] ph^2]],
   2 df[r] ph Cross[gradr, gradph]];

(* ---------- toroidal / poloidal flux pick out b(r), a(r) ----------
   psi_tor'(r) = (1/(2pi)^2) int_0^2pi dph int_0^2pi dth (sqrt g B^ph)
              = (1/(2pi)^2) int int d_th nu = (1/(2pi)^2) int int (b + d_th nut).
   The periodic d_th nut integrates to zero, leaving b(r).
   Use an explicit periodic nut to make the cancellation a real integral. *)
With[{nutex = sin1 Sin[ph] + sin2 Sin[2 th] + sin3 Cos[ph + th]},
  Module[{integrand, val},
    (* integrand sqrt(g) B^ph = d_th nu with nu = a ph + b th + nut *)
    integrand = D[bv th + nutex, th];   (* a-part drops under d_th; keep b th *)
    val = (1/(2 Pi)^2) Integrate[integrand, {ph, 0, 2 Pi}, {th, 0, 2 Pi}];
    CheckEq["eq:psitor  psi_tor'(r) = b(r)  (periodic part integrates to 0)",
       val, bv]]];

With[{nutex = sin1 Sin[ph] + sin2 Sin[2 th] + sin3 Cos[ph + th]},
  Module[{integrand, val},
    (* psi_pol' = (1/(2pi)^2) int int sqrt(g) B^th = int int (-d_ph nu)
       = int int -(a + d_ph nut) -> -a(r) *)
    integrand = -D[av ph + nutex, ph];
    val = (1/(2 Pi)^2) Integrate[integrand, {ph, 0, 2 Pi}, {th, 0, 2 Pi}];
    CheckEq["eq:psipol  psi_pol'(r) = -a(r)  (periodic part integrates to 0)",
       val, -av]]];

(* eq:nuflux  with a = -psi_pol', b = psi_tor':
   nu = psi_tor' th - psi_pol' ph + nut. *)
CheckEq["eq:nuflux  nu = psi_tor' th - psi_pol' ph + nut",
   (af[r] ph + bf[r] th + nut[r, ph, th]) /. {af[r] -> -ppol'[r], bf[r] -> ptor'[r]},
   ptor'[r] th - ppol'[r] ph + nut[r, ph, th]];

(* ---------- flux coordinates (nut = 0) ---------- *)
(* eq:Bflux  pure flux form B = grad ph x grad psi_pol + grad psi_tor x grad th
   equals -psi_pol' grad r x grad ph + psi_tor' grad r x grad th.
   (psi are functions of r only, so grad psi = psi' grad r.) *)
CheckVec["eq:Bflux  grad ph x grad psi_pol + grad psi_tor x grad th = -psi_pol' (grad r x grad ph) + psi_tor' (grad r x grad th)",
   Cross[gradph, ppol'[r] gradr] + Cross[ptor'[r] gradr, gradth],
   -ppol'[r] Cross[gradr, gradph] + ptor'[r] Cross[gradr, gradth]];

(* eq:Bflux line 3: that also equals grad r x grad(psi_tor' th - psi_pol' ph) *)
CheckVec["eq:Bflux-3  = grad r x grad(psi_tor' th - psi_pol' ph)",
   -ppol'[r] Cross[gradr, gradph] + ptor'[r] Cross[gradr, gradth],
   Cross[gradr, gradScalar[ptor'[r] th - ppol'[r] ph]]];

(* eq:Bflux last line: contravariant decomposition B = (psi_pol'/sqrt g) e_th
   + (psi_tor'/sqrt g) e_ph.  Check B^ph = psi_tor'/sqrt g, B^th = psi_pol'/sqrt g
   for the flux field (nut=0). *)
With[{Bflux = Cross[gradr, gradScalar[ptor'[r] th - ppol'[r] ph]]},
  CheckEq["eq:Bflux-contra  B^ph = psi_tor'/sqrt g (flux coords)",
     Simplify[Bflux . gradph], Simplify[ptor'[r]/sg]];
  CheckEq["eq:Bflux-contra  B^th = psi_pol'/sqrt g (flux coords)",
     Simplify[Bflux . gradth], Simplify[ppol'[r]/sg]]];

(* eq:safetyb / eq:safety  straight field lines B^ph = q B^th with
   q = psi_tor'/psi_pol'. *)
CheckEq["eq:safety  B^ph/B^th = psi_tor'/psi_pol' = q",
   (ptor'[r]/sg)/(ppol'[r]/sg), ptor'[r]/ppol'[r],
   ppol'[r] != 0];
CheckEq["eq:safetyb  B^ph = q B^th with q = psi_tor'/psi_pol'",
   ptor'[r]/sg - (ptor'[r]/ppol'[r]) (ppol'[r]/sg), 0,
   ppol'[r] != 0];

(* ---------- vector potential eq:Aflux ----------
   A = psi_tor grad th - psi_pol grad ph  =>  B = curl A.
   Covariant curl: for A = A_i grad u^i (covariant comps A_r=0, A_ph=-psi_pol,
   A_th=psi_tor), B^k = (1/J) eps^{kij} d_i A_j with the SIGNED Jacobian
   J = Det[jacM] (here J = -sqrt(g) for the left-handed triple).  The two
   non-trivial components reproduce the flux field B^ph=psi_tor'/sqrt g,
   B^th=psi_pol'/sqrt g obtained above from grad r x grad nu. *)
With[{Acov = {0, -ppol[r], ptor[r]}, Jdet = Det[jacM]},  (* (A_r, A_ph, A_th) *)
  Module[{curlPh, curlTh, curlR},
    curlR  = (D[Acov[[3]], ph] - D[Acov[[2]], th])/Jdet;  (* B^r *)
    curlPh = (D[Acov[[1]], th] - D[Acov[[3]], r])/Jdet;   (* B^ph *)
    curlTh = (D[Acov[[2]], r] - D[Acov[[1]], ph])/Jdet;   (* B^th *)
    CheckEq["eq:Aflux  B^r = curl A |^r = 0", curlR, 0];
    CheckEq["eq:Aflux  B^ph = curl A |^ph = psi_tor'/sqrt g",
       curlPh, Simplify[ptor'[r]/sg]];
    CheckEq["eq:Aflux  B^th = curl A |^th = psi_pol'/sqrt g",
       curlTh, Simplify[ppol'[r]/sg]]]];

(* eq:thetaflux  the angle transformation defines a NEW flux angle thF that
   makes nu linear.  nu = psi_tor' th - psi_pol' ph + nut; with
   thF = th + nut/psi_tor' (the thesis writes th = thF - nut/psi_tor', i.e.
   thesis th0 = thF), nu = psi_tor' thF - psi_pol' ph has no periodic part.
   Equivalently: substituting thF = th + nut/psi_tor' into the linear-in-thF
   form psi_tor' thF - psi_pol' ph reproduces nu exactly. *)
CheckEq["eq:thetaflux  thF = th + nut/psi_tor' makes nu = psi_tor' thF - psi_pol' ph",
   (ptorp thF - ppolp ph) /. thF -> th + nutv/ptorp,
   ptorp th - ppolp ph + nutv,
   ptorp != 0];

(* eq:phiflux  the alternative flux angle phF = ph - nut/psi_pol' also
   linearizes nu: psi_tor' th - psi_pol' phF = psi_tor' th - psi_pol' ph + nut. *)
CheckEq["eq:phiflux  phF = ph - nut/psi_pol' makes nu = psi_tor' th - psi_pol' phF",
   (ptorp th - ppolp phF) /. phF -> ph - nutv/ppolp,
   ptorp th - ppolp ph + nutv,
   ppolp != 0];

(* ---------- Notes (definitions / derivations without a mechanical check) ---- *)
Note["eq:stokes",
  "Stokes/Gauss equivalence of the surface flux int_S B.dS and the volume \
integral (1/2pi) int_V B.grad phi dV: a vector-calculus derivation using \
div B = 0 and field lines lying in the toroidal surface; the cut-torus \
boundary argument is not a single mechanizable algebraic identity."];

Note["eq:Anonunique",
  "A = -nu grad r is a valid vector potential (curl gives the same B) but is \
non-unique / multivalued in the angle coordinates because nu carries the \
secular a ph + b th terms; this is a gauge/topology statement, not an algebraic \
check."];

Note["eq:Bper-def",
  "Periodicity requirement eq:Bper B(r0,phi,theta)=B(r0,phi+2pi,theta)=B(r0,phi,theta+2pi) \
is the physical single-valuedness boundary condition that motivates the linear+periodic \
split of nu (eq:nu_allgemein); the consequence is tested in eq:periodic-lin / eq:nonperiodic."];

Note["eq:nonper-typo",
  "Thesis writes grad r x grad(d(r) ph^2) = (d' ph^2)(grad r x grad r) + d (ph/2) grad phi; \
the second coefficient should be 2 d ph (and the cross product grad r x grad phi), since \
grad(d ph^2) = d' ph^2 grad r + 2 d ph grad phi. Verified correct form in eq:nonperiodic."];
