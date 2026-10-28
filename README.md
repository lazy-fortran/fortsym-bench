# fortsym-bench

A corpus of real symbolic derivations, used to check the correctness and speed of
[fortsym](https://github.com/lazy-fortran/fortsym), a computer algebra system written
in Fortran, against two independent open-source oracles.

Status: research benchmark under active development. Full agreement with the oracles
has not been reached; see [results](docs/results.md).

## What it does

- Holds 384 Wolfram-language derivation scripts (`.wl`) from plasma-physics research
  projects and teaching material, each with a SymPy companion (`.py`).
- Runs every script through three backends and compares the named results:

  | Backend | Reads | Role |
  |---|---|---|
  | `sympy` | `.py` | oracle for the Python path |
  | `mathics` | `.wl` | oracle for the Wolfram-language path (Mathics3) |
  | `fortsym-wl` | `.wl` | native Fortran interpreter of a Wolfram-language subset, under test |

  An optional `fortsym-sympy` backend can run the `.py` companions against a separate
  `fortsym.sympy` package in place of SymPy; that package is not part of this repository.
- Classifies each result as agreement, difference, explicit refusal, timeout, error,
  or a disagreement between the two oracles. Refusals are never counted as wrong
  answers, and oracle disagreements are not scored against the candidate.
- Records wall time per script and backend on identical inputs, with failures kept
  out of the timing sample.
- Caches raw backend output and comparison verdicts so that repeated audits only
  rerun what changed.

No Wolfram product is used. Mathics is an independent reimplementation of the
Wolfram Language with partial coverage, so it serves as a second opinion rather than
ground truth.

## Install

Requires Python 3.11 or newer.

```sh
pip install -e '.[dev]'
uv tool install --force --with packaging mathics3   # Mathics oracle (optional)
```

The native backend calls the `fortsym_wl_run` executable built from the
[fortsym](https://github.com/lazy-fortran/fortsym) repository; put it on `PATH`.
A backend whose executable is missing is reported as `unavailable` and is not scored.

## Usage

```sh
fortsym-bench run                                # all scripts, default backends
fortsym-bench run corpus/mhd1d                   # one project directory
fortsym-bench run --backend sympy fortsym-wl     # selected backends
fortsym-bench run --jobs 1 --repeat 5 --report results.json
```

`corpus/mhd1d/00_example.wl` and `00_example.py` form a minimal corpus pair that
shows the format. Run the test suite with `pytest`.

## Layout

```
corpus/<project>/<name>.wl    original derivation
corpus/<project>/<name>.py    SymPy companion (generated or hand-written)
fortsym_bench/                harness, backends, comparator, WL-to-SymPy translator
tools/                        corpus translation, Fortran inventory, notebook conversion
translation-manifest.json     per-script translation coverage
TRANSLATION.md                rules for translating .wl to SymPy
```

## Documentation

- [Running the benchmark](docs/running.md): options, caching, regenerating companions
- [Comparison and outcomes](docs/comparison.md): strictness levels, outcome classes, timing
- [Corpus](docs/corpus.md): contents, provenance, writing a corpus pair, notebook conversion
- [Results](docs/results.md): latest measured agreement
- [Translating .wl to SymPy](TRANSLATION.md)

## License

MIT. See [LICENSE](LICENSE). Mathics3 is GPL-3.0 and is called only as a separate
process.
