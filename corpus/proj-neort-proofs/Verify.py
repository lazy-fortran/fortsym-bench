"""Generated SymPy translation of ``corpus/proj-neort-proofs/Verify.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 18 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('$results', '{}', ()),
    ('$suite', '"unnamed"', ()),
    ('record', 'AppendTo[$results, <|\n     "label" -> label, "kind" -> kind,\n     "pass" -> If[pass === None, Null, TrueQ[pass]],\n     "detail" -> ToString[detail, InputForm]|>]', ('label', 'kind', 'pass', 'detail')),
    ('symZeroQ', 'Module[{s},\n   s = Quiet @ Check[Simplify[expr, assum], $Failed];\n   If[TrueQ[s == 0], Return[True]];\n   s = Quiet @ Check[FullSimplify[expr, assum], $Failed];\n   TrueQ[s == 0]]', ('expr', 'assum')),
    ('Note', '(record[label, "note", None, text];\n   Print["  NOTE ", label, ": ", text];)', ('label', 'text')),
    ('EndSuite', 'Module[{checks, ntot, npass, failed},\n   checks = Select[$results, #["kind"] =!= "note" &];\n   ntot = Length[checks];\n   npass = Count[checks, _?(#["pass"] === True &)];\n   failed = Select[checks, #["pass"] =!= True &];\n   Export[outfile, <|"suite" -> $suite, "total" -> ntot, "passed" -> npass,\n      "results" -> $results|>, "JSON"];\n   Print["SUITE ", $suite, ": ", npass, "/", ntot, " passed"];\n   If[Length[failed] > 0,\n      Print["FAILED: ", StringRiffle[failed[[All, "label"]], ", "]]];\n   Exit[If[npass === ntot, 0, 1]]]', ('outfile',)),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-neort-proofs/Verify.wl')
