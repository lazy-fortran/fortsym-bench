Null

theta = ArcTan[R, Z]

AR = aRmn*Exp[I*(m*theta + n*phi)], Null, Aphi = aphimn*Exp[I*(m*theta + n*phi)], Null, AZ = aZmn*Exp[I*(m*theta + n*phi)]

Expand[Curl[{AR, Aphi, AZ}, {R, phi, Z}, "Cylindrical"]/Exp[I*(m*theta + n*phi)]]

AR = AMPL*R*Cos[phi], Null, Aphi = (-2^(-1))*AMPL2*Z*R, Null, AZ = -Log[R]

FullSimplify[Curl[{AR, Aphi, AZ}, {R, phi, Z}, "Cylindrical"]]

FullSimplify[Curl[{fR[R, phi, Z], fphi[R, phi, Z], fZ[R, phi, Z]}, {R, phi, Z}, "Cylindrical"]]
