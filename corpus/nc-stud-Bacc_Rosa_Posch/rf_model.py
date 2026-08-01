"""Generated SymPy translation of ``corpus/nc-stud-Bacc_Rosa_Posch/rf_model.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 2 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('swrGamma', 'FullSimplify[(S - 1)/(S + 1), S >= 1]', ()),
    ('deliveredFromSWR', 'FullSimplify[Pf (1 - swrGamma^2), S >= 1]', ()),
    ('resonance', '1/Sqrt[L C]', ()),
    ('quality', 'omega0 L/(Rcoil + Rpl)', ()),
    ('centralB', 'mu0 N Icoil/(2 R)', ()),
    ('faradayE', 'FullSimplify[r omega B0/2, {r >= 0, omega >= 0, B0 >= 0}]', ()),
    ('sigma', 'ne qe^2/(me (nu - I omega))', ()),
    ('sigmaRe', 'FullSimplify[ComplexExpand[Re[sigma]], \n  {ne > 0, qe > 0, me > 0, nu > 0, omega > 0}]', ()),
    ('sigmaIm', 'FullSimplify[ComplexExpand[Im[sigma]], \n  {ne > 0, qe > 0, me > 0, nu > 0, omega > 0}]', ()),
    ('powerDensity', 'FullSimplify[1/2 sigmaRe E0^2]', ()),
    ('skinDepth', 'FullSimplify[Sqrt[2/(mu0 omega sigmaRe)]]', ()),
    ('debyeLength', 'Sqrt[eps0 TeEV qe/(ne qe^2)]', ()),
    ('plasmaFrequency', 'Sqrt[ne qe^2/(eps0 me)]/(2 Pi)', ()),
    ('texRules', '{\n  omega0 -> Subscript[\\[Omega], 0],\n  Rcoil -> Subscript[R, coil],\n  Rpl -> Subscript[R, pl],\n  Icoil -> Subscript[I, coil],\n  mu0 -> Subscript[\\[Mu], 0],\n  B0 -> Subscript[B, 0],\n  ne -> Subscript[n, e],\n  qe -> e,\n  me -> Subscript[m, e],\n  E0 -> Subscript[E, 0],\n  eps0 -> Subscript[\\[Epsilon], 0],\n  TeEV -> Subscript[T, e]\n}', ()),
    ('texString', 'StringReplace[ToString[TeXForm[expr /. texRules]], {\n  "\\\\text{coil}" -> "\\\\mathrm{coil}",\n  "\\\\text{pl}" -> "\\\\mathrm{pl}",\n  "\\\\mu _0" -> "\\\\mu_0",\n  "\\\\omega _0" -> "\\\\omega_0",\n  "\\\\epsilon _0" -> "\\\\epsilon_0",\n  "i_{\\\\mathrm{coil}}" -> "I_{\\\\mathrm{coil}}",\n  "e_0" -> "E_0"\n}]', ('expr',)),
    ('tex', '{\n  "% Generated from symbolics/rf_model.wls.",\n  "\\\\begin{align}",\n  "|\\\\Gamma| &= " <> texString[swrGamma] <> ",\\\\\\\\",\n  "P_{\\\\mathrm{del}} &= \\\\frac{4 P_{\\\\mathrm{f}} S}{{(S+1)}^2},\\\\\\\\",\n  "\\\\omega_0 &= \\\\frac{1}{\\\\sqrt{LC}},\\\\\\\\",\n  "Q &= \\\\frac{\\\\omega_0 L}{R_{\\\\mathrm{coil}}+R_{\\\\mathrm{pl}}},\\\\\\\\",\n  "B_0 &= \\\\frac{\\\\mu_0 N I_{\\\\mathrm{coil}}}{2R},\\\\\\\\",\n  "|E_\\\\varphi| &= \\\\frac{r\\\\omega B_0}{2},\\\\\\\\",\n  "\\\\operatorname{Re}\\\\sigma_{\\\\mathrm{rf}} &= " <>\n    "\\\\frac{n_e e^2 \\\\nu}{m_e(\\\\nu^2+\\\\omega^2)},\\\\\\\\",\n  "\\\\operatorname{Im}\\\\sigma_{\\\\mathrm{rf}} &= " <>\n    "\\\\frac{n_e e^2 \\\\omega}{m_e(\\\\nu^2+\\\\omega^2)},\\\\\\\\",\n  "p_{\\\\mathrm{abs}} &= " <>\n    "\\\\frac{n_e e^2 \\\\nu E_0^2}{2m_e(\\\\nu^2+\\\\omega^2)},\\\\\\\\",\n  "\\\\delta &= " <>\n    "\\\\sqrt{\\\\frac{2m_e(\\\\nu^2+\\\\omega^2)}" <>\n    "{\\\\mu_0\\\\omega n_e e^2\\\\nu}},\\\\\\\\",\n  "\\\\lambda_D &= \\\\sqrt{\\\\frac{\\\\epsilon_0 T_e}{n_e e}},\\\\\\\\",\n  "f_{pe} &= \\\\frac{1}{2\\\\pi}\\\\sqrt{\\\\frac{n_e e^2}{\\\\epsilon_0 m_e}}.",\n  "\\\\end{align}"\n}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/nc-stud-Bacc_Rosa_Posch/rf_model.wl')
