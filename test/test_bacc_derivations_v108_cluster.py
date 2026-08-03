"""Independent checks for the recovered Bacc derivations cluster."""

import importlib.util
import math
from pathlib import Path


def _results():
    path = (
        Path(__file__).parents[1]
        / "corpus/nc-stud-Bacc_Rosa_Posch/derivations.py"
    )
    spec = importlib.util.spec_from_file_location("bacc_derivations_v108", path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module.results()


def test_low_density_series_matches_independent_bessel_expansion():
    values = _results()
    omega, mu0, sigma = 2.7, 4.0e-7 * math.pi, 3.2e5
    turns, radius, length = 11.0, 0.027, 0.19

    # 2 J1(x)/(x J0(x)) - 1 = x^2/8 + O(x^4), while
    # x^2 = -i*omega*mu0*sigma*a^2. Substitution into Z_pl gives this real
    # first-order coefficient independently of the translated expression.
    expected = math.pi * omega**2 * mu0**2 * sigma * turns**2 * radius**4 / (
        8.0 * length
    )
    actual = float(
        values["zPlSeries"].subs(
            {
                "Omega": omega,
                "Mu0": mu0,
                "Sigma": sigma,
                "nn": turns,
                "a": radius,
                "lc": length,
            }
        )
    )
    assert math.isclose(actual, expected, rel_tol=1e-13)


def test_global_balance_and_paschen_minimum_are_independent_closed_forms():
    values = _results()
    aa, bb, rcoil, power = 0.8, 3.5, 1.7, 11.0
    density = float(
        values["neSol"].subs(
            {"aa": aa, "bb": bb, "Rcoil": rcoil, "PL": power}
        )
    )
    eta = aa * density / (rcoil + aa * density)
    assert math.isclose(eta * power, bb * density, rel_tol=1e-13)

    current = float(values["iOp"].subs({"aa": aa, "bb": bb}))
    assert math.isclose(current**2, 2.0 * bb / aa, rel_tol=1e-13)

    ap, bp, gamma = 12.0, 180.0, 0.05
    pd = math.e / ap * math.log1p(1.0 / gamma)
    expected_voltage = math.e * bp / ap * math.log1p(1.0 / gamma)
    actual_pd = float(
        values["pdMin"].subs(
            {"AP": ap, "BP": bp, "Gammase": gamma}
        )
    )
    actual_voltage = float(
        values["vbMin"].subs(
            {"AP": ap, "BP": bp, "Gammase": gamma}
        )
    )
    assert math.isclose(actual_pd, pd, rel_tol=1e-13)
    assert math.isclose(actual_voltage, expected_voltage, rel_tol=1e-13)
