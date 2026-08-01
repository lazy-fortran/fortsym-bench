ClearAll[scientificTeX];
scientificTeX[value_, digits_Integer] := Module[{exponent, mantissa},
  exponent = Floor[Log[10, Abs[N[value]]]];
  mantissa = N[value/10^exponent];
  ToString[NumberForm[mantissa, {digits, digits - 1}]] <>
    "\\times 10^{" <> ToString[exponent] <> "}"];
