"""Generated SymPy translation of ``corpus/proj-cpp-derivation/gc_lie_transform.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 56 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'Module[{c = TrueQ[Simplify[cond]]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'cond')),
    ('checkZero', 'Module[\n  {c = TrueQ[And @@ (PossibleZeroQ /@ Flatten[{Simplify[expr]}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr')),
    ('checkZeroA', 'Module[\n  {c = TrueQ[And @@ (PossibleZeroQ /@\n       Flatten[{Simplify[expr, Assumptions -> asm]}])]},\n  If[c, pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]; c]', ('name', 'expr', 'asm')),
    ('x', '{xx, yy, zz}', ()),
    ('cross', '{a[[2]] b[[3]] - a[[3]] b[[2]],\n                  a[[3]] b[[1]] - a[[1]] b[[3]],\n                  a[[1]] b[[2]] - a[[2]] b[[1]]}', ('a', 'b')),
    ('grad', 'Table[D[f, x[[k]]], {k, 3}]', ('f',)),
    ('curl', '{D[V[[3]], x[[2]]] - D[V[[2]], x[[3]]],\n             D[V[[1]], x[[3]]] - D[V[[3]], x[[1]]],\n             D[V[[2]], x[[1]]] - D[V[[1]], x[[2]]]}', ('V',)),
    ('divg', 'D[V[[1]], x[[1]]] + D[V[[2]], x[[2]]] + D[V[[3]], x[[3]]]', ('V',)),
    ('bsym', '{Sin[chi[xx, yy, zz]] Cos[psi[xx, yy, zz]],\n        Sin[chi[xx, yy, zz]] Sin[psi[xx, yy, zz]],\n        Cos[chi[xx, yy, zz]]}', ()),
    ('e1', '{Cos[chi[xx, yy, zz]] Cos[psi[xx, yy, zz]],\n      Cos[chi[xx, yy, zz]] Sin[psi[xx, yy, zz]],\n      -Sin[chi[xx, yy, zz]]}', ()),
    ('e2', '{-Sin[psi[xx, yy, zz]], Cos[psi[xx, yy, zz]], 0}', ()),
    ('cdir', 'Cos[th] e1 - Sin[th] e2', ('th',)),
    ('avg', 'Integrate[f, {theta, 0, 2 Pi}]/(2 Pi)', ('f',)),
    ('Avec', '{ax[xx, yy, zz], ay[xx, yy, zz], az[xx, yy, zz]}', ()),
    ('Bfield', 'curl[Avec]', ()),
    ('Astar', 'Avec + vpar bsym', ()),
    ('Bstar', 'curl[Astar]', ()),
    ('Bparstar', 'bsym . Bstar', ()),
    ('Htil', 'c1 Cos[theta] + s1 Sin[theta] + c2 Cos[2 theta] + s2 Sin[2 theta]', ()),
    ('Hmean', 'h0', ()),
    ('Hfull', 'Hmean + Htil', ()),
    ('w1raw', 'Integrate[Htil, theta]', ()),
    ('w1', '(1/OmegaG) (w1raw - avg[w1raw])', ()),
    ('Bmag', 'bmod[xx, yy, zz]', ()),
    ('vperp2', '2 mu Bmag/mGC', ()),
    ('H0', 'Simplify[(1/2) mGC (vpar^2 + vperp2)]', ()),
    ('H0expected', '(1/2) mGC vpar^2 + mu Bmag', ()),
    ('H1', 'Module[{bh = bfld/Sqrt[bfld . bfld]},\n  (3/4) (mm/qq) muv vp (bh . curl[bh])]', ('bfld', 'vp', 'muv', 'mm', 'qq')),
    ('Bhel', '{-Sin[kz zz], Cos[kz zz], bz0}', ()),
    ('twist', 'Simplify[(Bhel/Sqrt[Bhel . Bhel]) . curl[Bhel/Sqrt[Bhel . Bhel]],\n  Assumptions -> bz0 \\[Element] Reals && kz \\[Element] Reals]', ()),
    ('H1hel', 'Simplify[H1[Bhel, vpar, mu, mGC, qGC],\n  Assumptions -> bz0 \\[Element] Reals && kz \\[Element] Reals]', ()),
    ('H1straight', 'H1[{0, 0, B0c}, vpar, mu, mGC, qGC]', ()),
    ('Hgc', 'H0expected + eps (3/4)(mGC/qGC) mu vpar twistsym', ()),
    ('bU', 'bsym', ()),
    ('kappaU', 'Table[Sum[bU[[j]] D[bU[[i]], x[[j]]], {j, 3}], {i, 3}]', ()),
    ('curlbPerp', 'curl[bU] - bU (bU . curl[bU])', ()),
    ('magOf', 'Sqrt[B . B]', ('B',)),
    ('unitOf', 'B/magOf[B]', ('B',)),
    ('gradMagOf', 'Module[{bm = magOf[B]}, Table[D[bm, x[[k]]], {k, 3}]]', ('B',)),
    ('Bslab', '{0, 0, B0 (1 + alpha yy)}', ()),
    ('slabAsm', 'B0 > 0 && 1 + alpha yy > 0', ()),
    ('xdotPerpSlab', 'Simplify[\n  (1/magOf[Bslab]) cross[unitOf[Bslab], mu gradMagOf[Bslab]],\n  Assumptions -> slabAsm]', ()),
    ('xdotPerpSlabRef', '-(mu alpha)/(1 + alpha yy) {1, 0, 0}', ()),
    ('RR', 'Sqrt[xx^2 + yy^2]', ()),
    ('Btor', 'B0 R0 {-yy, xx, 0}/RR^2', ()),
    ('torAsm', 'B0 > 0 && R0 > 0 && xx^2 + yy^2 > 0', ()),
    ('kappaTor', 'Table[Sum[unitOf[Btor][[j]] D[unitOf[Btor][[i]], x[[j]]], {j, 3}],\n  {i, 3}]', ()),
    ('xdotCurvTor', 'Simplify[\n  (vpar^2/magOf[Btor]) cross[unitOf[Btor], kappaTor], Assumptions -> torAsm]', ()),
    ('xdotCurvMid', 'Simplify[xdotCurvTor /. {yy -> 0, xx -> R},\n  Assumptions -> B0 > 0 && R0 > 0 && R > 0]', ()),
    ('xdotCurvMidRef', 'vpar^2/(B0 R0/R) {0, 0, 1/R}', ()),
    ('HgcSlow', '(1/2) mGC vpar^2 + mu Bmag', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/gc_lie_transform.wl')
