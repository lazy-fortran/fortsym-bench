r0[ϕ_] := R0[ϕ]*{Cos[ϕ], Sin[ϕ], 0} + Z0[ϕ]*{0, 0, 1}; 

radial = {Cos[ϕ], Sin[ϕ], 0}; , Null, toroidal = {-Sin[ϕ], Cos[ϕ], 0}; , Null, vertical = {0, 0, 1}; 

normal = kR[ϕ]*radial + kTh[ϕ]*toroidal + kZ[ϕ]*vertical; , Null, binormal = tR[ϕ]*radial + tTh[ϕ]*toroidal + tZ[ϕ]*vertical; , Null, tangent = bR[ϕ]*radial + bTh[ϕ]*toroidal + bZ[ϕ]*vertical; 

X1 = X1c[ϕ]*Cos[θ] + X1s[ϕ]*Sin[θ]; , Null, Y1 = Y1c[ϕ]*Cos[θ] + Y1s[ϕ]*Sin[θ]; , Null, x1[ϕ_, θ_] := ϵ*X1*normal + ϵ*Y1*binormal; 

x[ϕ_, θ_] := r0[ϕ] + x1[ϕ, θ]; , Null, R[ϕ_, θ_] := Sqrt[x[ϕ, θ][[1]]*x[ϕ, θ][[1]] + x[ϕ, θ][[2]]*x[ϕ, θ][[2]]]; , Null, Z[ϕ_, θ_] := x[ϕ, θ][[3]]; , Null, TanPhiCyl[ϕ_, θ_] := x[ϕ, θ][[2]]/x[ϕ, θ][[1]]; 

Clear[R1stExp], Null, R1stExp = FullSimplify[Series[R[ϕ, θ], {ϵ, 0, 2}]]

R1stExpFun[ϕ_, θ_] := R0[ϕ] + (kR[ϕ]*(Cos[θ]*X1c[ϕ] + Sin[θ]*X1s[ϕ]) + tR[ϕ]*(Cos[θ]*Y1c[ϕ] + Sin[θ]*Y1s[ϕ]))*ϵ + (1/(2*R0[ϕ]))*((kTh[ϕ]*(Cos[θ]*X1c[ϕ] + Sin[θ]*X1s[ϕ]) + tTh[ϕ]*(Cos[θ]*Y1c[ϕ] + Sin[θ]*Y1s[ϕ]))^2*ϵ^2); 

TanPhi1stExp = Series[TanPhiCyl[ϕ, θ], {ϵ, 0, 2}]; 

Phi1stExp = FullSimplify[ArcTan[TanPhi1stExp] - ArcTan[Tan[ϕ]]]

Phi1stExpFun[ϕ_, θ_] := (1/R0[ϕ])*((Cos[θ]*kTh[ϕ]*X1c[ϕ] + kTh[ϕ]*Sin[θ]*X1s[ϕ] + Cos[θ]*tTh[ϕ]*Y1c[ϕ] + Sin[θ]*tTh[ϕ]*Y1s[ϕ])*ϵ) - (1/R0[ϕ]^2)*(kR[ϕ]*(Cos[θ]*X1c[ϕ] + Sin[θ]*X1s[ϕ]) + tR[ϕ]*(Cos[θ]*Y1c[ϕ] + Sin[θ]*Y1s[ϕ]))*(kTh[ϕ]*(Cos[θ]*X1c[ϕ] + Sin[θ]*X1s[ϕ]) + tTh[ϕ]*(Cos[θ]*Y1c[ϕ] + Sin[θ]*Y1s[ϕ]))*ϵ^2; 

R1full = Collect[FullSimplify[Series[R1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c], θ], θ], θ], {ϵ, 0, 1}]] - R0[Subscript[ϕ, c]], {Cos[θ], Sin[θ]}] /. {Sqrt[R0[Subscript[ϕ, c]]^2] -> R0[Subscript[ϕ, c]]}

Z1stExp = Normal[FullSimplify[Series[Z[ϕ, θ], {ϵ, 0, 2}]]]

Z1stExpFun[ϕ_, θ_] := ϵ*(kZ[ϕ]*(Cos[θ]*X1c[ϕ] + Sin[θ]*X1s[ϕ]) + tZ[ϕ]*(Cos[θ]*Y1c[ϕ] + Sin[θ]*Y1s[ϕ])) + Z0[ϕ]

Z1full = Collect[Series[Z1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c] - Phi1stExpFun[Subscript[ϕ, c], θ], θ], θ], θ], {ϵ, 0, 1}] - Z0[Subscript[ϕ, c]], {Cos[θ], Sin[θ]}]

