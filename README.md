# fortsym-bench

A corpus of real symbolic derivations, run across four backends and compared.
Open-source oracles, one corpus, no duplication.

| Backend | Reads | Role |
|---|---|---|
| `mathics` | `.wl` | oracle for the Wolfram-language path (GPL-3.0, subprocess) |
| `sympy` | `.py` | oracle for the Python path (BSD-3-Clause) |
| `fortsym-wl` | `.wl` | fortsym's Wolfram-language subset under test |
| `fortsym-sympy` | `.py` | fortsym's SymPy subset under test |

Both correctness **and** wall time are reported, on identical inputs.

## The idea

The corpus holds 384 Wolfram-language derivation scripts. Every one now has a
Python companion: 382 are generated from the assignment stream by the bounded
translator in `fortsym_bench/wl_to_sympy.py`, one Association fixture is hand
expanded, and one original hand translation is preserved. Unsupported control
flow and side effects remain explicit in `translation-manifest.json`; they are
not silently replaced with invented mathematics.

For the Python path the entire difference is one line in the harness:

```python
sys.modules["sympy"] = fortsym.sympy
```

For the Wolfram path it is which interpreter is handed the same `.wl` file.

That constraint is deliberate. A compatibility layer needing per-script edits
reintroduces exactly the drift fortsym exists to eliminate — two copies of a
derivation that agree today and diverge silently next year.

## No Wolfram product is used

Mathics is an independent open reimplementation of the Wolfram Language. It is
the oracle precisely so that no Mathematica installation, Wolfram Cloud query or
Wolfram|Alpha call is involved anywhere in fortsym's development. See
`LEGAL.md` §5.1 in the fortsym repository.

Mathics is not Mathematica: its coverage is partial and it has its own defects.
It is a second opinion, not ground truth. **Where Mathics and SymPy disagree,
that is a finding to investigate, not a number to average.** The harness reports
oracle disagreement as its own outcome class.

## Layout

```
corpus/<project>/<nn>_<name>.wl    original derivation
corpus/<project>/<nn>_<name>.py    generated or hand translation to SymPy
fortsym_bench/                     harness, runners, comparator
translation-manifest.json          generated/hand coverage and skipped statements
TRANSLATION.md                     rules for translating .wl to SymPy
```

The two files of a pair should expose the same result names. Generated
companions expose every binding the shared runtime can lower and record the
rest as explicit translation coverage, so a partial SymPy oracle cannot be
mistaken for a complete one.

## Writing a corpus pair

The Python side is a plain module that imports `sympy` and exposes `results()`:

```python
import sympy as sp

def results():
    x = sp.Symbol("x", real=True)
    return {
        "pythagorean": sp.simplify(sp.sin(x)**2 + sp.cos(x)**2),
        "derivative":  sp.diff(sp.exp(x**2), x),
    }
```

The Wolfram side assigns an association of the same names:

```wolfram
x = Symbol["x"];
fortsymBenchResults = <|
  "pythagorean" -> Simplify[Sin[x]^2 + Cos[x]^2],
  "derivative"  -> D[Exp[x^2], x]
|>;
```

Declare per-result strictness when structural equality is not the right bar:

```python
COMPARE = {"derivative": "equivalent"}   # default: "structural"
```

- `structural` — the backends must produce the same expression tree.
- `equivalent` — `simplify(a - b) == 0` under the comparison oracle.

Both are legitimate. Conflating them silently is not: a result declared
`structural` that only achieves `equivalent` has found a real difference, and
that is worth knowing.

## Running

```sh
pip install -e '.[dev]'

fortsym-bench run                          # everything, all backends
fortsym-bench run corpus/mhd1d             # one project
fortsym-bench run --backend sympy fortsym-sympy
fortsym-bench run --repeat 5 --report results.json
```

SymPy and Mathics reference outcomes are cached incrementally in
`.cache/reference-results.json` by default. A later run reuses those answers
and runs only the candidate backends; the report marks cached reference rows
and omits stale timing samples. Cache entries include the backend configuration
and source digest, so edited scripts do not reuse old answers. Successful
answers remain reusable when the timeout changes; timeout failures remain tied
to the timeout that produced them. Use `--refresh-reference` after upgrading
an oracle, or `--no-cache` for a completely fresh run.

Regenerate missing Python companions with:

```sh
python tools/translate_wl_corpus.py
```

Existing hand translations are preserved. Use `--force` only when deliberately
replacing them.

