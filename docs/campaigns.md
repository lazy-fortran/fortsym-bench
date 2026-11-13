# Retaining and classifying benchmark evidence

The campaign runner saves successful backends' parsed result mappings before
comparison. A comparison timeout preserves these operands and remains separate
from a backend timeout or a mathematical disagreement. Complete backend
transcripts and partial results from failed backends are not retained.
An otherwise successful Wolfram run can explicitly refuse individual statements.
Its parsed bindings are retained alongside `coverage.status = "partial"` and the
tagged refusal messages. Binding comparisons remain available, but neither an
agreement nor a difference establishes whole-script correctness when a refused
statement may affect later state. Coverage counts and value comparisons are
reported separately. Older artifacts without this field have unrecorded
execution coverage.
Here `complete` means that the successful process emitted no tagged refusal;
it does not prove that every operation was implemented correctly.

List the deterministic case indices, then run one case per process:

```sh
python -m fortsym_bench.campaign list --out results/inventory.json
python -m fortsym_bench.campaign run --case-index 0 --out results/full \
    --inventory results/inventory.json --timeout 60 --comparison-timeout 60
```

Repeat the second command for the remaining indices, using the same unchanged
corpus and executables. Independent cases can run concurrently. Each case has
its own directory, result cache, timings, source hashes and runtime metadata.
Every case is checked against the frozen inventory before execution.
Existing case directories are never overwritten.

Supply `--metadata experiment.json` to record the native source revision, build
configuration and any experiment-specific parameters. The runner records the
Python package versions, backend executable fingerprints and `FORTSYM_` runtime
settings. It cannot infer the source revision from an arbitrary native binary.
Retain the compiler and linked-library manifest beside the experiment metadata.
Set `FORTSYM_BENCH_RUNTIME_MANIFEST` to the verified runtime manifest when using
shared native libraries. Its file identity participates in cache keys alongside
the executable, delegate settings and library search paths. The experiment
launcher must verify that the active libraries match it; the cache does not
resolve the platform loader. Python cache keys also include the actual SymPy
Mathematica parser source identity. Keep these dependencies immutable during a
run and regenerate the manifest after rebuilding libraries.

Merge completed cases against the frozen inventory:

```sh
python -m fortsym_bench.campaign merge results/full --out results/full.json \
    --inventory results/inventory.json
```

The merge rejects missing or duplicate cases, changed sources and mixed runtime
or experiment configurations. Merged outputs must be outside retained case
directories and cannot replace an input artifact or the frozen inventory.
The merged report uses the ordinary benchmark's
verdicts and coverage totals.
Backend timings exclude comparison time. The separate per-case wall time
includes backend startup and comparison. A comparison that exceeds its wall-time
limit is reported as a timeout for its candidate bindings, never as a wrong
answer. Its raw operands remain available for a later bounded analysis.

For an experiment that changes only the native implementation, use
`--oracle-root results/full` with a different output root. SymPy and Mathics
outputs are then reused exactly, with source hashes checked and the retained
reference artifacts identified in each case. Reused reference timings are not
fresh measurements. This keeps oracle coverage fixed across native variants.

Classify the merged report using its retained cache:

```sh
python -m fortsym_bench.classify results/full.json \
    --cache results/full.raw-cache.json --root . --out results/classified.json
```

[Disagreement classification](disagreements.md) distinguishes exact equivalence
witnesses, reviewed mathematical explanations, explicit refusals and unresolved
cases.
