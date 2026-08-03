"""Independent behavioral check for a recovered NTV notebook binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/gh-krystophny-andreas-ntv/build_notebooks.py'
    )
    spec = importlib.util.spec_from_file_location('build_notebooks_gh', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_a_coef_matches_the_independent_damped_response_formula():
    value = _module().results()['aCoef']
    j = sp.Symbol('j')
    derivative = sp.Function('Derivative1')(sp.Symbol('f0'), 1, j)
    sample = {
        sp.Symbol('m'): 2,
        sp.Function('h')(j): 3,
        derivative: 5,
        sp.Function('capitalOmega')(j): 7,
        sp.Symbol('omega'): 1,
        sp.Symbol('nu'): 4,
    }

    # Recompute the real response coefficient numerically, without using the
    # translated assignment or its intermediate ``delta`` binding.
    detuning = sample[sp.Symbol('m')] * sample[sp.Function('capitalOmega')(j)] - sample[sp.Symbol('omega')]
    expected = sp.Rational(
        sample[sp.Symbol('m')]
        * sample[sp.Function('h')(j)]
        * sample[derivative]
        * detuning,
        detuning**2 + sample[sp.Symbol('nu')]**2,
    )
    assert value.subs(sample) == expected
