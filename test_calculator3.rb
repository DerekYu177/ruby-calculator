require 'minitest/autorun'
require './calc3'

class TestCalculator3 < Minitest::Test
  def test_value
    assert_equal(1, Calculator.calculate("1"))
  end

  def test_simple_addition
    assert_equal(3, Calculator.calculate("(1+2)"))
  end

  def test_simple_multiplication
    assert_equal(4, Calculator.calculate("(2*2)"))
  end

  def test_simple_multiplication_and_addition
    assert_equal(7, Calculator.calculate("(1+(2*3))"))
    assert_equal(9, Calculator.calculate("((1+2)*3)"))
  end

  def test_simple_with_spaces
    assert_equal(7, Calculator.calculate("( 1 +  ( 2 * 3   ) )"))
  end

  def test_with_multiple_addition
    assert_equal(9, Calculator.calculate("1+2"))

  end
end
