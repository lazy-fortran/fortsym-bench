"""Generated SymPy translation of ``corpus/code-integrator-benchmark/tdrk_guiding_center_G.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments
import sympy as sp

# NOT TRANSLATED: 20 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('vars', '{r, th, ph, pph}', ()),
    ('H', 'HH[r, th, ph, pph]', ('r', 'th', 'ph', 'pph')),
    ('pth', 'PTH[r, th, ph, pph]', ('r', 'th', 'ph', 'pph')),
    ('vpar', 'VPAR[r, th, ph, pph]', ('r', 'th', 'ph', 'pph')),
    ('hth', 'HTH[r, th, ph]', ('r', 'th', 'ph')),
    ('hph', 'HPH[r, th, ph]', ('r', 'th', 'ph')),
    ('dH', 'D[H[r, th, ph, pph], vars[[i]]]', ('i',)),
    ('dpth', 'D[pth[r, th, ph, pph], vars[[i]]]', ('i',)),
    ('dvpar', 'D[vpar[r, th, ph, pph], vars[[i]]]', ('i',)),
    ('Hprime', 'dH[1]/dpth[1]', ()),
    ('F', '{\n   -(dH[2] - hth[r, th, ph]/hph[r, th, ph]*dH[3])/dpth[1],\n   Hprime,\n   (vpar[r, th, ph, pph] - Hprime*hth[r, th, ph])/hph[r, th, ph],\n   -(dH[3] - Hprime*dpth[3])\n   }', ()),
    ('J', 'Table[D[F[[i]], vars[[j]]], {i, 4}, {j, 4}]', ()),
    ('Goracle', 'J . F // Simplify', ()),
    ('d2Index', '{{1, 1} -> 1, {1, 2} -> 2, {1, 3} -> 3, {2, 2} -> 4,\n   {2, 3} -> 5, {3, 3} -> 6, {1, 4} -> 7, {2, 4} -> 8, {3, 4} -> 9,\n   {4, 4} -> 10}', ()),
    ('d2', 'D[q[r, th, ph, pph], vars[[i]], vars[[j]]]', ('q', 'i', 'j')),
    ('dHprime', '(d2[HH, 1, j]*dpth[1] - dH[1]*d2[PTH, 1, j])/dpth[1]^2', ('j',)),
    ('dF1', '-((d2[HH, 2, j] -\n       (D[hth[r, th, ph], vars[[j]]]/hph[r, th, ph]\n         - hth[r, th, ph]*D[hph[r, th, ph], vars[[j]]]/hph[r, th, ph]^2)*dH[3]\n       - hth[r, th, ph]/hph[r, th, ph]*d2[HH, 3, j])*dpth[1]\n     - (dH[2] - hth[r, th, ph]/hph[r, th, ph]*dH[3])*d2[PTH, 1, j])/dpth[1]^2', ('j',)),
    ('dF2', 'dHprime[j]', ('j',)),
    ('dF3', '((dvpar[j] - dHprime[j]*hth[r, th, ph]\n      - Hprime*D[hth[r, th, ph], vars[[j]]])*hph[r, th, ph]\n    - (vpar[r, th, ph, pph] - Hprime*hth[r, th, ph])*\n     D[hph[r, th, ph], vars[[j]]])/hph[r, th, ph]^2', ('j',)),
    ('dF4', '-(d2[HH, 3, j] - dHprime[j]*dpth[3] - Hprime*d2[PTH, 3, j])', ('j',)),
    ('Gclosed', 'Table[\n   Sum[{dF1[j], dF2[j], dF3[j], dF4[j]}[[i]]*F[[j]], {j, 4}], {i, 4}]', ()),
    ('residual', 'Simplify[Goracle - Gclosed]', ()),
    ('symbolicOK', '(residual === {0, 0, 0, 0}) || (Simplify[Total[Abs[residual]]] === 0)', ()),
    ('concrete', '{\n   HH -> Function[{r, th, ph, pph},\n     pph^2/(2 (1 + r^2)) + Cos[th] Sin[ph] + r^3 pph + Exp[-r] Cos[th + ph]],\n   PTH -> Function[{r, th, ph, pph},\n     pph (1 + r^2/3) + Sin[th] Cos[ph] + r pph^2/5],\n   VPAR -> Function[{r, th, ph, pph},\n     pph/(1 + r) + Sin[th + 2 ph] + r^2 pph/7],\n   HTH -> Function[{r, th, ph}, 1 + r^2/4 + Sin[th] Cos[ph]/3],\n   HPH -> Function[{r, th, ph}, 2 + r/5 + Cos[th + ph]/4]\n   }', ()),
    ('pt', '{r -> 37/100, th -> 61/100, ph -> 117/100, pph -> 43/100}', ()),
    ('gO', 'Goracle /. concrete /. pt // N', ()),
    ('gC', 'Gclosed /. concrete /. pt // N', ()),
    ('numericErr', 'Max[Abs[gO - gC]]', ()),
    ('derivOrder', 'Max[0, Cases[expr,\n    Derivative[a__][f][__] :> Total[{a}], {0, Infinity}]]', ('expr', 'f')),
    ('orders', '{\n   "H" -> derivOrder[Gclosed, HH],\n   "pth" -> derivOrder[Gclosed, PTH],\n   "vpar" -> derivOrder[Gclosed, VPAR],\n   "hth" -> derivOrder[Gclosed, HTH],\n   "hph" -> derivOrder[Gclosed, HPH]\n   }', ()),
    ('ordersOK', 'AllTrue[orders, #[[2]] <= 2 &]', ()),
]

def results():
    values = evaluate_assignments(
        _ASSIGNMENTS,
        'corpus/code-integrator-benchmark/tdrk_guiding_center_G.wl',
    )
    rule = sp.Function('Rule')
    values.update({
        'd2Index': sp.Tuple(
            *(rule(sp.Tuple(i, j), value) for (i, j), value in (
                ((1, 1), 1), ((1, 2), 2), ((1, 3), 3),
                ((2, 2), 4), ((2, 3), 5), ((3, 3), 6),
                ((1, 4), 7), ((2, 4), 8), ((3, 4), 9),
                ((4, 4), 10),
            ))
        ),
        'pt': sp.Tuple(
            rule(sp.Symbol('r'), sp.Rational(37, 100)),
            rule(sp.Symbol('th'), sp.Rational(61, 100)),
            rule(sp.Symbol('ph'), sp.Rational(117, 100)),
            rule(sp.Symbol('pph'), sp.Rational(43, 100)),
        ),
    })
    return values
