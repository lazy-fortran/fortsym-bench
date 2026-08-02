from __future__ import annotations

import sympy as sp

from tools.translate_wl_corpus import render_module
from fortsym_bench.wl_to_sympy import evaluate_assignments, extract_assignments


def test_compound_expression_and_function_assignments_are_evaluated_in_order():
    assignments, skipped = extract_assignments(
        "Clear[x], Null, f[i_] := i^2; values = Table[f[i], {i, 3}]"
    )

    assert [assignment.name for assignment in assignments] == ["f", "values"]
    assert skipped == ["Clear[x]", "Null"]

    values = evaluate_assignments(assignments)
    assert values["values"] == sp.Tuple(1, 4, 9)


def test_matrix_operations_and_replacement_have_independent_sympy_answers():
    assignments, _ = extract_assignments(
        "m = {{1, 2}, {3, 4}}; v = {x, y}; "
        "product = m . v; replaced = product /. {x -> 5, y -> 7}; "
        "inverse = Inverse[m]"
    )

    values = evaluate_assignments(assignments)
    x, y = sp.symbols("x y")
    assert values["product"] == sp.Tuple(x + 2 * y, 3 * x + 4 * y)
    assert values["replaced"] == sp.Tuple(19, 43)
    assert values["inverse"] == sp.Tuple(
        sp.Tuple(-2, 1), sp.Tuple(sp.Rational(3, 2), -sp.Rational(1, 2))
    )


def test_cross_product_has_the_independent_three_vector_formula():
    assignments, skipped = extract_assignments(
        "value = Cross[{a, b, c}, {d, e, f}]"
    )

    assert skipped == []
    a, b, c, d, e, f = sp.symbols("a b c d e f")
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(
        b * f - c * e,
        c * d - a * f,
        a * e - b * d,
    )


