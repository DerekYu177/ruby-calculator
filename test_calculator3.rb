require 'minitest/autorun'
require './calc3'
require 'pp'

class TestCalculator3 < Minitest::Test
  def test_value
    assert_equal(1, Calculator.calculate("1"))
  end

  def test_single_parenthesized
    assert_equal(1, Calculator.calculate("(1)"))
  end

  def test_simple_addition
    assert_equal(3, Calculator.calculate("(1+2)"))
  end

  def test_simple_multiplication
    assert_equal(4, Calculator.calculate("(2*2)"))
  end

  def test_simple_multiplication_and_addition
    # assert_equal(7, Calculator.calculate("(1+(2*3))"))
    assert_calculation(9, "((1+2)*3)")
  end

  def test_simple_with_spaces
    assert_equal(7, Calculator.calculate("( 1 +  ( 2 * 3   ) )"))
  end

  def test_with_no_brackets_addition
    assert_equal(3, Calculator.calculate("1+2"))
  end

  def test_with_no_brackets_multiplication
    assert_equal(4, Calculator.calculate("2*2"))
  end

  def test_confusing_brackets
    assert_calculation(16, "(2*2)*2*2")
  end

  def test_complicated
    assert_calculation(95, "65+6*5")
  end

  def assert_calculation(expected_value, input)
    actual_value = Calculator.calculate(input)
    return if actual_value == expected_value
    pp Expression.parse(input)
    raise "Test failed #{actual_value} vs #{expected_value}"
  end
end
