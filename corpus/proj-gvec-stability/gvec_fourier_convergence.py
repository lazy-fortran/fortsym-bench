"""Generated SymPy translation of ``corpus/proj-gvec-stability/gvec_fourier_convergence.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

import hashlib
import json

import sympy as sp

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 14 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('scriptDirectory', 'DirectoryName[ExpandFileName[$InputFileName]]', ()),
    ('projectDirectory', 'FileNameJoin[{scriptDirectory, ".."}]', ()),
    ('dataFile', 'FileNameJoin[{\n    projectDirectory, "validation", "data", "gvec_fourier_convergence.csv"}]', ()),
    ('figureDirectory', 'FileNameJoin[{projectDirectory, "docs", "figures"}]', ()),
    ('generatedDirectory', 'FileNameJoin[{projectDirectory, "docs", "generated"}]', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[condition],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('table', 'Import[dataFile, "CSV"]', ()),
    ('header', 'First[table]', ()),
    ('rows', 'Rest[table]', ()),
    ('truncations', '{2, 4, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48}', ()),
    ('fields', '{\n  "mod_B", "xhat", "yhat", "zhat", "Jac", "g_tt", "g_tz", "g_zz",\n  "II_tt", "II_tz", "II_zz", "B_contra_t", "B_contra_z"}', ()),
    ('acceptanceTolerance', '10^-3', ()),
    ('fieldData', 'SortBy[\n  Cases[rows, row_ /; row[[2]] == field :> {row[[1]], row[[4]]}],\n  First]', ('field',)),
    ('finalRows', 'Select[rows, First[#] == Last[truncations] &]', ()),
    ('worstRow', 'First[MaximalBy[finalRows, #[[4]] &]]', ()),
    ('groups', '{\n  {"geometry and |B|", {"mod_B", "xhat", "yhat", "zhat"}},\n  {"metric and Jacobian", {"Jac", "g_tt", "g_tz", "g_zz"}},\n  {"second fundamental form", {"II_tt", "II_tz", "II_zz"}},\n  {"contravariant B", {"B_contra_t", "B_contra_z"}}}', ()),
    ('groupData', 'Table[\n  {truncation, Max[\n    Select[rows, First[#] == truncation &&\n        MemberQ[groupFields, #[[2]]] &][[All, 4]]]},\n  {truncation, truncations}]', ('groupFields',)),
    ('plotData', 'groupData /@ groups[[All, 2]]', ()),
    ('acceptanceData', 'Transpose[{\n    truncations, ConstantArray[acceptanceTolerance, Length[truncations]]}]', ()),
    ('convergencePlot', 'ListLogPlot[\n  Append[plotData, acceptanceData],\n  Frame -> True,\n  FrameLabel -> {\n    Style["Fourier truncation  M = N", 12],\n    Style["Maximum relative reconstruction error", 12]},\n  PlotStyle -> {\n    Directive[RGBColor[0.10, 0.35, 0.70], Thick],\n    Directive[Black, Thick, Dashed],\n    Directive[RGBColor[0.65, 0.20, 0.12], Thick, DotDashed],\n    Directive[RGBColor[0.10, 0.45, 0.25], Thick, Dotted],\n    Directive[GrayLevel[0.45], Thin, Dashed]},\n  Joined -> True,\n  PlotMarkers -> {\n    {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, {Automatic, 7}, None},\n  PlotLegends -> Placed[\n    LineLegend[Append[\n      groups[[All, 1]], Row[{"acceptance  ", Superscript["10", "-3"]}]]],\n    Below],\n  PlotRange -> {{2, 48}, {10^-7, 1}},\n  FrameTicks -> {{\n    Table[{10^exponent, Superscript["10", ToString[exponent]]},\n      {exponent, -7, 0}], None}, {Automatic, None}},\n  GridLines -> {None, {acceptanceTolerance}},\n  GridLinesStyle -> Directive[GrayLevel[0.65], Dashed],\n  ImageSize -> 520,\n  BaseStyle -> {FontFamily -> "Latin Modern Roman", 11}]', ()),
    ('fieldTeX', '<|\n  "II_tz" -> "\\\\mathrm{II}_{\\\\vartheta\\\\zeta}",\n  "II_tt" -> "\\\\mathrm{II}_{\\\\vartheta\\\\vartheta}"', ()),
    ('worstFieldTeX', 'Lookup[fieldTeX, worstRow[[2]], "\\\\texttt{" <>\n    StringReplace[worstRow[[2]], "_" -> "\\\\_"] <> "}"]', ()),
    ('numberText', 'StringRiffle[{\n  "\\\\newcommand{\\\\GVECFourierHighestTruncation}{" <>\n    ToString[Last[truncations]] <> "}",\n  "\\\\newcommand{\\\\GVECFourierAcceptanceTolerance}{" <>\n    scientificTeX[acceptanceTolerance, 2] <> "}",\n  "\\\\newcommand{\\\\GVECFourierWorstField}{" <> worstFieldTeX <> "}",\n  "\\\\newcommand{\\\\GVECFourierWorstRelativeError}{" <>\n    scientificTeX[worstRow[[4]], 4] <> "}",\n  "\\\\newcommand{\\\\GVECFourierPointCount}{" <>\n    ToString[4 Last[truncations] + 1] <> "}"}, "\\n"]', ()),
]

def _field_tex_atom(literal: str):
    """Return the collision-safe SymPy atom for the source TeX string."""

    digest = hashlib.sha256(
        json.dumps(literal, ensure_ascii=False).encode('utf-8')
    ).hexdigest()
    return sp.Symbol('fortsymString' + digest)


def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/proj-gvec-stability/gvec_fourier_convergence.wl',
    )
    # The source association contains these exact exported labels.  Recover the
    # scalars even though the generic assignment pass leaves associations
    # opaque; the validation CSV is intentionally not needed for these bindings.
    values['II_tz'] = _field_tex_atom(r'\mathrm{II}_{\vartheta\zeta}')
    values['II_tt'] = _field_tex_atom(r'\mathrm{II}_{\vartheta\vartheta}')
    return values
