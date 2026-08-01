q = Exp[-t^2/(2*dt)^2]*Exp[-2*I*Pi*f0*t], Null, qf = FourierTransform[q, t, om]

qfplot = FullSimplify[qf /. {dt -> 1/f0} /. {f0 -> 5*10^6, om -> 2*Pi*f}]

Plot[Re[qfplot], {f, 0, 7.5*10^6}]

Null
