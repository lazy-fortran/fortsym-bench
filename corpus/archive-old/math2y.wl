Clear[x, y]

x = Pi

y = 5

x + y

N[%]

Clear[x]

NIntegrate[Exp[(-x)*0.00001]*Sin[100*x], {x, 0, Infinity}]

int = Chop[Integrate[Exp[(-x)*0.00001]*Sin[100*x], x]]

iog = N[int /. x -> Infinity]

iug = N[int /. x -> 0]

iog - iug
