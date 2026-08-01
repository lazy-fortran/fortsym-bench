Remove["Global`*"], Null, F = Tanh[μ]; , Null, d2F = D[Tanh[μ], {μ, 2}]; 

sol = DSolve[{Derivative[2][ψ][μ] - ψ[μ]*(α^2 + d2F/F) == 0}, ψ[μ], μ, Assumptions -> α > 0]; , Null, ψ = ψ[μ] /. sol, Null, ψd = D[ψ, μ]; , Null, Δ = (ψ /. μ -> -10^(-1))/(ψd /. μ -> -10^(-1)) + (ψ /. μ -> 10^(-1))/(ψd /. μ -> 10^(-1)); 

Plot[-ψd /. C[1] -> 1 /. C[2] -> 0 /. α -> 1, {μ, -3, 3}], Null, N[Δ /. C[1] -> 1 /. C[2] -> 0 /. α -> 1]
