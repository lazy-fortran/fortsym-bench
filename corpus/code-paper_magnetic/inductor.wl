Get["FourierSeries`"]

y1 = Sqrt[Max[(0.5*Pi)^2 - (Mod[x, 2*Pi] - 0.5*Pi)^2, 0]], Null, y2 = NFourierSeries[y1, x, 3], Null, Plot[{y1, Re[y2]}, {x, 0, 3*2*Pi}, AspectRatio -> 1/12]

N = 15

r1 = 0.5, Null, r2 = 1.
