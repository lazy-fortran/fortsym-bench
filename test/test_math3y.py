import importlib.util

import sympy as sp


def _module():
    path = 'corpus/archive-old/math3y.py'
    spec = importlib.util.spec_from_file_location('math3y_generated', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_math3y_p3_is_the_late_source_binding():
    x = sp.Symbol('x')
    p3 = _module().results()['p3']

    assert sp.expand(p3 - (x**3 + x + 1)) == 0
    assert p3.subs(x, 0) == 1
    assert p3.subs(x, -1) == -1
