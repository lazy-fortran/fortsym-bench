# fortsym-bench

A corpus of real symbolic derivations, run across three active backends and
compared. Open-source oracles, one corpus, no duplication.

| Backend | Reads | Role |
|---|---|---|
| `mathics` | `.wl` | oracle for the Wolfram-language path (GPL-3.0, subprocess) |
| `sympy` | `.py` | oracle for the Python path (BSD-3-Clause) |
| `fortsym-wl` | `.wl` | native Fortran Wolfram-language subset under test |
| `fortsym-sympy` | `.py` | optional drop-in hook; requires a separate `fortsym.sympy` package |

Both correctness **and** wall time are reported, on identical inputs.

## The idea

The corpus holds 384 Wolfram-language derivation scripts. Every one now has a
Python companion: 382 are generated from the assignment stream by the bounded
translator in `fortsym_bench/wl_to_sympy.py`, one Association fixture is hand
expanded, and one original hand translation is preserved. The companions cover
9,051 assignments. 11,503 non-assignment statements still need manual
translation, and `translation-manifest.json` records them explicitly. Control
flow and side effects are not silently replaced with invented mathematics.

The checked-in Python oracle runs the generated companions with ordinary
SymPy. An optional `fortsym-sympy` backend can replace that module with a
separate `fortsym.sympy` implementation when one is installed; this
Fortran-first checkout does not ship that Python package.

For that optional path the entire difference is one line in the harness:

```python
sys.modules["sympy"] = fortsym.sympy
```

For the Wolfram path it is which interpreter is handed the same `.wl` file.

That constraint is deliberate. A compatibility layer needing per-script edits
reintroduces exactly the drift fortsym exists to eliminate — two copies of a
derivation that agree today and diverge silently next year.

The `fortsym-wl` executable is the native Fortran backend. It parses and
evaluates the original `.wl` source in Fortran; it does not call Mathematica,
Mathics, Python, or a generated per-script wrapper. Consequently all 384
source files are exercised by the native path from the same inputs as the
Mathics oracle. A native run can still refuse a construct or time out; those
are reported explicitly rather than being presented as parity.

## No Wolfram product is used

Mathics is an independent open reimplementation of the Wolfram Language. It is
the oracle precisely so that no Mathematica installation, Wolfram Cloud query or
Wolfram|Alpha call is involved anywhere in fortsym's development. See
`LEGAL.md` §5.1 in the fortsym repository.

Mathics is not Mathematica: its coverage is partial and it has its own defects.
It is a second opinion, not ground truth. **Where Mathics and SymPy disagree,
that is a finding to investigate, not a number to average.** The harness reports
oracle disagreement as its own outcome class.

Install the Mathics oracle as an isolated UV tool with:

```sh
uv tool install --force --with packaging mathics3
```

The verified development installation is Mathics3 10.0.1. Its raw outcomes,
like native and SymPy outcomes, are retained in the reference cache so warm
audits do not rerun the interpreter.

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
mistaken for a complete one. The native Fortran path deliberately keeps the
`.wl` source as its input: that is the source-level Fortran translation, while
the Python companions are the separate SymPy translation corpus.

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
COMPARE = {"derivative": "equivalent", "value": "numeric"}
```

- `structural` — the backends must produce the same expression tree.
- `equivalent` — `simplify(a - b) == 0` under the comparison oracle.
- `numeric` — preserve the same expression shape and compare numeric leaves
  using a tolerance derived from the lower reported precision, with two guard
  digits. Use this for translated `N[expr, p]` or `SetPrecision` results.

Both are legitimate. Conflating them silently is not: a result declared
`structural` that only achieves `equivalent` has found a real difference, and
that is worth knowing.

## Running

```sh
pip install -e '.[dev]'

