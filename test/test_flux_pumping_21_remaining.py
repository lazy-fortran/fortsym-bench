"""Independent behavioral check for the local-response convergence contract."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = (
        Path(__file__).parents[1]
        / 'corpus/proj-flux_pumping/21_local_response_convergence.py'
    )
    spec = importlib.util.spec_from_file_location(
        'local_response_convergence_remaining', path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_refinement_difference_ratio_matches_independent_power_law_oracle():
    values = _module().results()
    h = sp.Rational(3, 10)
    order = 3
    coefficient = sp.Rational(7, 5)
    baseline = sp.Rational(11, 10)

    def response(step):
        return baseline + coefficient * step**order

    coarse = response(h / 2) - response(h)
    fine = response(h / 4) - response(h / 2)

    assert sp.simplify(
        values['fineDifference'].subs({'h': h, 'p': order, 'cq': coefficient})
        / values['coarseDifference'].subs(
            {'h': h, 'p': order, 'cq': coefficient}
        )
        - fine / coarse
    ) == 0
