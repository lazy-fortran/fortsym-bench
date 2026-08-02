"""Mathics compatibility shim loaded only in its UV subprocess.

Mathics 10.0.1 restores ``$Assumptions`` by passing its internal list of
rules back through ``set_ownvalue``.  That list is already the definition
state, not a Wolfram value; treating it as a value raises ``has_form``.  The
shim restores the rule list directly, preserving the state Mathics meant to
restore while leaving all ordinary assignments untouched.
"""

from mathics.core.definitions import Definitions


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
