require 'minitest/autorun'
require '/Users/derekyu/Documents/Calculator/calc'

class TestCalculator < Minitest::Test
  def setup
    @ui = Reducer.new("((10 +    4) * 5) +     6+ 6 * 5")
    @uo = UserOutput.new
    @uo.input = "((10 +    4) * 5) +     6+ 6 * 5"
  end

  def test_reducer_update_functionality
    @ui.update
    expected = "((10+4)*5)+6+6*5"
    assert_equal(expected, @ui.input, "update failed")
  end

  def test_reducer_find_expression
    @ui.find_expression
    expected = "10+4"
    assert_equal(expected, @ui.calculation)
  end

  def test_reducer_evaluator
    @ui.calculation = "10 + 4"
    expected = 14
    assert_equal(expected, @ui.evaluator)
  end

  def test_reducer_head_length_tail
    @ui.find_expression
    @ui.find_head_length_tail
    expected_head = 1
    expected_length = 4
    expected_tail = 6
    assert_equal(expected_head, @ui.arg_head)
    assert_equal(expected_length, @ui.arg_length)
    assert_equal(expected_tail, @ui.arg_tail)
  end

  def test_reducer_replace_with_brackets
    @ui.replace
    expected = "14*5+6+6*5"
    assert_equal(expected, @ui.input)
  end

  def test_reducer_replace_without_brackets
    @ui.input = "10+4*5"
    @ui.replace
    expected = "14*5"
    assert_equal(expected, @ui.input)
  end

  def test_useroutput_initialize
    assert_equal(0, @uo.result)
  end

  def test_useroutput_loop
    expected = 106
    @uo.output
    assert_equal(expected, @uo.input)
  end
end
