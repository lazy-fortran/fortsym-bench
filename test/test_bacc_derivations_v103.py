"""Independent regression for the uniform low-density plasma loss."""

import importlib.util
import math
from pathlib import Path


def _results():
    path = (
        Path(__file__).parents[1]
        / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    )
    spec = importlib.util.spec_from_file_location(
        "bacc_derivations_v103", path
    )
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_uniform_loss_matches_independent_energy_integral():
    values = _results()
    omega, mu0, conductivity = 2.7, 4.0e-7 * math.pi, 3.2e5
    turns, length, radius = 11.0, 0.19, 0.027

    # B/I = mu0*N/lc and E_phi/I = r*omega*(B/I)/2.  Integrating
    # P = sigma/2 * integral(E_phi^2 dV) over the cylinder, then using
    # R = 2*P/I^2, gives the independent reference below.
    field_per_current = mu0 * turns / length
    radial_integral = radius**4 / 4.0
    expected = (
        2.0
        * 0.5
        * conductivity
        * (omega * field_per_current / 2.0) ** 2
        * 2.0
        * math.pi
        * length
        * radial_integral
    )

    actual = float(
        values["rplUniform"].subs(
            {
                "Omega": omega,
                "Mu0": mu0,
                "Sigma": conductivity,
                "nn": turns,
                "a": radius,
                "lc": length,
            }
        )
    )
    assert math.isclose(actual, expected, rel_tol=1e-13, abs_tol=0.0)
