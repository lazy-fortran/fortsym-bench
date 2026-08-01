(* What "decorrelation" means as an equation.
   Decorrelation = decay of the phase-coherence function C(t) = <e^{i Phi(t)}>,
   the ensemble average of the complex phase factor over collisional histories.
   Verified: the Gaussian characteristic-function identity, C(t) = e^{-delta-Phi},
   the Green-Kubo convergence, and the resonant t->inf delta-function (RPA). *)

(* 1. Gaussian characteristic function: for zero-mean Gaussian phase with variance
   sig^2,  <e^{i Phi}> = e^{-sig^2/2}.  This is the exact meaning of "randomized". *)
CheckEq["coherence: <e^{i Phi}> = e^{-VarPhi/2} for Gaussian phase",
   (1/Sqrt[2 Pi sig^2]) Integrate[Exp[I phi] Exp[-phi^2/(2 sig^2)], {phi, -Infinity, Infinity},
      Assumptions -> sig > 0],
   Exp[-sig^2/2], sig > 0];

(* 2. with VarPhi(t) = (2/3) nu_eff om_eff^2 t^3, coherence C(t) = e^{-delta-Phi(t)},
   delta-Phi = (1/3) nu_eff om_eff^2 t^3 (Kasilov's attenuation = -log C) *)
varPhi = (2/3) nueff omeff^2 t^3;
CheckEq["C(t) = e^{-VarPhi/2} = e^{-(1/3) nu om^2 t^3} = e^{-delta-Phi}",
   Exp[-varPhi/2], Exp[-(1/3) nueff omeff^2 t^3]];

(* 3. decorrelation = C -> 0 at long time (nu,om > 0): phase fully randomized *)
CheckLimit["decorrelation: C(t) -> 0 as t -> inf",
   Exp[-(1/3) nueff omeff^2 t^3], t -> Infinity, 0, nueff > 0 && omeff > 0];

(* 4. decorrelation time from C(tau_dec) = 1/e *)
CheckEq["tau_dec from C = 1/e",
   Exp[-(1/3) nueff omeff^2 ((3/(nueff omeff^2))^(1/3))^3], Exp[-1]];

(* 5. Green-Kubo: D = int_0^inf <a(0)a(tau)> dtau converges iff the autocorrelation
   decays over a finite correlation (decorrelation) time tau_c.  For a decaying
   correlation a0^2 e^{-tau/tau_c}, D = a0^2 tau_c (finite). *)
CheckEq["Green-Kubo: int_0^inf a0^2 e^{-tau/tau_c} dtau = a0^2 tau_c (finite => diffusion)",
   Integrate[a0^2 Exp[-tau/tauc], {tau, 0, Infinity}, Assumptions -> tauc > 0],
   a0^2 tauc];

(* 6. resonant phase integral: Re int_0^t e^{i a tau} dtau = sin(a t)/a *)
CheckEq["resonant integral: Re int_0^t e^{i a tau} dtau = sin(a t)/a",
   ComplexExpand[Re[Integrate[Exp[I a tau], {tau, 0, t}]]], Sin[a t]/a,
   Element[a, Reals] && Element[t, Reals]];

(* 7. RPA delta-function: the long-time limit is a nascent delta in the detuning a,
   int_{-inf}^{inf} sin(a t)/a da = pi  (t > 0)  -> Re -> pi delta(a) *)
CheckEq["RPA: int sin(a t)/a da = pi (nascent pi*delta(detuning))",
   Integrate[Sin[a t]/a, {a, -Infinity, Infinity}, Assumptions -> t > 0], Pi];
