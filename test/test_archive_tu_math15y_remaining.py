"""Independent behavioral check for the recovered ``math15y`` random list."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/archive-tu/math15y.py'
    spec = importlib.util.spec_from_file_location('archive_tu_math15y', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_lst_requests_ten_uniform_samples_in_the_source_interval():
    values = _module().results()

    # The source statement is ``lst = RandomReal[{0, 1}, 10]``.  Randomness
    # makes a concrete sample unsuitable as an oracle, so verify the request
    # itself: its interval and number of samples are the observable behavior.
    expected = sp.Function('RandomReal')(sp.Tuple(0, 1), 10)

    assert values['lst'] == expected
    assert values['lst'].args[0] == sp.Tuple(0, 1)
    assert values['lst'].args[1] == 10