Each (script, backend) pair runs in its own subprocess, so a crash or a
module-state leak cannot reach another. Results cross the process boundary as
text — `srepr` from the Python side, `InputForm` from the Wolfram side — and are
parsed back in the comparison process with SymPy, using
`sympy.parsing.mathematica` for the Wolfram syntax.

## Outcomes

Every (script, result, backend) lands in exactly one class:

- `agree` — matches the oracle at the declared strictness.
- `differ` — produced an answer, and it is wrong. The interesting one.
- `unsupported` — the backend declined, naming the construct. Expected for most
  of the corpus today; the count going down is the measurement.
- `untranslated` — the corpus entry has no source file for that backend. Most
  of the corpus is `.wl`-only today; tracked separately so an untranslated
  corpus cannot move a pass rate in either direction.
- `unavailable` — the backend is not installed. Never folded into a scored
  class: an absent oracle that shrinks the denominator overstates every rate.
- `error` / `timeout` — crashed, or exceeded the limit.
- `oracle-disagreement` — Mathics and SymPy do not agree with each other. Under
  investigation; fortsym is not scored on these.
- `oracle-missing` — the candidate emitted a binding that this partial oracle
  did not. It is reported as coverage, not scored as a wrong answer; only the
  intersection of candidate and oracle bindings is a correctness comparison.

`unsupported` is never silently folded into `differ`. A backend that refuses is
behaving correctly; a backend that guesses is the failure this whole apparatus
exists to catch.

## Timing

Wall time is recorded per script per backend: configurable warmups, repeats, and
the median with a dispersion measure. A backend that returns `unsupported` or
`error` contributes to coverage, never to the timing sample — dropping failures
from a timing average is how misleading benchmark tables get made.

Startup is measured separately from evaluation. Mathics and any subprocess
backend pay a process launch that has nothing to do with algebra, and folding it
into a per-operation number would say more about Python import time than about
either CAS.

Read `doc/benchmarks.md` in the fortsym repository before quoting any number
from here: a run without pinned CPU affinity and a fixed frequency governor is
diagnostic, not evidence.

## Corpus inventory

**384 `.wl` scripts across 50 projects**, ingested 2026-08-01. Every script has
a Python companion; the manifest distinguishes generated, hand, and preserved
translations and counts statements that still need manual work.

Sources: `$HOME/proj`, the `itpplasma` and `lazy-fortran` worktrees, 335 GitHub
repositories reached by tree listing, `~/Nextcloud`, and the personal archive.
Of these, 235 were converted from `.nb` notebooks (7278 input cells, 77 —
about 1.1% — failed to convert and are marked `(* UNCONVERTED CELL *)` in
place). 77 byte-identical duplicates and 14 empty results were dropped during
ingest.

Largest projects: `gvec-stability` 47, `flux_pumping` 44, `neort-proofs` 32,
`cpp-derivation` 18, `plasma/DOCUMENTS` 20, `paper_magnetic` 12, `KiLCA` 9.

**Teaching material is corpus, not padding.** `archive-tu` and `archive-old`
(43 files) are TU coursework, and they cover a *wider* operation mix than the
research scripts do: `Solve` 104, `Integrate` 109, `DSolve` 43, `Factor` 40,
`Eigenvalues` 23, `Limit` 36. The physics corpus is deep in a narrow fragment;
the coursework is shallow across many operations, which is exactly the shape a
compatibility subset has to survive. Anything claiming to be a drop-in
replacement should run a first-year exercise sheet.

One caveat on them: they contain 952 `Plot` calls. Plotting is a deferred area
in fortsym's roadmap, so those cells will report `unsupported` indefinitely.
That is an honest refusal rather than a defect, but it means coverage
percentages for these projects should be read against the non-plotting cell
count.

### Converting notebooks

`tools/nb2wl.wls` extracts Input cells as InputForm text and discards output
cells, formatting and stored results — the corpus wants the derivation, not one
machine's record of having run it. Cells are held during conversion so nothing
recomputes and a cell that errors still converts.

```sh
NB_MANIFEST=manifest.tsv wolfram -script tools/nb2wl.wls
```

This is a format conversion, not a computation: it produces no mathematical
result that fortsym relies on. Nothing in fortsym's build, tests or CI runs it,
and every derivation it emits is checked by Mathics and SymPy. See `LEGAL.md`
§5 in the fortsym repository.

## Status

Harness runs. Corpus ingestion, persistent reference caching, and complete
companion coverage are in place. Translation quality remains measured by the
independent SymPy and Mathics runs; tracker: `lazy-fortran/fortsym#27`.
