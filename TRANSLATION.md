# Translating a .wl derivation to SymPy

Each corpus entry is a pair: the original `.wl` and a hand translation to
SymPy. Both must expose the **same result names**, because that is what makes
the four-way comparison possible.

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
5. **Do not import anything but `sympy`.** The harness substitutes that module
   and nothing else. A corpus file that imports `numpy` or `fortsym` directly
   cannot run 1:1 under all backends.
6. **Numeric checks stay numeric.** `N[expr, 30]` becomes `expr.evalf(30)`;
   keep the tolerance the original used.

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