Null

ClearAll["Global'*"], Null, radial = {Cos[ϕ], Sin[ϕ], 0}; , Null, toroidal = {-Sin[ϕ], Cos[ϕ], 0}; , Null, vertical = {0, 0, 1}; 

r0[ϕ_] := R0[ϕ]*radial + Z0[ϕ]*vertical, Null, x1[ϕ_, θ_] := ϵ*(x1R[ϕ, θ]*radial + x1Th[ϕ, θ]*toroidal + x1Z[ϕ, θ]*vertical), Null, x2[ϕ_, θ_] := ϵ^2*(x2R[ϕ, θ]*radial + x2Th[ϕ, θ]*toroidal + x2Z[ϕ, θ]*vertical)

Null

x[ϕ_, θ_] := r0[ϕ] + x1[ϕ, θ] + x2[ϕ, θ], Null, R[ϕ_, θ_] := Sqrt[x[ϕ, θ][[1]]*x[ϕ, θ][[1]] + x[ϕ, θ][[2]]*x[ϕ, θ][[2]]], Null, Z[ϕ_, θ_] := x[ϕ, θ][[3]]; , Null, TanPhiCyl[ϕ_, θ_] := x[ϕ, θ][[2]]/x[ϕ, θ][[1]]

R2ndExp = Normal[FullSimplify[Series[R[ϕ, θ], {ϵ, 0, 3}]]]

Simplify[R2ndExp]

R2ndExpFun[ϕ_, θ_] := R0[ϕ] + ϵ*x1R[ϕ, θ] + (ϵ^2*(x1Th[ϕ, θ]^2 + 2*R0[ϕ]*x2R[ϕ, θ]))/(2*R0[ϕ]) + (1/(2*R0[ϕ]^2))*(ϵ^3*x1Th[ϕ, θ]*((-x1R[ϕ, θ])*x1Th[ϕ, θ] + 2*R0[ϕ]*x2Th[ϕ, θ])); 

Z2ndExp = Normal[FullSimplify[Series[Z[ϕ, θ], {ϵ, 0, 3}]]]

Z2ndExpFun[ϕ_, θ_] := ϵ*x1Z[ϕ, θ] + ϵ^2*x2Z[ϕ, θ] + Z0[ϕ]

Phi2ndExp = Normal[FullSimplify[ArcTan[Series[TanPhiCyl[ϕ, θ], {ϵ, 0, 3}]] - ArcTan[Tan[ϕ]]]]

Phi2ndExpFun[ϕ_, θ_] := (ϵ*x1Th[ϕ, θ])/R0[ϕ] + (1/R0[ϕ]^2)*(ϵ^2*((-x1R[ϕ, θ])*x1Th[ϕ, θ] + R0[ϕ]*x2Th[ϕ, θ])) - (1/(3*R0[ϕ]^3))*(ϵ^3*(-3*x1R[ϕ, θ]^2*x1Th[ϕ, θ] + x1Th[ϕ, θ]^3 + 3*R0[ϕ]*x1Th[ϕ, θ]*x2R[ϕ, θ] + 3*R0[ϕ]*x1R[ϕ, θ]*x2Th[ϕ, θ])); 

deltaPhi2 = Series[Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], {ϵ, 0, 2}]

Clear[nuOrder1]

nuOrder1[ϕ_] := -((ϵ*x1Th[ϕ, θ])/R0[ϕ]); , Null, nuOrder2[ϕ_] := -((1/R0[ϕ]^2)*(ϵ^2*((-x1R[ϕ, θ])*x1Th[ϕ, θ] + R0[ϕ]*x2Th[ϕ, θ]))); , Null, nu[ϕ_] := nu0[ϕ] + nuOrder1[ϕ] + nuOrder2[ϕ]; 

nuFull = Normal[FullSimplify[Series[nu[Subscript[ϕ, c] - deltaPhi2], {ϵ, 0, 3}]]]

DeltaR = Series[R2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], θ] - R0[Subscript[ϕ, c]], {ϵ, 0, 2}]

DeltaR2 = Coefficient[DeltaR, ϵ^2]; 

