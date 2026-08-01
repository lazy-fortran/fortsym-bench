(* Route C: the quasilinear equation from the perturbation hierarchy
   (no Airy/Scorer).  Order epsilon gives the linear response with a resonant
   denominator; order epsilon^2 gives diffusion.  Decorrelation enters
   implicitly as the +i0 (regularized by gamma = 1/tau_dec) that makes the
   resonant denominator dissipative (a Lorentzian -> pi*delta).  See the
   "Route C" explanation in docs/quasilinear_decorrelation.md. *)

(* ---------- order epsilon: linear response, resonant denominator ----------
   fluctuating eq (1D, scalar m): f1_t + Om f1_theta = -fbar'(J) H1_theta,
   H1 = Hm e^{i(m theta - om t)}.  Steady response f1 = A e^{i(m theta - om t)}
   solves it with A = - m fbar' Hm / (m Om - om). *)
H1 = Hm Exp[I (m th - om t)];
Avar = -m fbarp Hm/(m Om - om);
f1 = Avar Exp[I (m th - om t)];
drive = -fbarp D[H1, th];
CheckEq["O(eps) linear response solves f1_t + Om f1_th = -fbar' H1_th (resonant denom)",
   D[f1, t] + Om D[f1, th] - drive, 0];

(* ---------- the +i0 / Sokhotski-Plemelj: dissipation needs decorrelation ----------
   1/(a + i gamma) = a/(a^2+gamma^2) - i gamma/(a^2+gamma^2); the imaginary
   (dissipative) part is a Lorentzian of HWHM gamma. *)
CheckEq["Im 1/(a + i gamma) = -gamma/(a^2+gamma^2)",
   ComplexExpand[Im[1/(a + I gamma)]], -gamma/(a^2 + gamma^2),
   Element[a, Reals] && gamma > 0];

(* Lorentzian -> pi*delta: the dissipative part integrates to pi for any width *)
CheckEq["int gamma/(a^2+gamma^2) da = pi  (nascent pi*delta as gamma->0)",
   Integrate[gamma/(a^2 + gamma^2), {a, -Infinity, Infinity}, Assumptions -> gamma > 0], Pi];

(* Lorentzian half-width at half-maximum equals gamma (the decorrelation rate) *)
CheckEq["Lorentzian HWHM = gamma",
   (gamma/(a^2 + gamma^2) /. a -> gamma), (1/2) (gamma/(0 + gamma^2))];

(* ---------- the reactive (principal-value) part carries no diffusion ----------
   the real part is odd in detuning a, so its symmetric integral vanishes *)
CheckEq["principal-value (reactive) part is odd: int_{-L}^{L} a/(a^2+gamma^2) da = 0",
   Integrate[a/(a^2 + gamma^2), {a, -L, L}, Assumptions -> gamma > 0 && L > 0], 0];

(* ---------- QL diffusion coefficient and the role of tau_dec ----------
   Broadened single-mode coefficient D(a) = m^2 |Hm|^2 gamma/(a^2+gamma^2)
   -> pi m^2 |Hm|^2 delta(a).  Integrated rate is width-independent. *)
Dbroad = mm^2 Hm2 gamma/(a^2 + gamma^2);
CheckEq["integrated QL coefficient int D da = pi m^2 |Hm|^2 (set by resonance, not width)",
   Integrate[Dbroad, {a, -Infinity, Infinity}, Assumptions -> gamma > 0], Pi mm^2 Hm2];

(* on-resonance peak set by the decorrelation time: D(0) = m^2|Hm|^2/gamma
   = m^2|Hm|^2 tau_dec  (gamma = 1/tau_dec) *)
CheckEq["on-resonance D(0) = m^2 |Hm|^2 tau_dec  (gamma = 1/tau_dec)",
   (Dbroad /. a -> 0) /. gamma -> 1/taudec, mm^2 Hm2 taudec];

Note["route-C-decorrelation",
  "the +i0 (=> gamma=1/tau_dec) is REQUIRED for the dissipative delta; gamma=0 (no decorrelation) leaves only the reactive principal value with zero net diffusion. Decorrelation enters Route C implicitly through this regularization / long-time limit."];
