ClearAll["Global`*"]

dgl1 = D[v[tau1], tau1] == α*v[tau1] + β

v[tau1_] = v[tau1] /. DSolve[dgl1, v[tau1], tau1][[1]]

v[tau1_] = v[tau1] /. Solve[v[0] == vpar0, C[1]][[1]]

v2[tau1_] = v[tau1]^2

v2Series2[tau1_] = Normal[Series[v2[tau1], {tau1, 0, 2}]]

Integrate[v2Series2[tau1], {tau1, 0, tau}]

v2Series3[tau1_] = Normal[Series[v2[tau1], {tau1, 0, 3}]]

Simplify[Integrate[v2Series3[tau1], {tau1, 0, tau}]]

v2Series4[tau1_] = Expand[Series[v2[tau1], {tau1, 0, 4}]]

Expand[(1/3)*vpar0*α^2*(vpar0*α + β) + α*(vpar0*α + β)^2]

Expand[((1/12)*vpar0*α^3*(vpar0*α + β) + (7/12)*α^2*(vpar0*α + β)^2)*12]

Collect[Integrate[v2Series4[tau1], {tau1, 0, tau}], tau]

vSeries2[tau1_] = Collect[Normal[Series[v[tau1], {tau1, 0, 2}]], tau1]

vSeries2[tau1_] = Collect[Normal[Series[v[tau1], {tau1, 0, 3}]], tau1]

vSeries2[tau1_] = Collect[Normal[Series[v[tau1], {tau1, 0, 4}]], tau1]
