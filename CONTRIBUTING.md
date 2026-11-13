# Contributing

Keep each corpus derivation and its SymPy companion together. Add the source,
author and reuse terms to [SOURCES.md](SOURCES.md), and update the translation
manifest when adding or regenerating a companion. Preserve independent checks
when changing either representation; equivalent-looking output is not enough.

Install the development dependencies and run the tests:

```sh
pip install -e '.[dev,mathics]'
pytest
```

Tests that compile translated Fortran also require a Fortran compiler and
fortsym's `fortsym_wl_to_f90` on `PATH`. A missing backend is a skipped or
unavailable result, never a passing semantic check.

Describe the observed problem, the expected result and the checks performed in
a pull request. Keep new tests in the existing `test/` or `tests/` directories.
