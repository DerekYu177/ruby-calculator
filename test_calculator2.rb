require 'minitest/autorun'
require '/Users/derekyu/Documents/Calculator/calc2'

class TestCalculator < Minitest::Test
  def setup
    exp_string = "((104+4)*5)+65+6*5+(48+234)"
    expression = "48+234"
    @exp = Expression.new(exp_string, expression)
    @red = Reducer.new(exp_string)
  end

  def test_expression_nil
    e = Expression.new(nil, nil)
    expected = 0
    assert_equal(expected, e.value)
  end

  def test_expression_symbol
    expected = "+"
    assert_equal(expected, @exp.symbol)
  end

  def test_expression_symbol_value
    expected = 0
    assert_equal(expected, @exp.symbol_value)
  end

  def test_expression_location_in_exp_string
    expected = 20
    assert_equal(expected, @exp.expression_location_in_exp_string)
  end

  def test_symbol_location_in_exp_string
    expected = 22
    assert_equal(expected, @exp.symbol_location_in_exp_string)
  end

  def test_expression_head
    expected = 19
    assert_equal(expected, @exp.head)
  end

  def test_expression_length
    expected = 6
    assert_equal(expected, @exp.length)
  end

  def test_expression_tail
    expected = 26
    assert_equal(expected, @exp.tail)
  end

  def test_expression_brackets
    expected = true
    assert_equal(expected, @exp.brackets)
  end

  def test_expression_value
    expected = 282
    assert_equal(expected, @exp.value)
  end

  def test_reducer_initial_expressions
    expected = ["104+4", "65+6", "48+234"]
    assert_equal(expected, @red.initial_expressions)
  end

  def test_reducer_secondary_expressions
    expected = ["104+4", "65+6", "48+234", "6*5"]
    @red.initial_expressions
    assert_equal(expected, @red.secondary_expressions)
  end

  def test_reducer_priority_picker
    @red.initial_expressions
    @red.secondary_expressions
    @red.priority_picker
    expected = "104+4"
    assert_equal(expected, @red.priority_exp.expression)
  end

  def test_reducer_replace_expression
    @red.initial_expressions
    @red.secondary_expressions
    @red.priority_picker
    @red.replace_expression
    expected = "(108*5)+65+6*5+(48+234)"
    assert_equal(expected, @red.input)
  end

  def test_reducer_output
    expected = "917"
    assert_equal(expected, @red.output)
  end

  def test_reducer_priority_picker_2
    @red = Reducer.new("540+65+6*5+282")
    @red.initial_expressions
    @red.secondary_expressions
    @red.priority_picker
    expected = "6*5"
    assert_equal(expected, @red.priority_exp.expression)
  end

  def test_parser
    @par = Parser.new("10+3")
    expected = 13
    assert_equal(expected, @par.calculation)
  end

  def test_lol
    @red.input = "(4+5)*((6+1)+1)"
    @red.output
    assert_equal(72, @red.priority_exp.value)
  end
end

((104 4)*5)+65 6*5+(48 234)
