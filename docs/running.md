# Running the benchmark

## Command line

```sh
fortsym-bench run [PATHS ...] [options]
```

`PATHS` are corpus directories or individual scripts; the default is the whole
`corpus/` tree.

| Option | Default | Meaning |
|---|---|---|
| `--backend NAME ...` | `sympy mathics fortsym-wl` | backends to run |
| `--jobs N` | 4 (or the CPU count, if smaller) | scripts evaluated concurrently |
| `--repeat N` | 1 | timed repetitions per script and backend |
| `--timeout SECONDS` | 300 | per-script limit |
| `--report FILE` | none | write the full JSON report |
| `--cache FILE` | `.cache/reference-results.json` | raw-result cache |
| `--no-cache` | off | neither read nor write the caches |
| `--refresh-reference` | off | rerun the oracle backends and replace their cache entries |
| `--refresh-cache` | off | rerun all cacheable backends |

Use `--jobs 1` for a serial pass with more reproducible timings.

## Backends

- `sympy` imports each `.py` companion and calls its `results()` function.
- `mathics` runs the `.wl` file with `mathics -q --no-readline` inside a wrapper that
  captures the script's assignments.
- `fortsym-wl` runs the `.wl` file with `fortsym_wl_run`, the native Fortran
  interpreter from the fortsym repository. It does not call Mathematica, Mathics or
  Python.
- `fortsym-sympy` (optional) replaces the `sympy` module with `fortsym.sympy` before
  importing the companion, so the same file runs unmodified on both.

Each script and backend pair runs in its own subprocess, so a crash or leaked module
state cannot affect another run. Results return as text (`srepr` from Python,
`InputForm` from the Wolfram side) and are parsed back with SymPy, using
`sympy.parsing.mathematica` for Wolfram syntax.

## Caching

Raw outcomes of all three default backends are cached in
`.cache/reference-results.json`; comparison verdicts are cached separately in
`.cache/reference-results.comparisons.json`. A cache entry is keyed by the backend
configuration, the source file digest and a fingerprint of the backend executable,
so an edited script or a rebuilt native binary invalidates only the affected rows.
A change to the SymPy translator invalidates SymPy rows through the backend cache
version. Successful results remain valid when the timeout changes; timeouts remain
tied to the limit that produced them. If an optional oracle disappears from `PATH`,
an existing compatible cached row is kept rather than replaced by `unavailable`.

Use `--refresh-reference` after upgrading an oracle, `--refresh-cache` for a full
fresh pass, and `--no-cache` to bypass both caches.

## Regenerating SymPy companions

```sh
python tools/translate_wl_corpus.py                      # add missing companions
python tools/translate_wl_corpus.py --refresh-generated  # after a translator change
```

Generated companions are produced by the bounded translator in
`fortsym_bench/wl_to_sympy.py` from the assignment statements of each `.wl` file.
Hand translations are preserved unless `--force` is given. Statements the
translator cannot lower are recorded in `translation-manifest.json` rather than
replaced with invented mathematics.

## Fortran translation inventory

```sh
python tools/inventory_wl_to_f90.py --report /tmp/wl-to-f90.json
```

This runs fortsym's `fortsym_wl_to_f90` source translator on every `.wl` file in a
temporary directory and records one row per source: `translated`, `refused`,
`timeout`, `unavailable` or `error`. `translated` only means that non-empty Fortran
was emitted; it is not a semantic comparison. `--require-all-translated` turns the
inventory into a strict check. See `--help` for the remaining options.
