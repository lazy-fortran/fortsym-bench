"""Independent behavioral regression for the v99 math13y admittance."""

import cmath
import importlib.util
import math
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math13y.py'
    spec = importlib.util.spec_from_file_location('math13y_v99', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_y_is_the_complex_expanded_source_admittance():
    value = _module().results()['Y']
    cc, omega, inductance, resistance = sp.symbols('CC ω L R')
    expected = sp.I * cc * omega + (sp.I * inductance * omega + resistance) ** -1

    assert value == expected

    sample = {
        cc: 0.25,
        omega: 1.5,
        inductance: 2.0,
        resistance: 3.0,
    }
    observed = complex(value.subs(sample).evalf())
    independent = 1j * 0.25 * 1.5 + 1 / (3.0 + 1j * 2.0 * 1.5)
    assert math.isclose(observed.real, independent.real, rel_tol=1e-14)
    assert math.isclose(observed.imag, independent.imag, rel_tol=1e-14)
    assert cmath.isfinite(observed)
