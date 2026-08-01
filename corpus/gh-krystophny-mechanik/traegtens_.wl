x1A = -1; x1B = 1; x1C = -(x1A + x1B), Null, x2A = 1; x2B = -1; x2C = -(x2A + x2B), Null, x3A = -1; x3B = -1; x3C = -(x3A + x3B)

rA = Sqrt[x1A^2 + x2A^2 + x3A^2], Null, rB = Sqrt[x1B^2 + x2B^2 + x3B^2], Null, rC = Sqrt[x1C^2 + x2C^2 + x3C^2]

Th11 = rA^2 + rB^2 + rC^2 - x1A^2 - x1B^2 - x1C^2, Null, Th22 = rA^2 + rB^2 + rC^2 - x2A^2 - x2B^2 - x2C^2, Null, Th33 = rA^2 + rB^2 + rC^2 - x3A^2 - x3B^2 - x3C^2

Th12 = (-x1A)*x2A - x1B*x2B - x1C*x2C, Null, Th13 = (-x1A)*x3A - x1B*x3B - x1C*x3C, Null, Th23 = (-x2A)*x3A - x2B*x3B - x2C*x3C

Th = {{Th11, Th12, Th13}, {Th12, Th22, Th23}, {Th13, Th23, Th33}}

Det[Th - lam*{{1, 0, 0}, {0, 1, 0}, {0, 0, 1}}]

Eigenvalues[Th]
