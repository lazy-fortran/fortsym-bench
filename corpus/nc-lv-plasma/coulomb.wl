FullSimplify[Integrate[1/Sqrt[1 - a*s - s^2], s, Assumptions -> Element[s, Reals]]]

FullSimplify[% /. {s -> b/r, a -> alp/(b*E)}]

FullSimplify[Integrate[1/(s^2*Sqrt[1 - a*s - s^2]), s]]
