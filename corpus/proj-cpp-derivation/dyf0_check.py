"""Generated SymPy translation of ``corpus/proj-cpp-derivation/dyf0_check.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 8 non-assignment statement(s) remain.
_ASSIGNMENTS = [
    ('m', '1', ()),
    ('qc', '1', ()),
    ('mu', '1/10', ()),
    ('gT', 'DiagonalMatrix[{1, r^2, (R0+r Cos[th])^2}]/.R0->3', ('r', 'th')),
    ('AthF', 'B0 (r^2/2 - r^3 Cos[th]/(3 R0))/.{B0->1,R0->3}', ('r', 'th')),
    ('AphF', '-B0 iota0 (r^2/2 - r^4/(4 r0a^2))/.{B0->1,iota0->1,r0a->1}', ('r', 'th')),
    ('Acov', '{0,AthF[r,th],AphF[r,th]}', ('r', 'th')),
    ('qv', '{r,th,ph}', ()),
    ('sqrtg', 'Sqrt[Det[gT[r,th]]]', ('r', 'th')),
    ('Bctr', 'Module[{Aa=Acov[rr,tt]},\n  Table[(1/sqrtg[rr,tt]) Sum[LeviCivitaTensor[3][[i,j,k]] D[Aa[[k]],{rr,tt,ph}[[j]]],{j,3},{k,3}],{i,3}]/.{rr->r,tt->th}]', ('r', 'th')),
    ('Bmod', 'Sqrt[Bctr[r,th].gT[r,th].Bctr[r,th]]', ('r', 'th')),
    ('force', 'Module[{u,gi,dg,dA,dB,fk},\n  gi=Inverse[gT[rr,tt]];\n  u=(1/m) gi.(p-qc Acov[rr,tt]);\n  dg=Table[D[gT[rr,tt][[i,j]],{rr,tt,ph}[[k]]],{i,3},{j,3},{k,3}];\n  dA=Table[D[Acov[rr,tt][[i]],{rr,tt,ph}[[k]]],{i,3},{k,3}];\n  dB=Table[D[Bmod[rr,tt],{rr,tt,ph}[[k]]],{k,3}];\n  fk=Table[(m/2) Sum[dg[[i,j,k]] u[[i]] u[[j]],{i,3},{j,3}] + qc Sum[dA[[j,k]] u[[j]],{j,3}] - mu dB[[k]],{k,3}];\n  fk/.{rr->r0,tt->th0}]', ('p', 'r0', 'th0', 'ph0')),
    ('r0', '0.5', ()),
    ('th0', '0.7', ()),
    ('vpar', '0.3', ()),
    ('hcov', 'gT[r0,th0].Bctr[r0,th0]/Bmod[r0,th0]', ()),
    ('p0', 'm vpar hcov + qc Acov[r0,th0]', ()),
    ('ps', '{px,py,pz}', ()),
    ('J', 'Table[D[force[ps,r0,th0,0][[a]],ps[[b]]],{a,3},{b,3}]/.Thread[ps->p0]//N', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-cpp-derivation/dyf0_check.wl')
