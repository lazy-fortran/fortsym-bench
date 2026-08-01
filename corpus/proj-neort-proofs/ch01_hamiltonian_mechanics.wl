(* Chapter 1: Hamiltonian mechanics.
   Verified against Diss_Albert.tex, sec. "A one-dimensional example"
   (pendulum / cosine potential, action-angle variables).
   Thesis elliptic convention K(kappa), E(kappa) with kappa = k^2 matches
   Mathematica EllipticK[m], EllipticE[m] (parameter convention). *)

(* --- pendulum / cosine potential setup --- *)
U[x_]   := U0 (1 - Cos[x]);          (* cosine potential, eq:pend *)
kappaH  = H/(2 U0);                   (* kappa = H/(2 U0) *)
pfun[x_, s_] := s Sqrt[2 mA (H - U[x])];  (* p(x,H), sigma = s *)

(* eq:Uhalf  potential half-angle form  U = 2 U0 sin^2(x/2) *)
CheckEq["eq:Uhalf  1-cos x = 2 sin^2(x/2)",
   1 - Cos[x], 2 Sin[x/2]^2];

(* eq:turnpoints  two equivalent turning-point expressions; verify via the
   defining relation cos(x+) = 1-2k (principal branch), plus a numeric sample *)
CheckEq["eq:turnpoints  cos(2 arcsin sqrt k) = 1-2k",
   Cos[2 ArcSin[Sqrt[kap]]], 1 - 2 kap, 0 < kap < 1];
CheckClose["eq:turnpoints  arccos(1-2k) = 2 arcsin(sqrt k) at k=3/10",
   ArcCos[1 - 2 (3/10)], 2 ArcSin[Sqrt[3/10]]];

(* eq:dpdH  d p/dH = m/p *)
CheckEq["eq:dpdH  dp/dH = m_a/p",
   D[pfun[x, 1], H], mA/pfun[x, 1], U0 > 0 && mA > 0 && H > U[x]];

(* eq:Jt  trapped action closed form (numeric, integral vs elliptic form) *)
With[{mAv = 1, U0v = 7/5, kv = 3/10},
  Module[{Hv, xp, Jint, Jclosed},
    Hv = 2 U0v kv;
    xp = 2 ArcSin[Sqrt[kv]];
    Jint = (1/Pi) NIntegrate[
       Sqrt[2 mAv (Hv - 2 U0v Sin[x/2]^2)], {x, -xp, xp},
       WorkingPrecision -> 30];
    Jclosed = Sqrt[mAv U0v] (8/Pi) (EllipticE[kv] - (1 - kv) EllipticK[kv]);
    CheckClose["eq:Jt  trapped action: integral = elliptic form", Jint, Jclosed]]];

(* eq:Jt  derivative identity d/dk [E(k)-(1-k)K(k)] = K(k)/2 (the step that
   makes tau_b and Omega come out; verified symbolically) *)
CheckEq["eq:Jt-step  d/dk[E-(1-k)K] = K/2",
   D[EllipticE[k] - (1 - k) EllipticK[k], k], EllipticK[k]/2, 0 < k < 1];

(* eq:tau_trapp / Omega  from J(H): (dJ/dH)^{-1} = Omega, tau_b = 2pi dJ/dH *)
Jtrap[HH_] := Sqrt[mA U0] (8/Pi) (EllipticE[HH/(2 U0)] - (1 - HH/(2 U0)) EllipticK[HH/(2 U0)]);
CheckEq["eq:tau_trapp  tau_b = 2pi dJ/dH = sqrt(m/U0) 4 K(k)",
   2 Pi D[Jtrap[H], H], Sqrt[mA/U0] 4 EllipticK[H/(2 U0)],
   U0 > 0 && mA > 0 && 0 < H < 2 U0];
CheckEq["eq:Omega_trapp  Omega = (dJ/dH)^{-1} = sqrt(U0/m) pi/(2K)",
   1/D[Jtrap[H], H], Sqrt[U0/mA] Pi/(2 EllipticK[H/(2 U0)]),
   U0 > 0 && mA > 0 && 0 < H < 2 U0];

(* eq:harmonic  harmonic limit Omega -> sqrt(U0/m) as kappa -> 0 *)
CheckLimit["eq:harmonic  Omega -> sqrt(U0/m) as k->0",
   Sqrt[U0/mA] Pi/(2 EllipticK[k]), k -> 0, Sqrt[U0/mA], U0 > 0 && mA > 0];

(* eq:Jpend  passing action closed form (numeric) *)
With[{mAv = 1, U0v = 1, kv = 13/10},
  Module[{Hv, Jint, Jclosed},
    Hv = 2 U0v kv;
    Jint = (1/(2 Pi)) NIntegrate[
       Sqrt[2 mAv (Hv - 2 U0v Sin[x/2]^2)], {x, -Pi, Pi},
       WorkingPrecision -> 30];
    Jclosed = Sqrt[mAv U0v] (4 Sqrt[kv]/Pi) EllipticE[1/kv];
    CheckClose["eq:Jpend  passing action: integral = elliptic form", Jint, Jclosed]]];

(* eq:taub_pass / Omega (passing)  from J(H), symbolic, kappa = H/(2U0) > 1 *)
Jpass[HH_] := Sqrt[mA U0] (4 Sqrt[HH/(2 U0)]/Pi) EllipticE[2 U0/HH];
CheckEq["eq:taub_pass  tau_b = 2pi dJ/dH = sqrt(m/U0) 2K(1/k)/sqrt(k)",
   2 Pi D[Jpass[H], H], Sqrt[mA/U0] 2 EllipticK[2 U0/H]/Sqrt[H/(2 U0)],
   U0 > 0 && mA > 0 && H > 2 U0];
CheckEq["eq:Omega_pass  Omega = (dJ/dH)^{-1} = sqrt(U0/m) pi sqrt(k)/K(1/k)",
   1/D[Jpass[H], H], Sqrt[U0/mA] Pi Sqrt[H/(2 U0)]/EllipticK[2 U0/H],
   U0 > 0 && mA > 0 && H > 2 U0];

(* eq:thetatau  theta = Omega*tau, consistent with Omega = 2pi/tau_b *)
CheckEq["eq:thetatau  Omega tau_b = 2 pi",
   (2 Pi/taub) taub, 2 Pi];

(* Thesis annotation: the prefactor in the intermediate line of eq:Jt reads
   sqrt(2 m U0)/pi but must be 2 sqrt(m U0)/pi for the final result; the
   boxed result eq:Jt is correct. *)
Note["eq:Jt-intermediate",
  "intermediate prefactor printed as sqrt(2 m U0)/pi; correct value is 2 sqrt(m U0)/pi (final boxed eq:Jt is right)"];
