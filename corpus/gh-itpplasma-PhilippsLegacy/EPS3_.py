"""Generated SymPy translation of ``corpus/gh-itpplasma-PhilippsLegacy/EPS3_.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 7 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('E3A', '-1', ()),
    ('E3E', '2*z^2*(1 + I*Sqrt[Pi]*z*(E^(-z^2) + ((2*I)/Sqrt[Pi])*DawsonF[z]))', ()),
    ('p', 'Plot[{E3A, Re[E3E], Im[E3E]}, {z, 0, 20}, PlotRange -> Full, AxesLabel -> {"Z_e", "E_3"}, ImageSize -> Large, LabelingSize -> 100, WorkingPrecision -> 20, BaseStyle -> {FontSize -> 20}, PlotLegends -> {"Approximate", "Re(Exact)", "Im(Exact)"}]', ()),
    ('p', 'Plot[{E3A, Re[E3E], Im[E3E]}, {z, 0, 0.5}, PlotRange -> Full, AxesLabel -> {"Z_e", "E_3"}, ImageSize -> Large, LabelingSize -> 100, WorkingPrecision -> 20, BaseStyle -> {FontSize -> 20}, PlotLegends -> {"Approximate", "Re(Exact)", "Im(Exact)"}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/gh-itpplasma-PhilippsLegacy/EPS3_.wl')
