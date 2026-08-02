import importlib.util

import sympy as sp


def _module():
    path = 'corpus/archive-old/math6-1y.py'
    spec = importlib.util.spec_from_file_location('math6_1y', path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_late_r_binding_preserves_source_symbol():
    values = _module().results()

    # In the source, the late assignment is exactly ``r = t``.  Keeping the
    # symbol is observable and avoids silently replacing the source binding
    # with the earlier branch-valued assignment to t.
    assert values['r'] == sp.Symbol('t')
    assert values['r'].is_Symbol
