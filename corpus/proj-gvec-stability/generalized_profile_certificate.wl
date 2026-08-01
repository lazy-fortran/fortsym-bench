ClearAll["Global`*"];
pass = 0; fail = 0;
check[name_, condition_] := If[TrueQ[FullSimplify[condition]],
  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]];

(* A two-dimensional symbolic fixture proves the congruence and shifted
   residual identities entry by entry.  The production implementation uses
   the same identities for arbitrary dimension. *)
k = {{k11, k12}, {k12, k22}};
m = {{m11, m12}, {m12, m22}};
s = DiagonalMatrix[{s1, s2}];
y = {y1, y2};
x = s . y;
a = s . k . s;
b = s . m . s;
c = s . (k - sigma m) . s;
assumptions = Element[{k11, k12, k22, m11, m12, m22, s1, s2,
     y1, y2, lambda, sigma}, Reals] && s1 != 0 && s2 != 0;

check["diagonal congruence maps the generalized residual",
 FullSimplify[s . (k . x - lambda m . x) ==
   a . y - lambda b . y, assumptions]];
check["shifted residual is algebraically identical",
 FullSimplify[a . y - lambda b . y ==
   c . y - (lambda - sigma) b . y, assumptions]];
check["shifted Rayleigh quotient is invariant",
 FullSimplify[(x . k . x)/(x . m . x) ==
   sigma + (y . c . y)/(y . b . y),
  assumptions && x . m . x != 0]];

(* Full mass whitening.  With B=U^T U and z=U y, the mass-weighted residual
   norm is the Euclidean residual norm of the standard symmetric problem. *)
u = {{u11, u12}, {0, u22}};
bCholesky = Transpose[u] . u;
aGeneral = {{a11, a12}, {a12, a22}};
z = u . y;
aStandard = Inverse[Transpose[u]] . aGeneral . Inverse[u];
rGeneral = aGeneral . y - lambda bCholesky . y;
rStandard = Inverse[Transpose[u]] . rGeneral;
choleskyAssumptions = Element[{u11, u12, u22, a11, a12, a22,
     y1, y2, lambda}, Reals] && u11 != 0 && u22 != 0;
check["Cholesky whitening produces a standard residual",
 FullSimplify[rStandard == aStandard . z - lambda z,
  choleskyAssumptions]];
check["mass normalization becomes Euclidean normalization",
 FullSimplify[y . bCholesky . y == z . z, choleskyAssumptions]];

(* The certified eigenvalue may differ from the vector's Rayleigh quotient.
   This exact decomposition plus the triangle inequality gives
   ||r(lambdaStar)|| <= ||r(q)|| + |q-lambdaStar| for ||z||=1. *)
check["certified-eigenvalue residual decomposition",
 FullSimplify[(aStandard . z - lambdaStar z) ==
   (aStandard . z - q z) + (q - lambdaStar) z,
  choleskyAssumptions && Element[{q, lambdaStar}, Reals]]];

(* Exact two-level Davis-Kahan fixture.  For a normalized vector rotated by
   theta from the wanted eigenvector, residual/separation = tan(theta), which
   bounds sin(theta). *)
twoLevel = DiagonalMatrix[{lambda1, lambda2}];
trial = {Cos[theta], Sin[theta]};
rayleigh = FullSimplify[trial . twoLevel . trial];
trialResidual = FullSimplify[twoLevel . trial - rayleigh trial];
residualNorm = FullSimplify[Sqrt[trialResidual . trialResidual],
  0 < theta < Pi/2 && lambda2 > lambda1];
unwantedSeparation = FullSimplify[lambda2 - rayleigh,
  0 < theta < Pi/2 && lambda2 > lambda1];
check["two-level residual over unwanted separation is tangent angle",
 FullSimplify[residualNorm/unwantedSeparation == Tan[theta],
  0 < theta < Pi/2 && lambda2 > lambda1]];
check["Davis-Kahan residual ratio bounds the eigenspace angle",
 Reduce[Sin[theta] > Tan[theta] && 0 < theta < Pi/2,
   theta, Reals] === False];

(* The outer interval contains exactly one level and the refined interval
   contains that same level.  These are the conservative separations used by
   the CLI for lower and upper unwanted spectra. *)
check["refined-to-outer lower separation is positive",
 FullSimplify[innerLower - outerLower > 0,
  outerLower < innerLower < innerUpper < outerUpper]];
check["refined-to-outer upper separation is positive",
 FullSimplify[outerUpper - innerUpper > 0,
  outerLower < innerLower < innerUpper < outerUpper]];

Print["pass = ", pass, " fail = ", fail];
Quit[If[fail == 0, 0, 1]];
