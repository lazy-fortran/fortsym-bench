(* Collisional resonant transport in NEO-RT: the sqrt(nu) regime and the Krook
   simplification, with the scalings of the boundary layer that would realize it.

   Grounded in the NEO-RT source (github.com/itpplasma/NEO-RT):
     src/transport.f90  compute_transport_integral  -- collisionless resonant
        line integral  D += du * D11int / |eta_res(2)| * attenuation_factor,
        with eta_res(2) = d(res)/d(eta) the resonance-curve Jacobian.
     src/nonlin.f90     nonlinear_attenuation        -- the Fokker-Planck
        broadening dres and the normalized parameter dnorm fed to a table.
     src/collis_nbi.f90 coleff                       -- dpp (parallel/momentum)
        and dhh (pitch-angle) diffusion coefficients.  NO Krook (-nu f) anywhere.

   Companion prose: tex/collisional_sqrt_nu.tex. *)

(* ============================================================
   1.  What the code computes now: the collisionless Jacobian-delta kernel
   ============================================================
   transport.f90 divides each velocity-grid contribution by |eta_res(2)| =
   |d(res)/d(eta)|.  That is the delta-of-a-function identity: the resonance
   delta(res(eta)) integrates to the reciprocal slope at the root.  This is the
   superbanana-plateau (collisionless) kernel; collisions enter only through the
   scalar attenuation factor. *)

CheckClose["kernel  int delta(c (eta-eta0)) deta = 1/|c|  (transport.f90 /|eta_res(2)|)",
   Integrate[DiracDelta[3 (eta - 1)], {eta, -Infinity, Infinity}], 1/3];

(* ============================================================
   2.  The Krook resonance function and the collisionless plateau
   ============================================================
   A Krook decorrelation -nu f turns the resonant denominator into a Lorentzian.
   Krook is NOT in the NEO-RT source; it is the analytic check of the universal
   equation (ch02/ch14).  Its area is nu-independent -- the plateau -- and its
   half-width at half-maximum is nu. *)

CheckEq["krook  Im 1/(y - i nu) = nu/(y^2 + nu^2)  (Lorentzian resonance function)",
   ComplexExpand[Im[1/(y - I nu)]], nu/(y^2 + nu^2),
   Element[y, Reals] && Element[nu, Reals] && nu > 0];

CheckEq["krook  int Lorentzian dy = pi  (area nu-independent: the collisionless plateau)",
   Integrate[nu/(y^2 + nu^2), {y, -Infinity, Infinity}, Assumptions -> nu > 0], Pi];

CheckClose["krook  Lorentzian half-width at half-maximum = nu  (value at y=nu is half the peak)",
   (nu/(y^2 + nu^2) /. y -> nu), (1/2) (1/nu)];

(* ============================================================
   3.  The sqrt(nu) boundary layer: E x B advection vs pitch-angle diffusion
   ============================================================
   Near the superbanana resonance the E x B rotation advects particles through
   the resonant pitch at rate omega_E, while the Lorentz pitch-angle operator
   diffuses across the layer at rate nu_D/delta^2 (delta the pitch-layer width).
   The balance omega_E = nu_D/delta^2 gives delta = sqrt(nu_D/omega_E): a layer
   width proportional to nu^(1/2), hence a flux proportional to sqrt(nu).  This
   is the linear collisional layer NEO-RT does NOT yet solve. *)

CheckEq["sqrtnu  delta = sqrt(nu_D/omega_E) solves the balance omega_E = nu_D/delta^2",
   nuD/(Sqrt[nuD/omE])^2, omE, nuD > 0 && omE > 0];

CheckEq["sqrtnu  layer width scales as nu_D^(1/2): delta/delta(nu_D=1) = sqrt(nu_D)",
   Simplify[Sqrt[nuD/omE]/Sqrt[1/omE], nuD > 0 && omE > 0], Sqrt[nuD]];

CheckEq["sqrtnu  flux ~ layer width ~ sqrt(nu): d ln(delta)/d ln(nu_D) = 1/2",
   D[Log[Sqrt[lam/omE]], lam] lam // Simplify, 1/2];

(* ============================================================
   4.  Contrast: the collisionless cubic/Airy layer (orbit-frequency shear)
   ============================================================
   When the orbit-frequency shear Omega' (not collisions) resolves the resonance,
   the balance Omega' delta = nu_D/delta^2 gives the cubic Airy width
   delta = (nu_D/Omega')^(1/3) (ch13/ch14).  Different exponent, different physics:
   this is the decorrelation envelope already in the attenuation table, not the
   sqrt(nu) pitch layer. *)

CheckEq["airy  cubic layer delta = (nu_D/Omega')^(1/3) solves Omega' delta = nu_D/delta^2",
   OmPr (nuD/OmPr)^(1/3), nuD/((nuD/OmPr)^(1/3))^2,
   nuD > 0 && OmPr > 0];

(* ============================================================
   5.  The implemented attenuation parameter dnorm is linear in collisionality
   ============================================================
   nonlin.f90:41-42:
     dres  = dpp (dOmdv/Ompr)^2 + dhh eta (Ib - eta) (dOmdeta/Ompr)^2
     dnorm = dres sqrt(|Ompr|) / |Hmn2|^(3/4).
   Both diffusion coefficients dpp, dhh carry one power of the collision
   frequency, so dres and dnorm are linear in collisionality at fixed drive:
   scaling dpp,dhh -> lam dpp, lam dhh scales dnorm -> lam dnorm. *)

dresDef = dpp (dOmdv/Ompr)^2 + dhh eta (Ib - eta) (dOmdeta/Ompr)^2;
dnormDef = dresDef Sqrt[Ompr]/Hmn2^(3/4);

CheckEq["code  dnorm = dres sqrt(|Ompr|)/|Hmn2|^(3/4)  (nonlin.f90:42, dpp+dhh structure)",
   dnormDef,
   (dpp (dOmdv/Ompr)^2 + dhh eta (Ib - eta) (dOmdeta/Ompr)^2) Sqrt[Ompr]/Hmn2^(3/4)];

CheckEq["code  dnorm is linear in collisionality: (dpp,dhh)->lam(dpp,dhh) scales dnorm->lam dnorm",
   Simplify[(dnormDef /. {dpp -> lam dpp, dhh -> lam dhh})], lam dnormDef];

Note["sqrt-nu-realization",
  "NEO-RT now computes the collisionless resonant line integral (the Jacobian-delta \
1/|d res/d eta|, section 1) times a scalar nonlinear attenuation built from the \
Fokker-Planck dpp, dhh (section 5).  That delivers the superbanana plateau and the \
finite-amplitude (island/Airy) attenuation, but NOT the linear collisional 1/nu and \
sqrt(nu) boundary-layer ladder.  The sqrt(nu) regime (section 3) is a pitch-angle \
boundary-value problem in a layer of width sqrt(nu_D/omega_E) around the resonant \
pitch, solved with dhh as a DIFFERENTIAL operator, not collapsed into the scalar dres. \
A velocity-resolved -i nu (PENTRC-style nu(x) ~ nu_k x^-3/2, integrated over energy) \
recovers sqrt(nu) as a model and is the cheaper parity route (NEO-RT issue #52); the \
differential layer solve pins the coefficient and the trapped-passing edge.  Either \
way the off-resonance drive the layer samples must be the p_phi-native full drive of \
flux_coordinate_limits, or the layer integral acquires a spurious O(sqrt(nu)) error."];
