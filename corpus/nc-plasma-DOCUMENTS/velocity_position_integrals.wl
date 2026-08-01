ClearAll["Global`*"]

dgl1 = D[v[tau1], tau1] == a44*v[tau1] + b4

v[tau1_] = v[tau1] /. DSolve[dgl1, v[tau1], tau1][[1]]

v[tau1_] = v[tau1] /. Solve[v[0] == vparinit, C[1]][[1]]

vSeries2[tau1_] = Normal[Series[v[tau1], {tau1, 0, 2}]]

vSeries4[tau1_] = Collect[Expand[Series[v[tau1], {tau1, 0, 4}]], tau]

dgl2 = D[z[tau1], tau1] == a*z[tau1] + b

z[tau1_] = z[tau1] /. DSolve[dgl2, z[tau1], tau1][[1]]

z[tau1_] = z[tau1] /. Solve[z[0] == z0, C[1]][[1]]

zSeries4[tau1_] = Simplify[Normal[Series[z[tau1], {tau1, 0, 4}]]]

Collect[Expand[(z0 + tau1*(b + a*z0) + (1/2)*a*tau1^2*(b + a*z0) + (1/6)*a^2*tau1^3*(b + a*z0) + (1/24)*a^3*tau1^4*(b + a*z0))*(vparinit + (b4 + a44*vparinit)*tau1 + (1/2)*a44*(b4 + a44*vparinit)*tau1^2 + (1/6)*a44^2*(b4 + a44*vparinit)*tau1^3 + (1/24)*a44^3*(b4 + a44*vparinit)*tau1^4)], tau1]

Collect[vSeries4[tau]*zSeries4[tau], tau]

zvparSeries4[tau_] = vSeries4[tau]*zSeries4[tau]

vSeries4[tau]

zSeries4[tau]

vSeries4[tau]

Collect[Expand[Series[zvparSeries4[tau], {tau, 0, 4}]], tau]

Collect[Series[Integrate[Collect[vSeries4[tau]*zSeries4[tau], tau], tau], {tau, 0, 5}], tau] /. {α -> a44, β -> b4, vpar0 -> vparinit}

Collect[Expand[Integrate[zSeries4[tau], tau]], tau]

Collect[Expand[zSeries4[tau]], tau]

Collect[Integrate[vSeries4[tau], tau], tau]
