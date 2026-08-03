"""Independent source-derived checks for the archive-old parity cluster."""

import importlib.util
from pathlib import Path

import sympy as sp


ROOT = Path(__file__).parents[1]


def _module(name):
    path = ROOT / f'corpus/archive-old/{name}.py'
    spec = importlib.util.spec_from_file_location(f'archive_old_{name}_v108', path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def test_math3y_inverse_binding_is_the_inverse_of_the_source_matrix():
    values = _module('math3y').results()
    x = sp.Symbol('x')
    source_matrix = sp.Matrix([
        [12, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [12, 10, -2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
        [0, -4, 8, -1, 0, 0, 0, -3, 1, 1, 0, 0, 0, 0],
        [0, 2, 0, 12, 1, 0, 0, 0, -1, -1, 0, 0, 0, 0],
        [12, 0, 0, 2, 8, -1, -1, 0, -1, -1, 0, 0, 0, 0],
        [0, -2, 1, 0, -2, 6, 1, 0, 0, 2, -1, 0, 0, 0],
        [0, -2, 1, 0, -2, 1, 6, 0, 2, 0, -1, 0, 0, 0],
        [0, 0, -2, 0, 1, 0, 0, 6, 0, 0, 0, 0, 0, 0],
        [0, -1, 1, -2, -1, 0, 1, 0, 8, 0, 0, 0, 2, -2],
        [0, -1, 1, -2, -1, 1, 0, 0, 0, 8, 0, 0, 2, -2],
        [0, 2, 0, 2, 0, -1, -1, 0, 0, 0, 6, -2, -4, 0],
        [0, 0, 0, 0, -2, 0, 0, 0, 0, 0, -2, 4, 0, -2],
        [-6, 0, 0, 0, 0, 0, 0, 0, 1, 1, -1, 0, 8, 0],
        [0, 2, 0, 0, 0, 0, 0, 0, -1, -1, 0, 0, 0, 8],
    ])
    inverse = values['im'].args[0]
    inverse = sp.Matrix([list(row) for row in inverse])

    assert source_matrix * inverse == sp.eye(14)
    assert inverse * source_matrix == sp.eye(14)
    assert x not in inverse.free_symbols


def test_math3y_findroot_binding_uses_the_three_source_initial_guesses():
    roots = [rule.args[1] for group in _module('math3y').results()['so'] for rule in group]
    polynomial = sp.Poly(sp.Symbol('x')**3 + sp.Symbol('x') + 1)

    assert len(roots) == 3
    assert all(abs(complex(root**3 + root + 1)) < 1e-40 for root in roots)
    assert abs(complex(roots[0])) < 1
    assert sp.im(roots[1]) > 0
    assert sp.im(roots[2]) < 0
    assert polynomial.degree() == 3


def test_math3y_ndsolve_binding_preserves_the_final_source_call():
    sol = _module('math3y').results()['sol']

    assert sol.func == sp.Function('Flatten')
    assert sol.args[0].func == sp.Function('NDSolve')
    assert sol.args[0].args[2] == sp.Tuple(sp.Symbol('t'), 0, 4)


def test_math5y_structural_bindings_follow_one_based_source_paths():
    values = _module('math5y').results()

    assert values['pos4'] == sp.Tuple(sp.Tuple(3, 3), sp.Tuple(4, 2))
    assert values['polog'] == sp.Tuple(
        sp.Tuple(3, 2, 0), sp.Tuple(4, 2, 0)
    )
    assert values['powerPositions'] == sp.Tuple(
        sp.Tuple(1, 2), sp.Tuple(2, 1), sp.Tuple(2, 2), sp.Tuple(3)
    )


def test_math5y_union_bindings_use_wolfram_canonical_order():
    values = _module('math5y').results()
    a, b, c, d, e, r = sp.symbols('a b c d e r')

    assert values['l4'] == sp.Tuple(a, b, c, d, e)
    assert values['la'] == sp.Tuple(2, a, b, c, d, r)