DeltaR2man = (-(1/2))*D[D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]]*(x1Th[Subscript[ϕ, c], θ]^2/R0[Subscript[ϕ, c]]^2) - (x2Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]] - (x1R[Subscript[ϕ, c], θ]*x1Th[Subscript[ϕ, c], θ])/R0[Subscript[ϕ, c]]^2)*D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[x1R[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[R0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]] + (x2R[Subscript[ϕ, c], θ] + x1Th[Subscript[ϕ, c], θ]^2/(2*R0[Subscript[ϕ, c]])); 

Simplify[DeltaR2 - DeltaR2man]

DeltaZ = Series[Z2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c] - Phi2ndExpFun[Subscript[ϕ, c], θ], θ], θ], θ] - Z0[Subscript[ϕ, c]], {ϵ, 0, 2}]

DeltaZ2 = Coefficient[DeltaZ, ϵ^2]; 

DeltaZ2man = x2Z[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[x1Z[Subscript[ϕ, c], θ] - (x1Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]])*D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]] - (x2Th[Subscript[ϕ, c], θ]/R0[Subscript[ϕ, c]] - (x1R[Subscript[ϕ, c], θ]*x1Th[Subscript[ϕ, c], θ])/R0[Subscript[ϕ, c]]^2)*D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]] - (x1Th[Subscript[ϕ, c], θ]^2/(2*R0[Subscript[ϕ, c]]^2))*D[D[Z0[Subscript[ϕ, c]], Subscript[ϕ, c]], Subscript[ϕ, c]]; 

Simplify[DeltaZ2 - DeltaZ2man]

x1th = X1thc[ϕ]*Cos[θ] + X1ths[ϕ]*Sin[θ]; , Null, x1R = X1Rc[ϕ]*Cos[θ] + X1Rs[ϕ]*Sin[θ]; , Null, x2th = X2thc[ϕ]*Cos[2*θ] + X2ths[ϕ]*Sin[2*θ] + X2th0[ϕ]; , Null, x2R = X2Rc[ϕ]*Cos[2*θ] + X2Rs[ϕ]*Sin[2*θ] + X2R0[ϕ]; , Null, x1z = X1zc[ϕ]*Cos[θ] + X1zs[ϕ]*Sin[θ]; , Null, x2z = X2zc[ϕ]*Cos[2*θ] + X2zs[ϕ]*Sin[2*θ] + X2z0[ϕ]; 

delR2 = (-(1/2))*D[D[R0[ϕ], ϕ], ϕ]*(x1th^2/R0[ϕ]^2) - (x2th/R0[ϕ] - (x1R*x1th)/R0[ϕ]^2)*D[R0[ϕ], ϕ] - (x1th/R0[ϕ])*D[x1R - (x1th/R0[ϕ])*D[R0[ϕ], ϕ], ϕ] + (x2R + x1th^2/(2*R0[ϕ])); 

delZ2 = (-(1/2))*D[D[Z0[ϕ], ϕ], ϕ]*(x1th^2/R0[ϕ]^2) - (x2th/R0[ϕ] - (x1R*x1th)/R0[ϕ]^2)*D[Z0[ϕ], ϕ] - (x1th/R0[ϕ])*D[x1z - (x1th/R0[ϕ])*D[Z0[ϕ], ϕ], ϕ] + x2z; 

Collect[TrigReduce[delR2], {Cos[2*θ], Sin[2*θ]}]

