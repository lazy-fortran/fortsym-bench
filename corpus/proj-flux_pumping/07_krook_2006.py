"""Generated SymPy translation of ``corpus/proj-flux_pumping/07_krook_2006.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('fM', 'n0 Exp[-v^2/(2 vT^2)]/(Sqrt[2 Pi] vT)', ('v',)),
    ('assum', 'n0 > 0 && vT > 0 && Vd \\[Element] Reals', ()),
    ('df', '(a0 + a1 v + a2 v^2) fM[v]', ('v',)),
    ('dn', 'Integrate[df[v], {v, -Infinity, Infinity}, Assumptions -> assum]', ()),
    ('momKrook', 'Integrate[-nu df[v], {v, -Infinity, Infinity}, Assumptions -> assum]', ()),
    ('cBGK', '-nu (df[v] - (dn/n0) fM[v])', ('v',)),
    ('cShift', '-nu (fM[v - Vd] - fM[v])', ('v',)),
    ('uMean', 'Integrate[v df[v], {v, -Infinity, Infinity}, Assumptions -> assum]/n0', ()),
    ('cBGK2', '-nu (df[v] - (dn/n0) fM[v] - uMean (v/vT^2) fM[v])', ('v',)),
    ('zeta', '(w + I nu)/(Sqrt[2] k vT)', ('w', 'nu', 'k', 'vT')),
    ('Wf', 'Exp[-z^2] Erfc[-I z]', ('z',)),
    ('Zpl', 'I Sqrt[Pi] Wf[z]', ('z',)),
    ('BAna', '(1/(I k)) Zpl[zeta[w, nu, k, vTn]]/(Sqrt[2] vTn)', ('w', 'nu', 'k', 'vTn')),
    ('BvAna', '(1/(I k)) (1 + zeta[w, nu, k, vTn] Zpl[zeta[w, nu, k, vTn]])', ('w', 'nu', 'k', 'vTn')),
    ('AAna', '-BvAna[w, nu, k, vTn]/vTn^2', ('w', 'nu', 'k', 'vTn')),
    ('pars', '{6/10, 3/10, 1, 1}', ()),
    ('dnKrook', '-I k AAna[w, nu, k, vTn]', ('w', 'nu', 'k', 'vTn')),
    ('contKrook', 'With[{w = 6/10, nu = 3/10, k = 1, vTn = 1},\n  -I w dnKrook[w, nu, k, vTn] + I k gamKrookNum[w, nu, k, vTn] +\n    nu dnKrook[w, nu, k, vTn]]', ()),
    ('dnCons', 'dnKrook[w, nu, k, vTn]/\n  (1 - nu BAna[w, nu, k, vTn])', ('w', 'nu', 'k', 'vTn')),
    ('contCons', 'With[{w = 6/10, nu = 3/10, k = 1, vTn = 1},\n  -I w dnCons[w, nu, k, vTn] + I k gamConsNum[w, nu, k, vTn]]', ()),
    ('relDiff', 'Abs[dnKrook[w, nu, k, vTn]/dnCons[w, nu, k, vTn] - 1]', ('w', 'nu', 'k', 'vTn')),
    ('fig', 'LogLogPlot[\n  Evaluate[Table[relDiff[wv, nuv, 1, 1], {wv, {1/2, 1, 2}}] /. nuv -> nn],\n  {nn, 10^-3, 3},\n  PlotStyle -> {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},\n  Frame -> True,\n  FrameLabel -> {"\\[Nu]/(k \\!\\(\\*SubscriptBox[\\(v\\), \\(T\\)]\\))",\n    "|\\[Delta]\\!\\(\\*SubscriptBox[\\(n\\), \\(Krook\\)]\\)/\\[Delta]\\!\\(\\*SubscriptBox[\\(n\\), \\(cons\\)]\\) - 1|"},\n  PlotLegends -> LineLegend[\n    {ColorData[97, 1], ColorData[97, 2], ColorData[97, 3]},\n    {"\\[Omega]/(k \\!\\(\\*SubscriptBox[\\(v\\), \\(T\\)]\\)) = 0.5",\n     "\\[Omega]/(k \\!\\(\\*SubscriptBox[\\(v\\), \\(T\\)]\\)) = 1",\n     "\\[Omega]/(k \\!\\(\\*SubscriptBox[\\(v\\), \\(T\\)]\\)) = 2"}],\n  ImageSize -> 420,\n  PlotLabel -> "Krook artifact in the density response (2006 model)"]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/07_krook_2006.wl')
