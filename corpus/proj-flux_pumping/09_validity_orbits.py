"""Generated SymPy translation of ``corpus/proj-flux_pumping/09_validity_orbits.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 17 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('figdir', 'FileNameJoin[{DirectoryName[$InputFileName], "figures"}]', ()),
    ('clight', '2.99792458 10^10', ()),
    ('ee', '4.80320425 10^-10', ()),
    ('mD', '3.34358377 10^-24', ()),
    ('me', '9.1093837 10^-28', ()),
    ('erg', '1.602176634 10^-12', ()),
    ('B0', '2 10^4', ()),
    ('Rmaj', '170.', ()),
    ('qs', '1.', ()),
    ('lnL', '16.', ()),
    ('rhoL', 'mass Sqrt[2 Tev erg/mass] clight/(ee B0)', ('Tev', 'mass')),
    ('drPass', '2 qs rhoL[Tev, mass]', ('Tev', 'mass')),
    ('drTrap', 'drPass[Tev, mass] Sqrt[Rmaj/r]', ('Tev', 'mass', 'r')),
    ('rPotato', '(2 qs rhoL[Tev, mass])^(2/3) Rmaj^(1/3)', ('Tev', 'mass')),
    ('rpot5', 'rPotato[5 10^3, mD]', ()),
    ('figO', 'LogPlot[{drPass[5 10^3, mD], drTrap[5 10^3, mD, r],\n    drTrap[5 10^3, me, r], r}, {r, 0.5, 25},\n  PlotStyle -> {{ColorData[97, 1], Dashed}, {ColorData[97, 1], Thick},\n    {ColorData[97, 3], Thick}, {Gray, Dotted}},\n  Frame -> True, FrameLabel -> {"r [cm]", "orbit width [cm]"},\n  PlotLegends -> Placed[LineLegend[\n    {Directive[ColorData[97, 1], Dashed], Directive[ColorData[97, 1], Thick],\n     Directive[ColorData[97, 3], Thick], Directive[Gray, Dotted]},\n    {"passing D, 2q\\!\\(\\*SubscriptBox[\\(\\[Rho]\\), \\(L\\)]\\)",\n     "trapped D, 2q\\!\\(\\*SubscriptBox[\\(\\[Rho]\\), \\(L\\)]\\)\\[Sqrt](R/r)",\n     "trapped e\\!\\(\\*SuperscriptBox[\\(\\), \\(-\\)]\\)",\n     "width = r"}], {0.78, 0.32}],\n  GridLines -> {{rpot5}, None},\n  GridLinesStyle -> Directive[Red, Dashed],\n  Epilog -> {Text[Style["potato\\nboundary", 10, Red], Scaled[{0.33, 0.85}]],\n    Text[Style["GORILLA full-f", 10, Bold], Scaled[{0.16, 0.06}]],\n    Text[Style["NEO-2-QL local", 10, Bold], Scaled[{0.7, 0.06}]]},\n  PlotLabel -> "D and e\\!\\(\\*SuperscriptBox[\\(\\), \\(-\\)]\\) at 5 keV, B = 2 T, R = 170 cm, q = 1",\n  ImageSize -> 460]', ()),
    ('vTe', 'Sqrt[Tev erg/me]', ('Tev',)),
    ('taue', '3.44 10^5 Tev^(3/2)/(ne lnL)', ('Tev', 'ne')),
    ('lc', 'vTe[Tev] taue[Tev, ne]', ('Tev', 'ne')),
    ('TevStar', 'Tev /. FindRoot[lc[Tev, ne] - Rmaj/dq, {Tev, 500., 1., 10^5}]', ('ne', 'dq')),
    ('ne0', '6 10^13', ()),
    ('figV', 'ContourPlot[\n  Log10[lc[10^lT, ne0]/(Rmaj/10^ldq)], {lT, 1.3, 4}, {ldq, -3, -1},\n  Contours -> Range[-4, 4], ColorFunction -> "TemperatureMap",\n  FrameLabel -> {"log10 \\!\\(\\*SubscriptBox[\\(T\\), \\(e\\)]\\) [eV]",\n    "log10 |q - \\!\\(\\*SubscriptBox[\\(q\\), \\(res\\)]\\)|"},\n  PlotLegends -> BarLegend[Automatic,\n    LegendLabel -> "log10 (\\!\\(\\*SubscriptBox[\\(l\\), \\(c\\)]\\) \\[CenterDot] |\\[CapitalDelta]q|/R)"],\n  Epilog -> {Black, Thick,\n    Line[Table[{Log10[TevStar[ne0, 10^ldq]], ldq}, {ldq, -3, -1, 0.1}]],\n    Text[Style["fluid", 12, Bold, White], {1.7, -1.6}],\n    Text[Style["kinetic", 12, Bold], {3.55, -2.4}],\n    Dashed, Line[{{Log10[3000.], -3}, {Log10[3000.], -1}}],\n    Text[Style["AUG hybrid core", 10], {Log10[3000.] - 0.12, -1.25}, {0, 0}, {0, 1}]},\n  PlotLabel -> "connection-length condition \\!\\(\\*SubscriptBox[\\(l\\), \\(c\\)]\\) \\[LessLess] R/|\\[CapitalDelta]q|, \\!\\(\\*SubscriptBox[\\(n\\), \\(e\\)]\\) = 6\\[Times]\\!\\(\\*SuperscriptBox[\\(10\\), \\(13\\)]\\) \\!\\(\\*SuperscriptBox[\\(cm\\), \\(-3\\)]\\)",\n  ImageSize -> 480]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-flux_pumping/09_validity_orbits.wl')
