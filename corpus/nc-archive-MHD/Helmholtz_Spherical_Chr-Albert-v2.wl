LegendreP[1, 1, Cos[θ]]]                                                                                                                                                                           Ψ (r)/. sol]
                                                                                                                                                                                                               k
HoldForm[Example*vector*field

$Assumptions = {r > 0, Element[m, Integers], Element[q, Reals]}; 

Subscript[ψ, 1] = (-Subscript[a, 1])*r^(m + 1)*Sin[θ]^2*LegendreP[m, 1, Cos[θ]]; , Null, Subscript[ψ, 2] = (-Subscript[a, 3])*q*r*SphericalBesselJ[m, q*r]*Sin[θ]^2*LegendreP[m, 1, Cos[θ]]; 

A = FullSimplify[(Subscript[ψ, 2]/(Sin[θ]^2*r^2))*Grad[Subscript[ψ, 1] + Subscript[ψ, 2], {r, θ, ϕ}, "Spherical"]]

Compute*divergence*and*curl*of*A

DivA = Simplify[Div[A, {r, θ, ϕ}, "Spherical"]]

CurlA = Simplify[Curl[A, {r, θ, ϕ}, "Spherical"]]

Solve*in*potential*fields

LaplacePhi = (-Laplacian[Subscript[Ψ, k][r], {r, θ, ϕ}, "Spherical"])*l*(l + 1)*LegendreP[l, 0, Cos[θ]]

DivA[[1]]

HoldForm[sol = Simplify[Flatten[DSolve[LaplacePhi == DivA, Subscript[Ψ, k][r], r] /. {K[1] -> ρ, K[2] -> ρ}]]; , Null,
