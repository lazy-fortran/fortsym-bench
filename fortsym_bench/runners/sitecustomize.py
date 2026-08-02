"""Mathics compatibility shim loaded only in its UV subprocess.

Mathics 10.0.1 restores ``$Assumptions`` by passing its internal list of
rules back through ``set_ownvalue``.  That list is already the definition
state, not a Wolfram value; treating it as a value raises ``has_form``.  The
shim restores the rule list directly, preserving the state Mathics meant to
restore while leaving all ordinary assignments untouched.
"""

from mathics.core.definitions import Definitions
from mathics.core.list import ListExpression
from mathics.core.symbols import BooleanType
from mathics.builtin.numbers.calculus import Derivative
import sympy


# Mathics 10.0.1 declares ``Curl`` as a SympyFunction but SymPy 1.14 no
# longer exports the old top-level ``sympy.curl`` name.  A Curl expression
# that does not match Mathics's own arity rules should remain unevaluated;
# without this fallback the conversion path raises AttributeError and aborts
# the complete corpus script.  Valid two- and three-argument Curl calls are
# handled by Mathics's rules before this conversion hook is reached.
if not hasattr(sympy, "curl"):
    def _unevaluated_curl(*args):
        return sympy.Function("Curl")(*args)

    sympy.curl = _unevaluated_curl


_set_ownvalue = Definitions.set_ownvalue


def _safe_set_ownvalue(self, name, value):
    if (
        name in ("System`$Assumptions", "$Assumptions")
        and isinstance(value, list)
        and all(hasattr(item, "pattern") for item in value)
    ):
        definition = self.get_definition(self.lookup_name(name))
        definition.ownvalues = value
        self.clear_cache(name)
        return
    return _set_ownvalue(self, name, value)


Definitions.set_ownvalue = _safe_set_ownvalue


def _boolean_assumptions(self, head, **kwargs):
    """Make Simplify[expr, True/False] compatible with list flattening."""
    return ListExpression(self)


BooleanType.flatten_with_respect_to_head = _boolean_assumptions


_derivative_to_sympy = Derivative.to_sympy


def _safe_derivative_to_sympy(self, expr, **kwargs):
    """Leave derivatives of non-symbolic heads unevaluated for SymPy."""
    inner = expr
    exprs = [inner]
    try:
        while True:
            inner = inner.head
            exprs.append(inner)
    except AttributeError:
        pass
    if len(exprs) != 4 or not all(
        hasattr(item, "elements") and len(item.elements) >= 1
        for item in exprs[:3]
    ):
        return None
    if not hasattr(exprs[1].elements[0], "name"):
        return None
    return _derivative_to_sympy(self, expr, **kwargs)


Derivative.to_sympy = _safe_derivative_to_sympy
