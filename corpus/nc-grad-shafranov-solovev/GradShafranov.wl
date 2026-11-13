DStar[u_] := R*D[(1/R)*D[u, R], R] + D[u, Z, Z]

Psisol = (-A)*((R^2 - R0^2)^2/8) - B*(Z^2/2)

FullSimplify[-DStar[Psisol]]
