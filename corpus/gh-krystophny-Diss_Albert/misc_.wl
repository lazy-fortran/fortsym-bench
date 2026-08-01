$Assumptions -> Element[{x, a, b, c, d}, Reals]

FullSimplify[ComplexExpand[Re[(-I)*(a + I*b)*Exp[(-I)*x]]*Re[(c + I*d)*Exp[I*x]] - Re[(a + I*b)*Exp[(-I)*x]]*Re[I*(c + I*d)*Exp[I*x]], Element[{a, b, c, d, x}, Reals]]]

FullSimplify[ComplexExpand[Re[(-I)*(a + I*b)*(c + I*d) - I*(a + I*b)*(c + I*d)]]]