fortsym-bench run                          # SymPy, Mathics, native Fortran
fortsym-bench run corpus/mhd1d             # one project
fortsym-bench run --backend sympy mathics fortsym-wl
fortsym-bench run --repeat 5 --report results.json
fortsym-bench run --jobs 4 --report results.json
```

SymPy, Mathics, and native `fortsym-wl` outcomes are cached incrementally in
`.cache/reference-results.json` by default. A later run reuses unchanged rows;
the report marks them cached and omits stale timing samples. Cache entries
include the backend configuration, source digest, and subprocess executable
fingerprint, so edited scripts and rebuilt native binaries invalidate only the
affected rows. Successful answers remain reusable when the timeout changes;
timeout failures remain tied to the timeout that produced them. If an optional
oracle executable disappears from `PATH`, an existing compatible cached row is
kept instead of being replaced by a new unavailable result. Parsed
comparison verdicts are cached separately in
`.cache/reference-results.comparisons.json`, keyed by both serialized operands,
their syntaxes, the strictness policy, and the comparator version. On the
2026-08-01 corpus, measured again on 2026-08-02, the earlier full refresh after
the translator change took 4:54 with four workers. The latest bounded
CharacteristicPolynomial/LegendreP/Diagonal/list-selector/Coefficient/Solve/
FoldList/ArrayFlatten/Total/PseudoInverse/SingularValueList audit refreshed 380
native rows in 1:14.19 with two workers and a 3.04 GiB peak RSS. The
quoted-string translator refresh updated 175 SymPy rows in 2:00.16 with a 543
MiB peak RSS; the v16 singular-value/extrema transition updated 22 rows in
8.93 seconds; the v17 polynomial transition updated eight rows in 11.28
seconds; the v18 Solve-rule/fractional-`Exponent` transition updated four
rows in 10.46 seconds at 399 MiB RSS; the v19 bounded `Thread` transition
updated 16 rows in 16.51 seconds at 399 MiB RSS; the v20 positive-level
`Map` transition updated six rows in 4.07 seconds at 403 MiB RSS. The 155 MB
raw-result cache
then served
a warm audit in 0.66 seconds
at 337 MiB RSS, with no backend subprocesses started. The full v60 refresh
took 2:14.26 at a 1.61 GiB peak RSS with one worker. The
version-9 SymPy refresh needed for the LegendreP translator took 6:59.96 and
peaked at 3.86 GiB; that cold oracle refresh is not part of the warm path.
The SymPy cache is now version 27: Unicode `λ`, the user symbol `CC`, bounded
`Curl`, and
bounded `With`/`Do` forms are
protected while parsing
function arguments, quoted string literals use the same collision-resistant
comparison atom as the native backend, `Coefficient`/`CoefficientList` are
lowered through SymPy, single-variable `Solve` results are serialized as
Wolfram `Rule` heads, and bounded `FoldList[Plus, initial, list]` and
`ArrayFlatten`, diagonal/zero numeric `SingularValueList`, numeric `Max`/`Min`,
and bounded polynomial heads (`Exponent`, `PolynomialGCD`,
`PolynomialQuotient`, `PolynomialRemainder`, `Numerator`, and `Denominator`)
are translated directly. Version 18 also lets serialized `Rule`/`RuleDelayed`
heads from `Solve` feed `ReplaceAll` and preserves exact fractional-monomial
`Exponent` results. Version 19 also lowers bounded one-level `Thread` forms,
including list-valued `Equal`. Its compatibility transition reused unaffected
older rows and refreshed only the 16 affected rows; the direct version-chain
compatibility avoids repeating a broad oracle refresh on the next translator
change. Version 20 also lowers bounded positive `Map` levels, version 21
lowers numeric `Boole` conditions, version 22 lowers numeric `Which` branches,
and version 23 lowers bounded `TrigReduce` forms. Version 24 also reverses
multiple `Integrate` ranges at the SymPy boundary so the first Wolfram range
remains outermost; its compatibility transition invalidates only generated
rows containing multiple ranges. A current
one-worker audit of the 16-script `Thread` slice, using the
rebuilt native runner, took 17.43 seconds at 508 MiB RSS and reported 249
agreements, 58 differences, 1 unavailable oracle row, 1 timeout, 5 errors,
26 oracle disagreements, and 58 oracle-missing bindings. It converted two
native `Thread` bindings from differences to agreements. A current six-script
positive-level `Map` slice took 1.00 second at 404 MiB RSS; its selected rows
were dominated by plotting/file-I/O or Mathics failures and did not change the
scored native tally. These focused results are not a replacement for a new
whole-corpus baseline.
The v21 native `Piecewise` transition then ran the same six-script focused
slice in 0.85 second at 403 MiB RSS and preserved 21 agreements, 6
differences, 3 unavailable oracle rows, 2 oracle disagreements, and 3
oracle-missing bindings, with no scored native tally change.
The v22 native `Boole` transition refreshed three SymPy rows in 2.91 seconds
at 404 MiB RSS and preserved 21 agreements, 7 differences, 1 unavailable
oracle row, 1 oracle disagreement, and 1 oracle-missing binding, with no
scored native tally change.
The v23 native `Which` transition then served a five-script warm slice in 0.71
second at 404 MiB RSS: 60 agreements, 16 differences, 1 timeout, 1
unavailable oracle row, 3 oracle disagreements, and 73 oracle-missing
bindings. Its cached timeout/unavailable outcomes were not rerun.
The v24 native `TrigReduce` transition then served a six-script warm slice in
0.72 second at 404 MiB RSS: 101 agreements, 48 differences, 3 unavailable
oracle rows, 1 timeout, and 103 oracle-missing bindings. Its cached timeout
was not rerun. The v25 native bounded symbolic 2x2 `Solve` transition then
served the exposing corpus script in 0.78 second at 404 MiB RSS: 33
agreements, 10 differences, 1 unavailable oracle row, and 1 oracle-missing
binding, with no timeout or runner error.
The v26 verified exponential-product `Integrate` transition then served a
three-script slice in 0.78 second at 404 MiB RSS: 5 agreements, 1 difference,
1 unsupported backend outcome, 1 unavailable oracle row, and 1 oracle
disagreement, with no timeout or runner error. The v27 native
definite/multiple-`Integrate` transition then evaluated the measured
nested-limit script in a warm one-worker audit in 0.77 seconds at 402 MiB RSS.
Native and SymPy produce the complete outer-to-inner result; Mathics retains a
partial unevaluated result, so the three bindings are reported as oracle
disagreements rather than scored as native errors. The v28 dirty-cache-flush
transition then served a three-script warm slice in 0.30 seconds at 334 MiB
RSS without rewriting either cache file or starting an oracle subprocess; the
native backend itself took 0.0001--0.0014 seconds per script.
The v29 SymPy translator slice now lowers bounded scalar first-order `DSolve`
with callable dependent variables, with 35 focused translation tests passing;
the corresponding velocity-integral companion still needs `SetDelayed`
lowering before its later integral bindings can be exported.
The v30 extraction slice also recovers assignments hidden in notebook-export
`(compound-prefix)*opaque-head` wrappers, while preserving the opaque suffix;
93 focused/full tests pass after that change.
The v31 callable-definition slice adds bounded scalar `Set`/`SetDelayed`
semantics after `DSolve`, including Wolfram `C[1]` normalization; the v32
slice adds bounded lexical `Module` locals with sequential assignments and
nested shadowing, and v33 normalizes derivative `Subs` wrappers after
replacement. The v52 full suite passed 196 tests; v53–v60 add 33 focused
tests, bringing collection to 229. The refreshed 384-source
cache contains 376 successful SymPy rows, 4 unsupported rows, and 4 timeouts,
plus 255 successful Mathics rows, 60 errors, and 69 timeouts; all rows are
reusable at timeout 15. The native cache contains 378 successful rows, 3
unsupported rows, 3 timeouts, and no runner errors.
The subsequent slices protect ordinary `zeta` coordinates from SymPy's
built-in Zeta parser, lower bounded `Position`/`Union`, classify list-valued
InputForm arithmetic without comparator crashes, and normalize the `sympl3_`
unit constants. The v34 bounded large-step, kinetic-bridge, and Bacc/Rosa/Posch
companion refreshes recover eight previously opaque SymPy bindings and six
verified machine-precision numeric comparisons. The v35 cycle also refreshes
the `math8y`, `sympl3_`, and general-Maxwell companions, and adds a Mathics
Boolean-assumptions shim. The v36 cycle expands the helical-core first-order
derivative and bounded Solve companions, and hardens Mathics derivative
conversion for expression-valued heads. The v37 cycle adds source-faithful
phase-transform and flux-coordinate companion translations with independent
behavioral tests. The v38 cycle adds source-faithful NAE/DESC geometry and
Appendix-B integral companions, recovering 52 previously oracle-missing
bindings and one SymPy timeout. The v39 cycle adds source-faithful math6-2y,
math11y, two-component energy, and dynamo-diagnostics companions with
independent tests; the dynamo bridge also reduces its focused runtime from
about 29 seconds to 1.1 seconds.
The v40 memo-feedback companion recovers the source magnetic norm and its
dependent geometry bindings, adding seven agreements with an independent test.
The v41 cylinder-spectrum companion recovers the source-faithful force-balance
and pressure-slope bindings with an independent test. The v42 Bacc/Rosa/Posch
companion recovers the source magnetic-field integral and removes one oracle
disagreement. The v43 parity batch adds source-faithful ECNL equation strings,
numeric validity estimates, Maxwell/flux-pumping companions, math10y and
Suydam recoveries, a large-step LTE reconstruction, and Sympl3 field forms;
it adds 12 independent tests. The v44 normal-stability numeric policy adds one
more independently tested agreement. The v45 math3y and Cartesian-primitive
recoveries add two agreements and remove one oracle-missing binding. The v46
math8y and perpendicular-block recoveries add two agreements, remove one
difference, and remove one oracle-missing binding. The v47 math10y, math6-1y,
and cylinder-spectrum recoveries add six agreements, remove three differences,
and remove three oracle-missing bindings. The v48 math11y/Mercier pass adds one
agreement and removes one oracle-missing binding in the authoritative audit.
The v49 Appendix-B, math14y, and math15y recoveries add seven agreements and
remove seven oracle-missing bindings. The v50 Suydam, deleted math6-2y, and
flux-pumping recoveries, followed by the v51 general-Maxwell, corrugation, and
math3y recoveries, and the v52 Appendix-B, Solovev, math11y, math8y, and flux
recoveries, followed by the v53 math12y point, v54 iota-series and torus
intermediate, and v55 math10y, Mercier, Cartesian, variational, math12u, and
c-components recoveries, followed by v56 TDRK and linear delta-f recoveries,
extend the source-faithful companion set, followed by v57 math11y aliases and
code-mhd1d equilibrium intermediates, and v58 detuning, projected-scheme,
profile-certificate, and gc-drift recoveries. The v59 cycle adds bounded
Wolfram `With` translation, native scientific-literal precedence and
vector-matrix `Dot`; v60 adds bounded `Do`, numeric native `FindRoot`, and the
`aMaxSq` oracle binding. The current cache-only score is 3,853 agreements, 468
differences, 7 unsupported outcomes, 76
timeouts, 60 errors, 2 unavailable oracle rows, 194 oracle disagreements, and
354 oracle-missing bindings. The Mathics wrapper
also neutralizes `Quit`, isolates per-run protocol symbols, restores
`$Assumptions` safely after local integrals; current Mathics inventory is 255
successful rows, 60 errors, and 69 timeouts. Its cache is version 6 and
selectively refreshes legacy `Curl` rows after the cylindrical rule was added.
Use `--refresh-reference` after upgrading an oracle, `--refresh-cache` for a
full fresh backend pass, or `--no-cache` to disable both caches. A rebuilt
native executable invalidates only its own rows, and a translator change
invalidates SymPy rows through the backend cache version.

Corpus scripts run concurrently (four workers by default); use `--jobs 1` for
a serial, easier-to-reproduce timing pass. The comparison path first accepts
identical serialized results, does not call expensive `simplify` for a
structural mismatch, and bounds non-identical serialized operands at 4 MiB.
An oversized operand is reported as an explicit comparison error rather than
allowing one expanded expression to stall the complete audit.

Regenerate missing Python companions with:

```sh
python tools/translate_wl_corpus.py
# Refresh generated companions after changing the translator:
python tools/translate_wl_corpus.py --refresh-generated
```

Existing hand translations are preserved. Use `--force` only when deliberately
replacing them.

The bounded source-to-Fortran slice can be inventoried without touching the
corpus. It writes each candidate into a temporary directory and records one
machine-readable row per `.wl` source:

```sh
python tools/inventory_wl_to_f90.py --report /tmp/wl-to-f90.json
```

`translated` means only that `fortsym_wl_to_f90` accepted the source and emitted
non-empty Fortran. `refused`, `timeout`, `unavailable`, and `error` remain
separate. The inventory does not compile, execute, or compare the generated
source, so it must not be read as whole-corpus Fortran parity. Add
`--require-all-translated` to use it as a strict acceptance gate.

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
- `untranslated` — the corpus entry has no source file for that backend. The
  current inventory has a Python companion for every `.wl` source, so this
  class is zero. It remains separate from the 11,503 statements recorded as
  skipped inside those companions.
- `unavailable` — the backend is not installed. Never folded into a scored
  class: an absent oracle that shrinks the denominator overstates every rate.
- `error` / `timeout` — crashed, or exceeded the limit.
- `oracle-disagreement` — Mathics and SymPy do not agree with each other. Under
  investigation; the native result is not scored on that binding.
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
translations and counts statements that still need manual work. The latest
native cache contains 378 successful script rows, 3 explicit unsupported
rows, 3 timeouts, and no runner errors, with no native crashes. The SymPy cache
contains 376 successful rows, 4 unsupported rows, and 4 timeouts; the Mathics
cache contains 255 successful rows, 60 errors, and 69 timeouts. The latest
committed full binding-level audit has 3,853 agreements, 468 declared
differences, 7 unsupported outcomes, 76 timeouts, 60 errors, 194 oracle
disagreements, and 354 oracle-missing bindings. Its warm run took 0.66
seconds at 337 MiB RSS. The v69 audit on 2026-08-03 reports 3,863
agreements, 465 declared differences, 7 unsupported outcomes, 76 timeouts, 61
errors, 208 oracle disagreements, and 349 oracle-missing bindings across 4,888
bindings. The v75 cache-preserving refresh took 6.10 seconds at about 491 MiB
RSS; its warm compact-cache pass reused 378 native, 376 SymPy, and 255 Mathics
rows in 0.81 seconds at about 491 MiB RSS. The v76 UV warm compact-cache pass
reused the same 378 native, 376 SymPy, and 255 Mathics rows in 0.90 seconds at
about 490 MiB RSS. The v76 cycle adds source-faithful `math10y` and `math11y`
recoveries. The v77 UV cache-preserving pass took 2.69 seconds at about 488 MiB
RSS after the `math15y` refresh; its all-warm compact-cache pass took 1.06
seconds at about 488 MiB RSS. The v78 cache-preserving pass took 4.03 seconds
at about 489 MiB RSS; its all-warm compact-cache pass took 1.00 second at about
488 MiB RSS. The v77 cycle adds a source-faithful `math15y` recovery, and the
v78 cycle adds three source-faithful `math10y` bindings plus a cylinder-spectrum
recovery. The v79 cache-preserving pass took 4.29 seconds at about 489 MiB RSS;
its all-warm compact-cache pass took 1.33 seconds at about 489 MiB RSS. The v80
cache-preserving pass took 6.07 seconds at about 487 MiB RSS; its all-warm
compact-cache pass took 1.10 seconds at about 488 MiB RSS. The v79 cycle adds
source-faithful `jDotB` and memo34 radial-product bindings. The v80 cycle adds
final `math10y` `Which` coverage and large-step recurrence bindings; they pass
focused tests but do not change the scored tally. The v81 native fingerprint
refresh took 92.48 seconds at about 1.54 GiB RSS; its all-warm UV pass took 1.06
seconds at about 488 MiB RSS. The v81 cycle adds six `vector2d` fields and a
flux access-condition correction. The v82 cache-preserving pass took 7.43
seconds at about 488 MiB RSS; its all-warm UV pass took 1.06 seconds at about
489 MiB RSS. The v82 cycle adds a memo37 factored-derivative binding and a
source-faithful cylinder-spectrum derivative tree. The v83 cache-preserving
pass took 4.35 seconds at about 489 MiB RSS; its all-warm UV pass took 0.93
seconds at about 489 MiB RSS. The v83 cycle adds a `math10y` theta binding,
two-component density contraction, and source-faithful perpendicular-block
projection. The v84 cache-preserving pass took 4.44 seconds at about 489 MiB
RSS; its all-warm UV pass took 0.95 seconds at about 489 MiB RSS. The v84 cycle
adds symbolic `peng` Dot preservation, physical-weighted energy, and sequential
SWR recovery; the unresolved-class counts improve, but the agreement tally does
not. The v85 cache-preserving pass took 5.55 seconds at about 489 MiB RSS; its
all-warm UV pass took 1.79 seconds at about 490 MiB RSS. The v85 cycle adds the
memo37 delta normal form; it reduces an unresolved class but does not add an
agreement. The v86 cache-preserving pass took 6.38 seconds at about 489 MiB RSS;
its all-warm UV pass took 1.11 seconds at about 489 MiB RSS. The v86 cycle adds
`math10y` fourth-root coverage, a `sympl3_` denominator correction, and a memo34
Bessel-kernel branch. The v87 cache-preserving pass took 3.96 seconds at about
489 MiB RSS; its all-warm UV pass took 1.08 seconds at about 489 MiB RSS. The
v87 cycle adds a Gaussian-integral `math10y` binding, the heat-kernel `k3`, and
a `gc_drift` Christoffel tensor. The v88 cache-preserving pass took 3.47 seconds
at about 488 MiB RSS; its all-warm UV pass took 0.93 seconds at about 489 MiB
RSS. The v88 cycle adds the `math10y` derivative binding and `gc_drift`
`gradBmod`. The v89 cache-preserving pass took 3.03 seconds at about 489 MiB
RSS; its all-warm UV pass took 0.96 seconds at about 489 MiB RSS. The v89 cycle
adds second-derivative `math10y` coverage, a source-faithful pressure slope,
and scalar reassignment codegen. The v90 cache-preserving pass took 3.18 seconds
at about 489 MiB RSS; its all-warm UV pass took 0.94 seconds at about 489 MiB
RSS. The v90 cycle adds strict bounded `For` forms in the native translator.
The v91 cache-preserving pass took 3.97 seconds at about 488 MiB RSS; its
all-warm UV pass took 0.92 seconds at about 489 MiB RSS. The v91 cycle adds
source-faithful `math10y` weighted second derivatives, heat-kernel tails, and a
two-component flux-temperature-slope binding.
The v92 cache-preserving pass took 2.74 seconds at about 489 MiB RSS; its
all-warm UV pass took 1.01 seconds at about 489 MiB RSS. The v92 cycle adds
transformed `math11y` ODEs, `gc_drift` gradients, a large-step fast-free
binding, four gvec validation bindings, and a bounded Fortran adapter test.
The v93 cache-preserving pass took 1.75 seconds at about 489 MiB RSS; its
all-warm UV pass took 1.11 seconds at about 489 MiB RSS. The v93 cycle adds
heat, gvec export, `math10y`, and archive `math6-1y` recoveries.
The v94 cache-preserving pass took 1.25 seconds at about 489 MiB RSS; its
all-warm UV pass took 1.04 seconds at about 489 MiB RSS. The v94 cycle adds
gvec Fourier, archive `math6-1y`/`math15y`, `math11y`, and two-component
energy-identity recoveries.
The v95 cache-preserving pass took 1.75 seconds at about 489 MiB RSS; its
all-warm UV pass took 0.89 seconds at about 489 MiB RSS. The v95 cycle adds
ECNL, zero-family, GH NTV, flux-handedness, and project-NTV recoveries.
The v96 cache-preserving pass took 2.29 seconds at about 489 MiB RSS; its
all-warm UV pass took 0.89 seconds at about 489 MiB RSS. The v96 cycle adds
geomint and flux-pumping agreements plus source-faithful vector2d, Bacc, and
cylinder-kernel corrections; one oracle disagreement is newly exposed.
The v97 cache-preserving pass took 1.72 seconds at about 489 MiB RSS; its
all-warm UV pass took 0.86 seconds at about 489 MiB RSS. The v97 cycle adds a
`math10y` Fourier binding, two flux44 bindings, two symbolic parity fixes, and
a memo37 difference reduction; the latter exposes one oracle disagreement.
The preceding v74 cold one-worker
pass took 1:10.89 at a 1.61 GiB peak RSS. The v75 cycle adds named-derivative SymPy
lowering, two joined-plot recoveries, and bounded source-to-Fortran `Do`
lowering; the v71 cycle adds bounded `Do` assignment loops and six
source-faithful `math10y` companion recoveries. The v70 cycle adds exact
identity-matrix fractional powers, source-faithful numeric `Abs`,
Mathics algebraic-root protection, and selective SymPy v28 cache invalidation.
The v68 cycle adds
bounded cylindrical `Curl` support to both
open-source oracle paths, selective Mathics cache invalidation, bounded
matrix contractions in the generated gc-drift companion, and the named-blank
native rule path.

The bounded Fortran inventory in `tools/inventory_wl_to_f90.py` inspected all
384 `.wl` sources on 2026-08-02 with a serial five-second limit. It emitted
0 Fortran files and explicitly refused 384; there were no compile errors,
timeouts, or runner errors. The inventory is an acceptance report only: emitted
text is not yet executed or compared semantically against the source.

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

Harness runs. Corpus ingestion, persistent raw-output and comparison caching,
the complete Python companion inventory, and the native Fortran backend are in
place. The v97 audit on 2026-08-03 produced 3,912 agreements, 479 declared
differences, 7 unsupported outcomes, 75 timeouts, 61 errors, 197 oracle
disagreements, and 294 oracle-missing bindings across 4,885 bindings. Mathics3
10.0.1 is installed with UV. The independent regression suites cover the v70
through v97 changes. Translation quality and the remaining backend parity work
stay measured by the independent oracle report; the report is the source of
truth for current counts.
