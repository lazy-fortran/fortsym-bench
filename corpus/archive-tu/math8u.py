"""Generated SymPy translation of ``corpus/archive-tu/math8u.wl``.

The assignment text is lowered by the shared deterministic translator.
Unsupported control-flow or side-effect statements are not guessed;
their count is recorded in translation-manifest.json.
"""

from fortsym_bench.wl_to_sympy import evaluate_assignments

# NOT TRANSLATED: 131 non-assignment statement(s) remain.
COMPARE = {
    'M': 'numeric',
}
_ASSIGNMENTS = [
    ('m', '{{1, 1, 1}, {1, 2, 3}, {1, 3, 6}, {1, 4, 6}}', ()),
    ('b', '{1, 4, 10, 19}', ()),
    ('u', '{u1, u2, u3}', ()),
    ('m', '{{1, 1, 1}, {1, 2, 3}, {1, 3, 6}, {1, 4, 10}}', ()),
    ('b', '{1, 4, 10, 19}', ()),
    ('m', '{{0, 1, -3, -1}, {1, 0, 1, 1}, {3, 1, 0, 2}, {1, 1, -2, 0}}', ()),
    ('b', '{0, 0, 0, 0}', ()),
    ('m', '{{1, 3, 2, 4}, {5, 2, 0, 1}, {3, -4, -4, -7}, {-7, 5, 6, 10}}', ()),
    ('b', '{0, 0, 0, 0}', ()),
    ('me', '{{1, 1, 1, 1}, {1, 2, 3, 4}, {1, 3, 6, 10}, {1, 4, 10, a}}', ()),
    ('M', '{{{10, -14, -10}, {-14, 7, -4}, {-10, -4, 19}}, {{5, 2, 2}, {2, 2, 1}, {2, 1, 1}}, {{-2, 0, -4}, {0, 2, 4}, {-4, 4, 0}}, {{1, 0, Sqrt[3]}, {0, 1, 1}, {Sqrt[3], 1, 1}}, {{1, -2, 1}, {-1, 2, -1}, {2, 1, 1}}, N[{{8, 2, 3, 4}, {2, 5, 4, 5}, {3, 4, 5, 6}, {5, 6, 7, 9}}]}', ()),
    ('charpoly', '(CharacteristicPolynomial[#1, z] & ) /@ M', ()),
    ('aneig', '(Solve[#1 == 0] & ) /@ charpoly', ()),
    ('eig', 'Eigenvalues /@ M', ()),
    ('eigvec', 'Eigenvectors /@ M', ()),
    ('M', '{{{-(1/2), Sqrt[3]/2}, {Sqrt[3]/2, 1/2}}, {{-(1/2), -(Sqrt[3]/2)}, {Sqrt[3]/2, -(1/2)}}, {{1/Sqrt[2], -(1/Sqrt[2])}, {1/Sqrt[2], 1/Sqrt[2]}}, {{0, 1, 0}, {0, 0, 1}, {-1, -1, -1}}, {{0, 1, 0}, {0, 0, 1}, {1, 0, 0}}}', ()),
    ('me', '(Eigenvalues[#1] & ) /@ M', ()),
    ('RootOfUnityProg', 'If[m == IdentityMatrix[Length[m]], i, If[i < n, RootOfUnityProg[m0 . m, m0, i + 1, n], 0]]', ('m', 'm0', 'i', 'n')),
    ('RootOfUnity', 'RootOfUnityProg[m, m, 1, n]', ('m', 'n')),
    ('ZeroMatrix', 'ConstantArray[0, {n, n}]', ('n',)),
    ('RootOfZeroProg', 'If[m == ZeroMatrix[Length[m]], i, If[i < n, RootOfZeroProg[m0 . m, m0, i + 1, n], 0]]', ('m', 'm0', 'i', 'n')),
    ('RootOfZero', 'RootOfZeroProg[m, m, 1, n]', ('m', 'n')),
    ('ProveCharEq', 'Complement[z /. Solve[Det[a - z*IdentityMatrix[Length[a]]] == 0, z], Eigenvalues[a]]', ('a',)),
    ('TestCharEq', '(Det[a - #1*IdentityMatrix[Length[a]]] & ) /@ Eigenvalues[a]', ('a',)),
    ('m', '{{2, 0, -1}, {3, 4, 2}, {0, -8, -7}}', ()),
    ('L', 'NullSpace[Transpose[m]]', ()),
    ('R', 'Transpose[NullSpace[m]]', ()),
    ('m', '{{1, 0, 0}, {0, 5, 0}, {-8, 8, 3}}', ()),
    ('lam', 'Eigenvalues[m]', ()),
    ('v', 'Normalize /@ Eigenvectors[m]', ()),
    ('p1', 'ContourPlot3D[x^2 + 5*y^2 + 3*z^2 + 8*y*z - 8*x*z == 1, {x, -5, 5}, {y, -5, 5}, {z, -5, 5}]', ()),
    ('p2', 'Graphics3D[Table[Arrow[{{0, 0, 0}, lam[[i]]*Normalize[v[[i]]]}], {i, 1, 3}]]', ()),
    ('m', '{{5, 0, 0}, {12, 13, 0}, {-4, 12, 14}}', ()),
    ('lam', 'Eigenvalues[m]', ()),
    ('v', 'Normalize /@ Eigenvectors[m]', ()),
    ('p1', 'ContourPlot3D[5*x^2 + 13*y^2 + 14*z^2 + 12*y*z - 4*x*z + 12*x*y == 1, {x, -2, 2}, {y, -2, 2}, {z, -2, 2}]', ()),
    ('p2', 'Graphics3D[Table[Arrow[{{0, 0, 0}, lam[[i]]*Normalize[v[[i]]]}], {i, 1, 3}]]', ()),
    ('ex', '{{0, 1}, {1, 0}}', ()),
    ('ey', '{{0, -I}, {I, 0}}', ()),
    ('ez', '{{1, 0}, {0, -1}}', ()),
    ('e', '{{1, 0}, {0, 1}}', ()),
    ('elist', '{ex, ey, ez, e}', ()),
    ('DiagTest1', 'ConjugateTranspose[a] . a == a . ConjugateTranspose[a]', ('a',)),
    ('DiagTest2', 'Length[Union[Eigenvalues[a]]] == Length[a]', ('a',)),
    ('DiagTest', 'DiagTest1[a] || DiagTest2[a]', ('a',)),
    ('m', '{{1, 2}, {-2, -3}}', ()),
]

def results():
    return evaluate_assignments(_ASSIGNMENTS, 'corpus/archive-tu/math8u.wl')
