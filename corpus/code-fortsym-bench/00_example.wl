(* Worked example showing the corpus contract. Not a physics derivation. *)

fortsymBenchResults = <|
  "pythagorean"    -> Simplify[Sin[x]^2 + Cos[x]^2],
  "derivative"     -> D[Exp[x*y], x],
  "exact_rational" -> 1/3 + 1/6,
  "series"         -> Normal[Series[Exp[x], {x, 0, 4}]]
|>;
