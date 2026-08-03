"""Independent checks for the concrete separatrix samples and jump form."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / (
        'corpus/proj-cpp-derivation/separatrix_obstruction.py'
    )
    spec = importlib.util.spec_from_file_location('separatrix_obstruction', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_range_samples_are_concrete_and_cover_the_source_endpoints():
    values = _module().results()
    assert values['Egrid'] == sp.Tuple(*(
        -sp.Rational(1, 10**power) for power in range(1, 10)
    ))
    assert values['xiScan'][0] == sp.Rational(1, 100)
    assert values['xiScan'][-1] == sp.Rational(99, 100)
    assert len(values['xiScan']) == 99


def test_projection_error_preserves_the_source_absolute_value():
    values = _module().results()
    assert values['projError'].func == sp.Function('Abs')
    assert values['projError'].args[0] == values['trueJump']
