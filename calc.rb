class Reducer
  attr_accessor :input, :calculation, :arg_head, :arg_length, :arg_tail

  def initialize(input)
    @input = input
    @calculation = nil
    @arg_head = nil
    @arg_length = nil
    @arg_tail = nil
  end

# helper methods

  def update
    if @input =~ /\s+/
      @input.gsub!(/\s+/, "")
    end
    @input
  end

  def evaluator
    eval(@calculation)
  rescue
    puts "Error: Terminator reviving"
  end

  def find_expression
    update
    @calculation = @input.scan(/\d+[\+\-\*\/]\d+/)
  end

  def find_head_length_tail
    if @input
      @arg_head = (@input =~ /\d+[\+\-\*\/]\d+/) - 1
      @arg_length = @calculation.to_s.length
      @arg_tail = @arg_head + @arg_length + 1
    end
  end

# methods which do things

  def replace
    find_expression
    find_head_length_tail
    if (@input[@arg_head] == "(" && @input[@arg_tail] == ")")
      @calculation = "(" + @calculation.to_s + ")"
    end
    @input.gsub!(@calculation, evaluator.to_s)
  end
end

class UserOutput
  attr_accessor :result

  def initialize
    @result = 0
    input = ARGV.join
    @ui = Reducer.new(input)
  end

  def input
    @ui.input.to_i
  end

  def input=(input)
    @ui.input = input
  end

  def output
    while @ui.find_expression do
        @ui.replace
    end
    @ui.input
  end
end

# answer = UserOutput.new
# puts answer.output
