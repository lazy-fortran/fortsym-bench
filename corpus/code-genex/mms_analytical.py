"""Generated SymPy translation of ``corpus/code-genex/mms_analytical.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 66 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('argv', 'Rest @ $ScriptCommandLine', ()),
    ('argc', 'Length @ argv', ()),
    ('equilibrium', 'argv[[argc]]', ()),
    ('ElapsedTime', '\\', ()),
    ('CWD', 'Directory[]', ()),
    ('t1', 'TimeUsed[]', ()),
    ('masses', '{1, 1}', ()),
    ('charges', '{1, -1}', ()),
    ('tempScalings', '{1, 1}', ()),
    ('T', '1', ()),
    ('coordinatesystem', 'If[equilibrium == "salpha" ||\n                      equilibrium == "dommaschk", "Cylindrical", "Cartesian"]', ()),
    ('rho', 'Switch[equilibrium, "slab", R, \\\n    "circular", CoordinateTransform["Cartesian" -> "Polar", {R, Z}][[1]], \\\n    "salpha", CoordinateTransform["Cartesian" -> "Polar", \\\n                                  {R - 1.0, Z}][[1]] / minorr, \\\n    "dommaschk", Sqrt[ ( (R - 0.999) * Cos[2.5 * phi] \\\n                       + (Z        ) * Sin[2.5 * phi])^2 / ellax1^2\\\n                     + ( (R - 0.999) * Sin[2.5 * phi] \\\n                       - (Z        ) * Cos[2.5 * phi])^2 / ellax2^2]]', ('R', 'phi', 'Z')),
    ('theta', 'Switch[equilibrium, "slab", Pi * Z, \\\n    "circular", CoordinateTransform["Cartesian"-> "Polar", {R, Z}][[2]], \\\n    "salpha", CoordinateTransform["Cartesian"-> "Polar", {R - 1.0, Z}][[2]], \\\n    "dommaschk", CoordinateTransform["Cartesian"-> "Polar", {R - 1.0, Z}][[2]]]', ('R', 'Z')),
    ('jacobian', 'Switch[equilibrium, "slab", 1, "circular", 1, "salpha", R, \\\n                                    "dommaschk", R]', ('R',)),
    ('qsalpha', 'q + shear * rho[R, 0.0, Z]^2', ('R', 'Z')),
    ('absBfunc', 'Switch[equilibrium, "slab", 1, \\\n    "circular", Sqrt[1 + rho[R, phi, Z]^2 / q^2], \\\n    "salpha", Sqrt[1 + ((R - 1)^2 + Z^2) / qsalpha[R, Z]^2] / R, \\\n    "dommaschk", absBDommaschk[R, phi, Z]]', ('R', 'phi', 'Z')),
    ('b', 'Switch[equilibrium, "slab", {0, 1, 0}, \\\n    "circular", {-Z / Sqrt[R^2 + Z^2 + q^2], q / Sqrt[R^2 + Z^2 + q^2], \\\n                 R / Sqrt[R^2 + Z^2 + q^2]}, \\\n    "salpha", {-Z / Sqrt[(R - 1)^2 + Z^2 + qsalpha[R, Z]^2], \\\n               qsalpha[R,Z] / Sqrt[(R - 1)^2 + Z^2 + qsalpha[R, Z]^2], \\\n               (R - 1) / Sqrt[(R - 1)^2 + Z^2 + qsalpha[R, Z]^2]}, \\\n    "dommaschk", BDommaschk[R, phi, Z] / absBfunc[R, phi, Z]]', ('R', 'phi', 'Z')),
    ('BstarES', 'Simplify[absBfunc[R, phi, Z] * b[R, phi, Z] \\\n             + Sqrt[2.0 * masses[[sigma]] * tempScalings[[sigma]]] \\\n               * vp / charges[[sigma]] * rhoref / Lref \\\n               * Curl[b[R, phi, Z], {R, phi, Z}, coordinatesystem]]', ('R', 'phi', 'Z', 'vp', 'sigma')),
    ('Bps', 'If[equilibrium == "dommaschk",\n    absBfunc[R, phi, Z], Simplify[b[R, phi, Z] . BstarES[R, phi, Z, vp, sigma]]]', ('R', 'phi', 'Z', 'vp', 'sigma')),
    ('dot', 'a . b', ('a', 'b')),
    ('maxwellian', '(Pi * T)^(-3 / 2) \\\n    * Exp[-1 / T * (vp^2 + mu * absBfunc[R, phi, Z])]', ('R', 'phi', 'Z', 'vp', 'mu')),
    ('f', '{0.95 * Sin[nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)]^2 \\\n        * Sin[npol * theta[R, Z]]^2 * Cos[ntor * phi]^2 * Cos[omega * t]^2 \\\n        * maxwellian[R, phi, Z, vp, mu]\n     + 0.05 * maxwellian[R, phi, Z, vp, mu], \\\n     0.95 * Sin[nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)]^2 \\\n        * Sin[npol * theta[R, Z]]^2 * Cos[ntor * phi]^2 * Cos[omega * t]^2 \\\n        * maxwellian[R, phi, Z, vp, mu]\n     + 0.05 * maxwellian[R, phi, Z, vp, mu]}', ('t', 'R', 'phi', 'Z', 'vp', 'mu')),
    ('pot', 'Sin[2 * nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)] \\\n        * Sin[2 * npol * theta[R, Z]] * Cos[ntor * phi]^2 * Cos[omega * t]^2', ('t', 'R', 'phi', 'Z')),
    ('Apar', 'Sin[2 * nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)] \\\n        * Sin[2 * npol * theta[R, Z]] * Cos[ntor * phi]^2 * Cos[omega * t]^2', ('t', 'R', 'phi', 'Z')),
    ('Bpar', '0.1 * Sin[2 * nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)] \\\n        * Sin[2 * npol * theta[R, Z]] * Cos[ntor * phi]^2 * Cos[omega * t]^2', ('t', 'R', 'phi', 'Z')),
    ('densi', '0.95 * Sin[nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)]^2 \\\n        * Sin[npol * theta[R, Z]]^2 * Cos[ntor * phi]^2 * Cos[omega * t]^2 \\\n    + 0.05', ('t', 'R', 'phi', 'Z')),
    ('dense', '0.95 * Sin[nrad * Pi * (rho[R, phi, Z] - rhomin) / (rhomax - rhomin)]^2 \\\n        * Sin[npol * theta[R, Z]]^2 * Cos[ntor * phi]^2 * Cos[omega * t]^2 \\\n    + 0.05', ('t', 'R', 'phi', 'Z')),
    ('chargedens', 'Simplify[charges[[1]] * densi[t, R, phi, Z] \\\n             + charges[[2]] * dense[t, R, phi, Z]]', ('t', 'R', 'phi', 'Z')),
    ('massdens', 'Simplify[masses[[1]] * densi[t, R, phi, Z] \\\n             + masses[[2]] * dense[t, R, phi, Z]]', ('t', 'R', 'phi', 'Z')),
    ('currentdens', 'Simplify[charges[[1]] * betaref \\\n               * Sqrt[tempScalings[[1]] / (2 * masses[[1]])] * Pi \\\n               * Integrate[vp * f[t, R, phi, Z, vp, mu][[1]] \\\n                            * Bps[R, phi, Z, vp, 1], \\\n                          {vp, -Infinity, Infinity}, {mu, 0, Infinity}] \\\n             + charges[[2]] * betaref \\\n               * Sqrt[tempScalings[[2]] / (2 * masses[[2]])] * Pi \\\n               * Integrate[vp * f[t, R, phi, Z, vp, mu][[2]] \\\n                            * Bps[R, phi, Z, vp, 2], \\\n                          {vp, -Infinity, Infinity}, {mu, 0, Infinity}]]', ('t', 'R', 'phi', 'Z')),
    ('perppressure', 'Simplify[-0.5 * betaref * (tempScalings[[1]] * Pi \\\n               * Integrate[mu * f[t, R, phi, Z, vp, mu][[1]] \\\n                            * Bps[R, phi, Z, vp, 1], \\\n                          {vp, -Infinity, Infinity}, {mu, 0, Infinity}] \\\n               + tempScalings[[2]] * Pi \\\n                 * Integrate[mu * f[t, R, phi, Z, vp, mu][[2]] \\\n                            * Bps[R, phi, Z, vp, 2], \\\n                          {vp, -Infinity, Infinity}, {mu, 0, Infinity}])]', ('t', 'R', 'phi', 'Z')),
    ('gradf', 'Grad[f[t, R, phi, Z, vp, mu][[sigma]], {R, phi, Z}, coordinatesystem]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('dfdvp', 'D[f[t, R, phi, Z, vp, mu][[sigma]], vp]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('dfdt', 'D[f[t, R, phi, Z, vp, mu][[sigma]], t]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('dApardt', 'D[Apar[t, R, phi, Z], t]', ('t', 'R', 'phi', 'Z')),
    ('gradApar', 'Grad[Apar[t, R, phi, Z], {R, phi, Z}, coordinatesystem]', ('t', 'R', 'phi', 'Z')),
    ('gradpot', 'Grad[pot[t, R, phi, Z], {R, phi, Z}, coordinatesystem]', ('t', 'R', 'phi', 'Z')),
    ('gradpot2', 'Grad[pot[t, R, phi, Z], {R, Z}, "Cartesian"] \\\n    . Grad[pot[t, R, phi, Z], {R, Z}, "Cartesian"]', ('t', 'R', 'phi', 'Z')),
    ('gradH2', '- (rhoref / Lref)^2 \\\n    * Grad[masses[[sigma]] / (2 * absBfunc[R, phi, Z]^2) \\\n            * gradpot2[t, R, phi, Z], {R, phi, Z}, coordinatesystem]', ('t', 'R', 'phi', 'Z', 'sigma')),
    ('gradBpar', 'Grad[Bpar[t, R, phi, Z], {R, phi, Z}, coordinatesystem]', ('t', 'R', 'phi', 'Z')),
    ('gradB', 'Grad[absBfunc[R, phi, Z], {R, phi, Z}, coordinatesystem]', ('R', 'phi', 'Z')),
    ('laplacepot', '-1 / jacobian[R] * Div[jacobian[R] * (rhoref / Lref)^2 \\\n        * massdens[t, R, phi, Z] / absBfunc[R, phi, Z]^2 \\\n        * Grad[pot[t, R, phi, Z], {R, Z}, "Cartesian"], {R, Z}, "Cartesian"]', ('t', 'R', 'phi', 'Z')),
    ('laplaceApar', '-1 / jacobian[R] * Div[jacobian[R] * (rhoref / Lref)^2 \\\n        * Grad[Apar[t, R, phi, Z], {R, Z}, "Cartesian"], {R, Z}, "Cartesian"]', ('t', 'R', 'phi', 'Z')),
    ('BstarEM', 'Simplify[BstarES[R, phi, Z, vp, sigma]\n              + rhoref / Lref * Cross[gradApar[t, R, phi, Z], b[R, phi, Z]]]', ('t', 'R', 'phi', 'Z', 'vp', 'sigma')),
    ('bstaradv', 'Sqrt[2 / masses[[sigma]]] * vp / Bps * \\', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('bcrossadv', 'rhoref / (Lref * charges[[sigma]] * Bps) \\\n        * dot[Cross[b[R, phi, Z], mu * gradB[R, phi, Z] \\\n                + charges[[sigma]] * gradpot[t, R, phi, Z]], \\\n              gradf[t, R, phi, Z, vp, mu, sigma]]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('bcrossadv2', 'rhoref / (Lref * charges[[sigma]] * Bps) \\\n        * dot[Cross[b[R, phi, Z], gradH2[t, R, phi, Z, sigma] \\\n                + tempScalings[[sigma]] * mu * gradBpar[t, R, phi, Z]], \\\n              gradf[t, R, phi, Z, vp, mu, sigma]]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('vpadv', '((-1.0 / (Sqrt[2.0 * masses[[sigma]]] * Bps) \\\n      * dot[BstarEM[t, R, phi, Z, vp, sigma], \\\n            mu * gradB[R, phi, Z] \\\n               + charges[[sigma]] * gradpot[t, R, phi, Z]] \\\n     ) - charges[[sigma]] / Sqrt[2.0 * masses[[sigma]]] \\\n           * dApardt[t, R, phi, Z] \\\n    ) * dfdvp[t, R, phi, Z, vp, mu, sigma]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('vpadv2', '(-1.0 / (Sqrt[2.0 * masses[[sigma]]] * Bps) \\\n      * dot[BstarEM[t, R, phi, Z, vp, sigma], \\\n            gradH2[t, R, phi, Z, sigma] \\\n               + tempScalings[[sigma]] * mu * gradBpar[t, R, phi, Z]] \\\n     ) * dfdvp[t, R, phi, Z, vp, mu, sigma]', ('t', 'R', 'phi', 'Z', 'vp', 'mu', 'sigma')),
    ('sourcepot', 'laplacepot[t, R, phi, Z] - chargedens[t, R, phi, Z]', ('t', 'R', 'phi', 'Z')),
    ('sourceApar', 'laplaceApar[t, R, phi, Z] - currentdens[t, R, phi, Z]', ('t', 'R', 'phi', 'Z')),
    ('sourceBpar', 'Bpar[t, R, phi, Z] - perppressure[t, R, phi, Z]', ('t', 'R', 'phi', 'Z')),
    ('sourceEpar', 'D[sourceApar[t, R, phi, Z], t]', ('t', 'R', 'phi', 'Z')),
    ('absBfunc', 'Switch[equilibrium, "slab", 1, \\\n                                 "circular", absB[R, 0, Z], \\\n                                 "salpha", absB[R, 0, Z], \\\n                                 "dommaschk", absB[R, phi, Z]]', ('R', 'phi', 'Z')),
    ('normb', 'b[R,phi,Z]', ()),
    ('b', 'Switch[equilibrium, \\\n    "slab",      {0,             1,               0}, \\\n    "circular",  {bR[R, 0, Z],   bphi[R, 0, Z],   bZ[R, 0, Z]}, \\\n    "salpha",    {bR[R, 0, Z],   bphi[R, 0, Z],   bZ[R, 0, Z]}, \\\n    "dommaschk", {bR[R, phi, Z], bphi[R, phi, Z], bZ[R, phi, Z]}]', ('R', 'phi', 'Z')),
    ('TotalTime', 'TextString[TimeObject[{0, 0, TimeUsed[] - t1}],\n                       TimeFormat->{"Hour","h ","Minute","m ","Second","s"}]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/code-genex/mms_analytical.wl')