X1thc[ϕ]^2/(4*R0[ϕ]) + X1ths[ϕ]^2/(4*R0[ϕ]) + X2R0[ϕ] + (X1Rc[ϕ]*X1thc[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) + (X1Rs[ϕ]*X1ths[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) - (X2th0[ϕ]*Derivative[1][R0][ϕ])/R0[ϕ] - (X1thc[ϕ]^2*Derivative[1][R0][ϕ]^2)/(2*R0[ϕ]^3) - (X1ths[ϕ]^2*Derivative[1][R0][ϕ]^2)/(2*R0[ϕ]^3) - (X1thc[ϕ]*Derivative[1][X1Rc][ϕ])/(2*R0[ϕ]) - (X1ths[ϕ]*Derivative[1][X1Rs][ϕ])/(2*R0[ϕ]) + (X1thc[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1thc][ϕ])/(2*R0[ϕ]^2) + (X1ths[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1ths][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]^2*Derivative[2][R0][ϕ])/(4*R0[ϕ]^2) + (X1ths[ϕ]^2*Derivative[2][R0][ϕ])/(4*R0[ϕ]^2)

Null

X1thc[ϕ]^2/(4*R0[ϕ]) - X1ths[ϕ]^2/(4*R0[ϕ]) + X2Rc[ϕ] + (X1Rc[ϕ]*X1thc[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) - (X1Rs[ϕ]*X1ths[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) - (X2thc[ϕ]*Derivative[1][R0][ϕ])/R0[ϕ] - (X1thc[ϕ]^2*Derivative[1][R0][ϕ]^2)/(2*R0[ϕ]^3) + (X1ths[ϕ]^2*Derivative[1][R0][ϕ]^2)/(2*R0[ϕ]^3) - (X1thc[ϕ]*Derivative[1][X1Rc][ϕ])/(2*R0[ϕ]) + (X1ths[ϕ]*Derivative[1][X1Rs][ϕ])/(2*R0[ϕ]) + (X1thc[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1thc][ϕ])/(2*R0[ϕ]^2) - (X1ths[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1ths][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]^2*Derivative[2][R0][ϕ])/(4*R0[ϕ]^2) - (X1ths[ϕ]^2*Derivative[2][R0][ϕ])/(4*R0[ϕ]^2)

(X1thc[ϕ]*X1ths[ϕ])/(2*R0[ϕ]) + X2Rs[ϕ] + (X1Rs[ϕ]*X1thc[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) + (X1Rc[ϕ]*X1ths[ϕ]*Derivative[1][R0][ϕ])/(2*R0[ϕ]^2) - (X2ths[ϕ]*Derivative[1][R0][ϕ])/R0[ϕ] - (1/R0[ϕ]^3)*(X1thc[ϕ]*X1ths[ϕ]*Derivative[1][R0][ϕ]^2) - (X1ths[ϕ]*Derivative[1][X1Rc][ϕ])/(2*R0[ϕ]) - (X1thc[ϕ]*Derivative[1][X1Rs][ϕ])/(2*R0[ϕ]) + (X1ths[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1thc][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][X1ths][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]*X1ths[ϕ]*Derivative[2][R0][ϕ])/(2*R0[ϕ]^2)

Collect[TrigReduce[delZ2], {Cos[2*θ], Sin[2*θ]}]

X2z0[ϕ] - (X1thc[ϕ]*Derivative[1][X1zc][ϕ])/(2*R0[ϕ]) - (X1ths[ϕ]*Derivative[1][X1zs][ϕ])/(2*R0[ϕ]) + (X1Rc[ϕ]*X1thc[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1Rs[ϕ]*X1ths[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) - (X2th0[ϕ]*Derivative[1][Z0][ϕ])/R0[ϕ] - (X1thc[ϕ]^2*Derivative[1][R0][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^3) - (X1ths[ϕ]^2*Derivative[1][R0][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^3) + (X1thc[ϕ]*Derivative[1][X1thc][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1ths[ϕ]*Derivative[1][X1ths][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]^2*Derivative[2][Z0][ϕ])/(4*R0[ϕ]^2) + (X1ths[ϕ]^2*Derivative[2][Z0][ϕ])/(4*R0[ϕ]^2)

X2zs[ϕ] - (X1ths[ϕ]*Derivative[1][X1zc][ϕ])/(2*R0[ϕ]) - (X1thc[ϕ]*Derivative[1][X1zs][ϕ])/(2*R0[ϕ]) + (X1Rs[ϕ]*X1thc[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1Rc[ϕ]*X1ths[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) - (X2ths[ϕ]*Derivative[1][Z0][ϕ])/R0[ϕ] - (X1thc[ϕ]*X1ths[ϕ]*Derivative[1][R0][ϕ]*Derivative[1][Z0][ϕ])/R0[ϕ]^3 + (X1ths[ϕ]*Derivative[1][X1thc][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]*Derivative[1][X1ths][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]*X1ths[ϕ]*Derivative[2][Z0][ϕ])/(2*R0[ϕ]^2)

X2zc[ϕ] - (X1thc[ϕ]*Derivative[1][X1zc][ϕ])/(2*R0[ϕ]) + (X1ths[ϕ]*Derivative[1][X1zs][ϕ])/(2*R0[ϕ]) + (X1Rc[ϕ]*X1thc[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) - (X1Rs[ϕ]*X1ths[ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) - (X2thc[ϕ]*Derivative[1][Z0][ϕ])/R0[ϕ] - (X1thc[ϕ]^2*Derivative[1][R0][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^3) + (X1ths[ϕ]^2*Derivative[1][R0][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^3) + (X1thc[ϕ]*Derivative[1][X1thc][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) - (X1ths[ϕ]*Derivative[1][X1ths][ϕ]*Derivative[1][Z0][ϕ])/(2*R0[ϕ]^2) + (X1thc[ϕ]^2*Derivative[2][Z0][ϕ])/(4*R0[ϕ]^2) - (X1ths[ϕ]^2*Derivative[2][Z0][ϕ])/(4*R0[ϕ]^2)
