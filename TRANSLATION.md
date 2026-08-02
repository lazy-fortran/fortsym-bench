# Translating a .wl derivation to SymPy

Each corpus entry is a pair: the original `.wl` and a Python companion for the
SymPy path. Most companions are generated from the ordered assignment stream;
hand translations are retained where they express a result container or
control flow more clearly. `translation-manifest.json` records which case is
which and how many source statements were not assignment expressions.

## Rules

1. **Do not simplify the derivation while translating.** The point of the pair
   is that the two files compute the same thing by the same route. A translation
   that "improves" the algebra silently changes what is being tested.
2. **Keep result names identical and stable.** Renaming one is a corpus change.
3. **Translate assumptions explicitly.** `$Assumptions = r > 0` becomes
   `sp.Symbol("r", positive=True)` where that is the whole content, or an
   explicit `refine(..., Q.positive(r))` where it is not. Where SymPy cannot
   express the assumption, say so in a comment and mark the result
   `equivalent` rather than pretending.
4. **Preserve exactness.** `1/3` in Wolfram is exact; `1/3` in Python is not.
   Use `sp.Rational(1, 3)`.
5. **Hand translations import only `sympy`.** Generated companions may import
   `fortsym_bench.wl_to_sympy`, the deterministic runtime that preserves their
   source assignment text. A generated file is still ordinary Python and can
   be inspected or replaced by a hand translation when the bounded runtime is
   not expressive enough.
6. **Numeric checks stay numeric.** `N[expr, 30]` becomes `expr.evalf(30)`;
   keep the tolerance the original used and declare `COMPARE["name"] =
   "numeric"` when the result is intentionally compared by precision rather
   than by its printed decimal tree.

## Common correspondences

| Wolfram | SymPy |
|---|---|
| `D[f, x]` | `sp.diff(f, x)` |
| `Simplify` / `FullSimplify` | `sp.simplify` |
| `Series[f, {x, 0, n}]` + `Normal` | `sp.series(f, x, 0, n+1).removeO()` — see below |
| `Integrate[f, x]` | `sp.integrate(f, x)` |
| `Limit[f, x -> a]` | `sp.limit(f, x, a)` |
| `Solve[eq == 0, x]` | `sp.solve(sp.Eq(eq, 0), x)` |
| `Coefficient[f, x, n]` | `f.coeff(x, n)` |
| `CoefficientList[f, x]` | coefficients from constant term upward |
| `FoldList[Plus, init, list]` | explicit prefix sums including `init` |
| `ArrayFlatten[blocks]` | rectangular block-matrix concatenation |
| `Together` / `Cancel` / `Apart` | `sp.together` / `sp.cancel` / `sp.apart` |
| `Cross[a, b]` | `a.cross(b)` on `sp.Matrix` |
| `Det` / `Inverse` / `Transpose` | `.det()` / `.inv()` / `.T` |
| `BesselJ[n, z]` | `sp.besselj(n, z)` |
| `<\|"k" -> v\|>` result assoc | `return {"k": v}` from `results()` |

## Traps found by the harness

**Series order is off by one.** `Series[f, {x, 0, n}]` includes the `x^n` term;
`sp.series(f, x, 0, n)` stops before it. Translate to `n + 1`. This one is
silent — both sides return a plausible polynomial — and the harness caught it on
the very first corpus entry.

**Assumptions do not cross languages.** A Wolfram symbol carries no assumptions,
so `Symbol("x")` and `Symbol("x", real=True)` cannot be distinguished by the
cross-oracle check and the harness strips the metadata before comparing Mathics
against SymPy. Within the Python path the assumptions are meaningful and are
compared. Put real domain restrictions in the derivation, not only in the symbol
declaration, if the `.wl` side needs them too.

## Recording what does not translate

If a construct has no SymPy equivalent, do not approximate it. Leave the result
out, and note it at the top of the `.py` file:

```python
# NOT TRANSLATED: FourierCoefficient — no SymPy equivalent for the periodic
# projection used in the original. Tracked in lazy-fortran/fortsym#NN.
```

A missing result is visible. A silently different one is not.

## Generated companions

Run `python tools/translate_wl_corpus.py` from the repository root. It extracts
plain `Set`/`SetDelayed` assignments, evaluates them in order with SymPy, and
writes one companion beside every `.wl` file that does not already have one.
Use `--refresh-generated` after changing the translator to rewrite generated
companions while preserving hand translations. The runtime covers common
calculus, algebra, replacement, table, list, and matrix operations, including
bounded `First`, `Last`, `Rest`, `Most`, `Reverse`, `Take`, and `Drop` selectors
and rectangular-matrix `Diagonal` extraction, bounded exact
`CharacteristicPolynomial` for explicit square matrices, plus a Wolfram
non-negative `MatrixPower`, `Coefficient`/`CoefficientList`, single-variable
`Solve` rule-list normalization, bounded `FoldList[Plus, init, list]`,
rectangular `ArrayFlatten`, quoted string literals mapped to the native
comparison atom, and a
Wolfram matrix-product dot continued across a line break. Unicode `λ` is protected
during SymPy parsing and restored as the original symbol. Unsupported selector and matrix shapes remain
opaque. It intentionally
refuses or skips side effects, plotting,
opaque control flow, and Wolfram constructs whose semantics cannot be inferred
from an isolated assignment. Those source statements remain counted in the
manifest. When a fixture is important enough to deserve a complete oracle,
hand-expand it—as with the Association example—and record that choice in the
generator's manual-translation list.
