Acov = {A1cov[x1, x2], A2cov[x1, x2], A3cov[x1, x2]}*Exp[I*n*x3]; , Null, Jctr = {J1ctr[x1, x2], J2ctr[x1, x2], J3ctr[x1, x2]}*Exp[I*n*x3]; , Null, nucov = {{nu11[x1, x2], nu12[x1, x2], 0}, {nu21[x1, x2], nu22[x1, x2], 0}, {0, 0, nu33[x1, x2]}}; , Null, Ectr = {{0, 1}, {-1, 0}}; , Null, Curlt[V_] := {D[V, x2], -D[V, x1]}, Null, curlt[v_] := D[v[[2]], x1] - D[v[[1]], x2], Null, Curl3[v_] := {D[v[[3]], x2] - D[v[[2]], x3], D[v[[1]], x3] - D[v[[3]], x1], D[v[[2]], x1] - D[v[[1]], x2]}, Null, divt[v_] := D[v[[1]], x1] + D[v[[2]], x2], Null, gradt[V_] := {D[V, x1], D[V, x2]}]FullSimplify[jctr 〚 {1, 2} 〛]]                                                                                        FullSimplify[jctrt]]                                             FullSimplify[jctr 〚 3 〛]]                                                                                          FullSimplify[jctrl]]                                                                                                                                                                          FullSimplify[jctrlalt], Null

jctr = Curl3[nucov . Curl3[Acov] /. {n -> 0}]; ]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  HoldForm[jctrt = Curlt[nucov[[3,3]]*curlt[{A1cov[x1, x2], A2cov[x1, x2]}] /. {n -> 0}]; ]                   HoldForm[FullSimplify[jctr[[{1, 2}]] - jctrt]]                            HoldForm[jctrl = curlt[nucov[[{1, 2},{1, 2}]] . Curlt[A3cov[x1, x2]] /. {n -> 0}]; , Null,                    HoldForm[FullSimplify[jctr[[3]] - jctrl]]                                                                                                                                                        HoldForm[FullSimplify[jctrlalt - jctrl]

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  HoldForm[                                                                                                   HoldForm[                                                                                                                                                                               HoldForm[nubar = {{nucov[[2,2]], -nucov[[2,1]]}, {-nucov[[1,2]], nucov[[1,1]]}}]                                                                                                                 HoldForm[Null

nubarE = -Ectr . nucov[[{1, 2},{1, 2}]] . Ectr]                                                                                                                                         HoldForm[A = {-y, x, 0}, Null, B = Curl[A, {x, y, z}]

FullSimplify[nubar - nubarE]]                                                                                                                                                           HoldForm[VectorPlot3D[A, {x, -1, 1}, {y, -1, 1}, {z, -1, 1}]

gij = {{g11[x1, x2], g12[x1, x2], 0}, {g12[x1, x2], g22[x1, x2], 0}, {0, 0, g33[x1, x2]}}; , Null, nuscalcov = (nu*gij)/sqrtg

nubarscal = {{nuscalcov[[2,2]], -nuscalcov[[2,1]]}, {-nuscalcov[[1,2]], nuscalcov[[1,1]]}}

FullSimplify[Inverse[gij]]

nubarscalalt = FullSimplify[nu*Inverse[gij]*(g33[x1, x2]*(((-g12[x1, x2])*g12[x1, x2] + g11[x1, x2]*g22[x1, x2])/sqrtg^2))*(sqrtg/g33[x1, x2])]

nubarscalalt2 = FullSimplify[nu*Inverse[gij[[{1, 2},{1, 2}]]]*(((-g12[x1, x2])*g21[x1, x2] + g11[x1, x2]*g22[x1, x2])*(g33[x1, x2]/sqrtg^2))*(sqrtg/g33[x1, x2])]

FullSimplify[nubarscalalt[[{1, 2},{1, 2}]] - nubarscal]

HoldForm[jctrlalt = -divt[nubar . gradt[A3cov[x1, x2]]]; , Null,