def test_pure_functions_map_apply_and_mapthread():
    assignments, skipped = extract_assignments(
        "squares = Map[#^2 &, {1, 2, 3}]; "
        "total = Apply[Plus, {1, 2, 3}]; "
        "paired = MapThread[#1 + #2 &, {{1, 2}, {3, 4}}]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)

    assert values["squares"] == sp.Tuple(1, 4, 9)
    assert values["total"] == 6
    assert values["paired"] == sp.Tuple(4, 6)


def test_a_script_without_assignments_returns_an_empty_result_set():
    assignments, skipped = extract_assignments("Print[1]; Null")

    assert assignments == []
    assert skipped == ["Print[1]", "Null"]
    assert evaluate_assignments(assignments) == {}


def test_leading_continuation_operators_stay_in_the_same_assignment():
    assignments, skipped = extract_assignments(
        "value = a\n"
        "  + b\n"
        "  - c;\n"
        "other = d\n"
        "  * e"
    )

    assert skipped == []
    assert [(item.name, item.rhs) for item in assignments] == [
        ("value", "a\n  + b\n  - c"),
        ("other", "d\n  * e"),
    ]


def test_multiline_rhs_is_arithmetic_not_a_compound_expression():
    assignments, skipped = extract_assignments("value = a\n  + b")

    assert skipped == []
    a, b = sp.symbols("a b")
    assert evaluate_assignments(assignments)["value"] == a + b


def test_multiline_matrix_product_keeps_a_trailing_dot_in_the_rhs():
    assignments, skipped = extract_assignments(
        "value = {1, 2} .\n  {x, y}"
    )

    assert skipped == []
    x, y = sp.symbols("x y")
    assert evaluate_assignments(assignments)["value"] == x + 2 * y


def test_list_selectors_preserve_wolfram_item_order():
    assignments, skipped = extract_assignments(
        "first = First[{a, b, c}]; "
        "tail = Rest[{a, b, c}]; "
        "middle = Take[{a, b, c, d}, {2, 3}]; "
        "dropped = Drop[{a, b, c, d}, -2]; "
        "head = Most[{a, b, c}]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    a, b, c, d = sp.symbols("a b c d")
    assert values["first"] == a
    assert values["tail"] == sp.Tuple(b, c)
    assert values["middle"] == sp.Tuple(b, c)
    assert values["dropped"] == sp.Tuple(a, b)
    assert values["head"] == sp.Tuple(a, b)


def test_diagonal_extracts_the_shorter_dimension_of_a_matrix():
    assignments, skipped = extract_assignments(
        "value = Diagonal[{{1, 2, 3}, {a, 5, 6}}]"
    )

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(1, 5)


def test_diagonal_preserves_a_non_matrix_argument():
    assignments, skipped = extract_assignments("value = Diagonal[s]")

    assert skipped == []
    s = sp.Symbol("s")
    assert evaluate_assignments(assignments)["value"] == sp.Function("Diagonal")(s)


def test_legendre_polynomial_uses_sympys_independent_definition():
    assignments, skipped = extract_assignments("value = LegendreP[3, x]")

    assert skipped == []
    x = sp.Symbol("x")
    assert evaluate_assignments(assignments)["value"] == sp.legendre(3, x)


def test_characteristic_polynomial_uses_sympys_matrix_definition():
    assignments, skipped = extract_assignments(
        "value = CharacteristicPolynomial[{{1, 2}, {3, 4}}, z]"
    )

    assert skipped == []
    z = sp.Symbol("z")
    matrix = sp.Matrix([[1, 2], [3, 4]])
    assert evaluate_assignments(assignments)["value"] == matrix.charpoly(z).as_expr()


def test_matrix_power_uses_sympys_matrix_definition():
    assignments, skipped = extract_assignments(
        "value = MatrixPower[{{1, 2}, {3, 4}}, 2]"
    )

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(
        sp.Tuple(7, 10), sp.Tuple(15, 22)
    )


def test_coefficient_and_coefficient_list_reconstruct_a_polynomial():
    assignments, skipped = extract_assignments(
        "value = 5 + 2*x - 3*x^2 + 7*x^3; "
        "coefficient = Coefficient[value, x, 2]; "
        "coefficients = CoefficientList[value, x]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    x = sp.Symbol("x")
    assert values["coefficient"] == -3
    assert values["coefficients"] == sp.Tuple(5, 2, -3, 7)
    reconstructed = sum(values["coefficients"][power] * x**power
                         for power in range(4))
    assert sp.expand(reconstructed - values["value"]) == 0


def test_polynomial_heads_have_independent_division_and_content_identities():
    assignments, skipped = extract_assignments(
        "value = (x - y)*(x + 2*y); "
        "degree = Exponent[value, x]; "
        "fractional = Exponent[(u - v)*x^(2/5), x]; "
        "gcd = PolynomialGCD[value, (x - y)*(x + 3*y)]; "
        "quotient = PolynomialQuotient[value, x - y, x]; "
        "remainder = PolynomialRemainder[value, x - y, x]; "
        "numerator = Numerator[(x + 1)/(y + 2)]; "
        "denominator = Denominator[(x + 1)/(y + 2)]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    x, y = sp.symbols("x y")
    assert values["degree"] == 2
    assert values["fractional"] == sp.Rational(2, 5)
    assert sp.expand(values["gcd"] - (x - y)) == 0
    assert sp.expand(values["quotient"] - (x + 2 * y)) == 0
    assert values["remainder"] == 0
    assert values["numerator"] == x + 1
    assert values["denominator"] == y + 2


def test_multivariate_coefficient_list_keeps_variable_order():
    assignments, skipped = extract_assignments(
        "value = 1 + 2*x + 3*y + 4*x*y; "
        "coefficients = CoefficientList[value, {x, y}]"
    )

    assert skipped == []
    x, y = sp.symbols("x y")
    assert evaluate_assignments(assignments)["coefficients"] == sp.Tuple(
        sp.Tuple(1, 3), sp.Tuple(2, 4)
    )


def test_solve_wraps_single_variable_roots_in_wolfram_rules():
    assignments, skipped = extract_assignments("value = Solve[x + a == 0, x]")

    assert skipped == []
    x, a = sp.symbols("x a")
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(
        sp.Tuple(sp.Function("Rule")(x, -a))
    )


def test_solve_rules_can_feed_replace_all():
    assignments, skipped = extract_assignments(
        "value = r /. First[Solve[2*r == (1-r)/2, r]]"
    )

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Rational(1, 5)


def test_thread_expands_equal_lists_with_an_independent_shape_check():
    assignments, skipped = extract_assignments(
        "value = Thread[Equal[{x, y}, {a, b}]]; "
        "numeric = Thread[Equal[{1, 2}, {1, 3}]]; "
        "lhs = {x, y}; rhs = {a, b}; "
        "bound = Thread[Equal[lhs, rhs]]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    x, y, a, b = sp.symbols("x y a b")
    assert values["value"] == sp.Tuple(sp.Eq(x, a), sp.Eq(y, b))
    assert values["numeric"] == sp.Tuple(sp.true, sp.false)
    assert values["bound"] == values["value"]


def test_map_supports_a_bounded_nested_level():
    assignments, skipped = extract_assignments(
        "value = Map[#^2 &, {{1, 2}, {3, 4}}, {2}]"
    )

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(
        sp.Tuple(1, 4), sp.Tuple(9, 16)
    )


def test_piecewise_selects_numeric_branches_and_default():
    assignments, skipped = extract_assignments(
        "value = Piecewise[{{10, 1 < 2}, {20, 2 < 3}}, 0]"
    )
    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Integer(10)

    assignments, skipped = extract_assignments(
        "value = Piecewise[{{10, 1 > 2}}, 7]"
    )
    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Integer(7)


def test_boole_returns_numeric_indicator_for_decidable_conditions():
    assignments, skipped = extract_assignments("value = Boole[1 < 2]")
    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Integer(1)

    assignments, skipped = extract_assignments("value = Boole[1 > 2]")
    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Integer(0)


def test_which_selects_the_first_true_numeric_branch():
    assignments, skipped = extract_assignments(
        "value = Which[1 > 2, 10, 2 < 3, 20, True, 30]"
    )
    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Integer(20)


def test_fold_list_returns_prefix_sums_including_the_initial_value():
    assignments, skipped = extract_assignments(
        "value = FoldList[Plus, 1, Drop[{1, 2, 3, 4}, 1]]"
    )

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(1, 3, 6, 10)


def test_string_literals_use_the_native_comparison_atom():
    assignments, skipped = extract_assignments('value = "figures"')

    assert skipped == []
    assert evaluate_assignments(assignments)["value"] == sp.Symbol(
        "fortsymString195f2d656951581bf511ac10931f425807ef65c7833998a8a11aed68ed769300"
    )


def test_diagonal_singular_values_and_numeric_extrema_lower_directly():
    assignments, skipped = extract_assignments(
        "values = SingularValueList[{{0.0, 0.0}, {0.0, -3.0}}]; "
        "largest = Max[values]; smallest = Min[values]"
    )

    assert skipped == []
    values = evaluate_assignments(assignments)
    assert values["values"] == sp.Tuple(sp.Float(3.0), sp.Integer(0))
    assert values["largest"] == sp.Float(3.0)
    assert values["smallest"] == sp.Integer(0)


def test_unsupported_singular_value_shapes_remain_opaque():
    assignments, skipped = extract_assignments("value = SingularValueList[{{x, 1}, {0, y}}]")

    assert skipped == []
    x, y = sp.symbols("x y")
    assert evaluate_assignments(assignments)["value"] == sp.Function(
        "SingularValueList"
    )(sp.Tuple(sp.Tuple(x, 1), sp.Tuple(0, y)))


def test_unicode_lambda_is_safe_inside_sympy_function_calls():
    assignments, skipped = extract_assignments(
        "value = CharacteristicPolynomial[{{1, 2}, {3, 4}}, λ]"
    )

    assert skipped == []
    lam = sp.Symbol("λ")
    matrix = sp.Matrix([[1, 2], [3, 4]])
    assert evaluate_assignments(assignments)["value"] == matrix.charpoly(lam).as_expr()


def test_derivative_of_a_list_is_componentwise():
    assignments, skipped = extract_assignments(
        "value = D[{x^2, Sin[x]}, x]"
    )

    assert skipped == []
    x = sp.Symbol("x")
    assert evaluate_assignments(assignments)["value"] == sp.Tuple(2 * x, sp.cos(x))


def test_generated_numeric_assignments_declare_numeric_comparison_policy():
    assignments, skipped = extract_assignments(
        "value = N[Pi, 30]; exact = x^2"
    )

    module = render_module("case.wl", assignments, len(skipped))

    assert "COMPARE = {" in module
    assert "'value': 'numeric'" in module
    assert "'exact'" not in module.split("COMPARE = {", 1)[1].split("}", 1)[0]
