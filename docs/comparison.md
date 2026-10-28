# Comparison and outcomes

## Strictness

Each corpus pair may declare, per result, how strictly the candidate must match the
oracle:

```python
COMPARE = {"derivative": "equivalent", "value": "numeric"}
```

- `structural` (default): the expression trees must be identical, apart from a small
  set of registered exact canonicalisations (below).
- `equivalent`: `simplify(a - b) == 0` under the comparison oracle.
- `numeric`: same expression shape, numeric leaves compared with a tolerance derived
  from the lower reported precision plus two guard digits. Use it for translated
  `N[expr, p]` or `SetPrecision` results.

Representation differences that are not registered stay visible under `structural`.

`fortsym_bench/exact_cases.json` lists exact operand pairs from the corpus whose
printed forms differ although they are mathematically equal. A listed pair only
permits a proof attempt: the comparator must reconstruct an exact zero (expanded,
rational, trigonometric or symbolic) before reporting agreement, and it reports that
witness in the result detail. Changed operands, non-zero residuals and approximate
agreement do not pass; no numeric tolerance is used on this path.

The comparator accepts identical serialised results immediately, avoids `simplify`
for structural mismatches, and refuses operands larger than 4 MiB with an explicit
comparison error so that one expanded expression cannot stall a whole audit.

## Outcome classes

Every (script, result, backend) triple receives exactly one class:

- `agree`: matches the oracle at the declared strictness.
- `differ`: an answer was produced and it does not match.
- `unsupported`: the backend declined and named the construct.
- `untranslated`: the corpus entry has no source file for that backend.
- `unavailable`: the backend is not installed. Never folded into a scored class,
  since a smaller denominator would overstate every rate.
- `error` / `timeout`: the backend crashed or exceeded the limit.
- `oracle-disagreement`: Mathics and SymPy disagree with each other; the candidate
  is not scored on that result.
- `oracle-missing`: the candidate produced a result the (partial) oracle did not.
  This counts as coverage, not as a wrong answer.

`unsupported` is never counted as `differ`: refusing a construct is correct
behaviour, guessing is not.

## Timing

With `--repeat N`, each backend's per-script evaluation time is recorded and the
report gives the median, minimum and sample count. Runs that fail never enter the
timing sample. Process start-up is excluded where the runner can separate it.

Timings from a machine without pinned CPU affinity and a fixed frequency governor
are diagnostic only; see `doc/benchmarks.md` in the fortsym repository before
quoting numbers.
