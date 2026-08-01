k = Exp[-((x - x0)^2 + (y - y0)^2 + (z - z0)^2)]*{1, 1, 1}

kdiv0 = Simplify[Curl[k, {x, y, z}]]

phi0 = Integrate[kdiv0[[1]], {x, x0, x1}] + f[y, z]

DSolve[D[phi0, y] == kdiv0[[2]], f[y, z], y]

D[phi0, y]

DSolve[{D[phi[x, y, z], x] == kdiv0[[1]], D[phi[x, y, z], y] == kdiv0[[2]], D[phi[x, y, z], z] == kdiv0[[3]]}, phi[x, y, z], {x, y, z}]

DSolve[E^(-x^2 + 2*x*x0 - x0^2 - (y - y0)^2 - z^2 + 2*z*z0 - z0^2)*Sqrt[Pi]*((-E^(x - x0)^2)*(y - y0 - z + z0)*Erf[x0 - x1] + E^(y - y0)^2*(x - x0 - z + z0)*Erf[y - y0]) + g[z] == kdiv0[[3]], g[z], z]

a = Simplify[E^(-(y - y0)^2 - (z - z0)^2)*Sqrt[Pi]*(y - y0 - z + z0)*Erf[x0 - x1] + E^(-x^2 + 2*x*x0 - x0^2 - (y - y0)^2 - z^2 + 2*z*z0 - z0^2)*Sqrt[Pi]*((-E^(x - x0)^2)*(y - y0 - z + z0)*Erf[x0 - x1] + E^(y - y0)^2*(x - x0 - z + z0)*Erf[y - y0]) - 2*E^(-(x - x0)^2 - (y - y0)^2 - (z - z0)^2)*(x - x0 - y + y0) - E^(-x^2 + 2*x*x0 - x0^2 - (y - y0)^2 - z^2 + 2*z*z0 - z0^2)*Sqrt[Pi]*((-E^(x - x0)^2)*(y - y0 - z + z0)*Erf[x0 - x1] + E^(y - y0)^2*(x - x0 - z + z0)*Erf[y - y0])]

Simplify[Div[Grad[a, {x, y, z}], {x, y, z}]]
