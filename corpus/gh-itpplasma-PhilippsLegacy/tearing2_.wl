B = 1; kx = 1; kz = 1; a = 1; , Null, k = Sqrt[kx^2 + kz^2]; α = k*a; 

Bx0[y_] := y; , Null, Bz0[y_] := 0; , Null, By[x_, y_, z_] := B*ψ[y]*E^(I*(kx*x + kz*z)); , Null, q[y_] = ψ[y]*(D[Bx0[y]*kx + Bz0[y]*kz, y]/(Bx0[y]*kx + Bz0[y]*kz)); , Null, ψ[y_] = (1/(2*α))*Integrate[q/E^(α*ξ), {ξ, Infinity, a*y}]*E^(α*a*y) - (1/(2*α))*Integrate[q*E^(α*ξ), {ξ, -Infinity, a*y}]*E^(α*a*y); 

ContourPlot[Re[By[x, y, 0]], {x, -10*a, 10*a}, {y, -10*a, 10*a}]
