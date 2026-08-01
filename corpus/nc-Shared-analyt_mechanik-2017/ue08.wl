U = -a/(2*m*r^n), Null, Ueff = l^2/(2*m*r^2) + U

dUeffdr = D[Ueff, r]

solr0 = Flatten[Solve[dUeffdr == 0, r]]

r0 = r /. solr0

beta = FullSimplify[(1/2)*D[Ueff, r, r] /. r -> r0]

deltaphi = FullSimplify[Sqrt[2/(m*beta)]*(l/r0^2)*Pi]
