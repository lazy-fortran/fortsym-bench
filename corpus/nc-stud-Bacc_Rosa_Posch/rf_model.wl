ClearAll["Global`*"];

swrGamma = FullSimplify[(S - 1)/(S + 1), S >= 1];
deliveredFromSWR = FullSimplify[Pf (1 - swrGamma^2), S >= 1];
resonance = 1/Sqrt[L C];
quality = omega0 L/(Rcoil + Rpl);
centralB = mu0 N Icoil/(2 R);
faradayE = FullSimplify[r omega B0/2, {r >= 0, omega >= 0, B0 >= 0}];

sigma = ne qe^2/(me (nu - I omega));
sigmaRe = FullSimplify[ComplexExpand[Re[sigma]], 
  {ne > 0, qe > 0, me > 0, nu > 0, omega > 0}];
sigmaIm = FullSimplify[ComplexExpand[Im[sigma]], 
  {ne > 0, qe > 0, me > 0, nu > 0, omega > 0}];
powerDensity = FullSimplify[1/2 sigmaRe E0^2];
skinDepth = FullSimplify[Sqrt[2/(mu0 omega sigmaRe)]];
debyeLength = Sqrt[eps0 TeEV qe/(ne qe^2)];
plasmaFrequency = Sqrt[ne qe^2/(eps0 me)]/(2 Pi);

texRules = {
  omega0 -> Subscript[\[Omega], 0],
  Rcoil -> Subscript[R, coil],
  Rpl -> Subscript[R, pl],
  Icoil -> Subscript[I, coil],
  mu0 -> Subscript[\[Mu], 0],
  B0 -> Subscript[B, 0],
  ne -> Subscript[n, e],
  qe -> e,
  me -> Subscript[m, e],
  E0 -> Subscript[E, 0],
  eps0 -> Subscript[\[Epsilon], 0],
  TeEV -> Subscript[T, e]
};
texString[expr_] := StringReplace[ToString[TeXForm[expr /. texRules]], {
  "\\text{coil}" -> "\\mathrm{coil}",
  "\\text{pl}" -> "\\mathrm{pl}",
  "\\mu _0" -> "\\mu_0",
  "\\omega _0" -> "\\omega_0",
  "\\epsilon _0" -> "\\epsilon_0",
  "i_{\\mathrm{coil}}" -> "I_{\\mathrm{coil}}",
  "e_0" -> "E_0"
}];

tex = {
  "% Generated from symbolics/rf_model.wls.",
  "\\begin{align}",
  "|\\Gamma| &= " <> texString[swrGamma] <> ",\\\\",
  "P_{\\mathrm{del}} &= \\frac{4 P_{\\mathrm{f}} S}{{(S+1)}^2},\\\\",
  "\\omega_0 &= \\frac{1}{\\sqrt{LC}},\\\\",
  "Q &= \\frac{\\omega_0 L}{R_{\\mathrm{coil}}+R_{\\mathrm{pl}}},\\\\",
  "B_0 &= \\frac{\\mu_0 N I_{\\mathrm{coil}}}{2R},\\\\",
  "|E_\\varphi| &= \\frac{r\\omega B_0}{2},\\\\",
  "\\operatorname{Re}\\sigma_{\\mathrm{rf}} &= " <>
    "\\frac{n_e e^2 \\nu}{m_e(\\nu^2+\\omega^2)},\\\\",
  "\\operatorname{Im}\\sigma_{\\mathrm{rf}} &= " <>
    "\\frac{n_e e^2 \\omega}{m_e(\\nu^2+\\omega^2)},\\\\",
  "p_{\\mathrm{abs}} &= " <>
    "\\frac{n_e e^2 \\nu E_0^2}{2m_e(\\nu^2+\\omega^2)},\\\\",
  "\\delta &= " <>
    "\\sqrt{\\frac{2m_e(\\nu^2+\\omega^2)}" <>
    "{\\mu_0\\omega n_e e^2\\nu}},\\\\",
  "\\lambda_D &= \\sqrt{\\frac{\\epsilon_0 T_e}{n_e e}},\\\\",
  "f_{pe} &= \\frac{1}{2\\pi}\\sqrt{\\frac{n_e e^2}{\\epsilon_0 m_e}}.",
  "\\end{align}"
};

Export[FileNameJoin[{"tex", "symbolic_results.tex"}], 
  StringRiffle[tex, "\n"], "Text"];
