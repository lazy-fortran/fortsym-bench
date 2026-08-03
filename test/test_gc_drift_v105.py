"""Independent regression for the v105 gc_drift remainder binding."""

import importlib.util
from pathlib import Path

import sympy as sp


def _module():
    path = Path(__file__).parents[1] / "corpus/proj-cpp-derivation/gc_drift.py"
    spec = importlib.util.spec_from_file_location("gc_drift_v105", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def test_remainder_preserves_the_native_diagonal_broadcast_shape():
    values = _module().results()
    remainder = values["remainder"]

    assert remainder.func.__name__ == "List"
    assert len(remainder.args) == 3
    for row in remainder.args:
        assert row.func.__name__ == "List"
        assert len(row.args) == 3

    # The native bounded Table fallback places a 3x3 List payload only on
    # the diagonal; off-diagonal entries remain the scalar source expression.
    for i, row in enumerate(remainder.args):
        for j, entry in enumerate(row.args):
            if i == j:
                assert entry.func.__name__ == "List"
                assert len(entry.args) == 3
                assert all(
                    item.func.__name__ == "List"
                    and len(item.args) == 3
                    and all(cell.func.__name__ == "Add" for cell in item.args)
                    for item in entry.args
                )
            else:
                assert entry.func.__name__ == "Add"

    r, th = sp.symbols("r th")
    R0, Bctr, vpar, vGC, vGradB = sp.symbols(
        "R0 Bctr vpar vGC vGradB"
    )
    streaming = Bctr * vpar / sp.sqrt(
        sp.Function("List")(
            sp.Function("List")(Bctr**2, 0, 0),
            sp.Function("List")(0, Bctr**2 * r**2, 0),
            sp.Function("List")(
                0, 0, Bctr**2 * (R0 + r * sp.cos(th)) ** 2
            ),
        )
    )
    expected = vGC - (vGradB + streaming)
    assert remainder.args[0].args[1] == expected
    assert remainder.args[1].args[0] == expected
    assert remainder.args[2].args[1] == expected
    assert remainder.args[0].args[0].args[0].args[0] == expected
    for index in range(3):
        payload = remainder.args[index].args[index]
        assert all(
            cell == expected
            for row in payload.args
            for cell in row.args
        )
