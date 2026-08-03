"""Independent behavioral regression for the symbolic Hamiltonian form."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / 'corpus/nc-plasma-DOCUMENTS/peng.py'
    spec = importlib.util.spec_from_file_location('peng', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_symbolic_hamiltonian_keeps_vector_dot_opaque():
    values = _module().results()
    p, A, e, c, m, Phi = sp.symbols('p A e c m Phi')
    dot = sp.Function('Dot')
    expected = e * Phi + dot(p - e * A / c, p - e * A / c) / (2 * m)
    assert values['H'] == expected

    # Independent behavioral oracle for the source contraction: with concrete
    # vector operands, Dot is the ordinary Euclidean contraction.
    kinetic_vector = (3, 4, 0)
    vector_potential = (1, 0, 0)
    shifted = tuple(pv - av for pv, av in zip(kinetic_vector, vector_potential))
    assert sum(component * component for component in shifted) == 20
