"""Generated SymPy translation of ``corpus/proj-gvec-stability/phase_transform.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 46 non-assignment statement(s) remain.
COMPARE = {
    'etaSidebands': 'equivalent',
    'xiSidebands': 'equivalent',
}
_ASSIGNMENTS = [
    ('$Assumptions', 'Element[{a, b, c, d, m1, m2, r, s, phi1, phi2,\n    kxx, kxy, kyy, mxx, mxy, myy, lambda, theta, zeta, baseM,\n    baseN, envelopeM, envelopeN, xe, xo, ye, yo, referenceLength,\n    radialIntervals, poloidalPoints, toroidalPoints}, Reals] &&', ()),
    ('pass', '0', ()),
    ('fail', '0', ()),
    ('check', 'If[TrueQ[FullSimplify[condition]],\n  pass++; Print["PASS  ", name], fail++; Print["FAIL  ", name]]', ('name', 'condition')),
    ('stiffness', '{{a, c + I d}, {c - I d, b}}', ()),
    ('mass', '{{m1, r + I s}, {r - I s, m2}}', ()),
    ('phase', 'DiagonalMatrix[{Exp[I phi1], Exp[I phi2]}]', ()),
    ('stiffnessPrime', 'ConjugateTranspose[phase].stiffness.phase', ()),
    ('massPrime', 'ConjugateTranspose[phase].mass.phase', ()),
    ('base', 'baseM theta + baseN zeta', ()),
    ('envelope', 'envelopeM theta + envelopeN zeta', ()),
    ('xiEnvelope', 'xe Cos[envelope] Cos[base] +\n  xo Sin[envelope] Sin[base]', ()),
    ('xiSidebands', '1/2 (xe - xo) Cos[base + envelope] +\n  1/2 (xe + xo) Cos[base - envelope]', ()),
    ('etaEnvelope', 'ye Cos[envelope] Sin[base] +\n  yo Sin[envelope] Cos[base]', ()),
    ('etaSidebands', '1/2 (ye + yo) Sin[base + envelope] +\n  1/2 (ye - yo) Sin[base - envelope]', ()),
    ('normalMap', '1/2 {{1, -1}, {1, 1}}', ()),
    ('tangentialMap', '1/2 {{1, 1}, {1, -1}}', ()),
    ('coefficientMap', 'ArrayFlatten[{{normalMap, ConstantArray[0, {2, 2}]},\n    {ConstantArray[0, {2, 2}], tangentialMap}}]', ()),
    ('carrierAndPairMap', 'ArrayFlatten[{{{{1}}, ConstantArray[0, {1, 2}]},\n    {ConstantArray[0, {2, 1}], normalMap}}]', ()),
    ('printedEnvelopeMass', '1/2 IdentityMatrix[3]', ()),
    ('carrierAndPairInverse', 'Inverse[carrierAndPairMap]', ()),
    ('inducedPhysicalMass', 'Transpose[carrierAndPairInverse].\n  printedEnvelopeMass.carrierAndPairInverse', ()),
    ('carrierPairK', '{{3, 1, -2}, {1, 5, 1}, {-2, 1, 7}}', ()),
    ('carrierPairEnvelopeK', 'Transpose[carrierAndPairMap].carrierPairK.\n  carrierAndPairMap', ()),
    ('coefficientScale', 'referenceLength^3/(radialIntervals poloidalPoints\n     toroidalPoints)', ()),
    ('zero2', 'ConstantArray[0, {2, 2}]', ()),
    ('twoLabelNormalMap', 'ArrayFlatten[{{normalMap, zero2},\n    {zero2, normalMap}}]', ()),
    ('integerSidebands', '{\n  canonicalMode[{3, 2 + 5 envelopeNValue}],\n  canonicalMode[{3, 2 - 5 envelopeNValue}]}', ('envelopeNValue',)),
    ('minusSidebands', 'integerSidebands[-1]', ()),
    ('plusSidebands', 'integerSidebands[1]', ()),
    ('uniquePhysicalProjection', '{{1, 0, 0, 1}, {0, 1, 1, 0}}', ()),
    ('physicalCoefficientMap', 'uniquePhysicalProjection.twoLabelNormalMap', ()),
    ('uniqueKFixture', '{{-3, 1}, {1, 2}}', ()),
    ('uniqueMFixture', '{{2, 0}, {0, 3}}', ()),
    ('collidingKFixture', 'Transpose[physicalCoefficientMap].uniqueKFixture.\n  physicalCoefficientMap', ()),
    ('collidingMFixture', 'Transpose[physicalCoefficientMap].uniqueMFixture.\n  physicalCoefficientMap', ()),
    ('quotientLift', 'Transpose[physicalCoefficientMap].\n  Inverse[physicalCoefficientMap.Transpose[physicalCoefficientMap]]', ()),
    ('quotientKFixture', 'Transpose[quotientLift].collidingKFixture.quotientLift', ()),
    ('quotientMFixture', 'Transpose[quotientLift].collidingMFixture.quotientLift', ()),
    ('sidebandK', '{{a, c, 0, d}, {c, b, -d, 0},\n  {0, -d, a + b, r}, {d, 0, r, a + 2 b}}', ()),
    ('sidebandM', 'IdentityMatrix[4]', ()),
    ('envelopeK', 'Transpose[coefficientMap].sidebandK.coefficientMap', ()),
    ('envelopeM', 'Transpose[coefficientMap].sidebandM.coefficientMap', ()),
    ('fullK', '{{kxx, kxy}, {kxy, kyy}}', ()),
    ('fullM', '{{mxx, mxy}, {mxy, myy}}', ()),
    ('zeroSchur', 'kxx - kxy^2/kyy', ()),
    ('shiftedSchur', 'kxx - lambda mxx -\n  (kxy - lambda mxy)^2/(kyy - lambda myy)', ()),
    ('zeroCondensedPencil', 'zeroSchur - lambda mxx', ()),
    ('fixtureK', '{{2, 3}, {3, 2}}', ()),
    ('fixtureM', 'IdentityMatrix[2]', ()),
    ('fixtureFullSpectrum', 'Eigenvalues[{fixtureK, fixtureM}]', ()),
    ('fixtureCondensed', 'fixtureK[[1, 1]] -\n  fixtureK[[1, 2]]^2/fixtureK[[2, 2]]', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/proj-gvec-stability/phase_transform.wl')
