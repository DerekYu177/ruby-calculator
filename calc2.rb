class Expression
  attr_accessor :exp_string, :expression, :symbol, :symbol_value, :expression_location_in_exp_string, :symbol_location_in_exp_string
  attr_accessor :head, :tail, :length, :brackets, :value

  SYMBOL_VALUE = {
    "+" => 0,
    "-" => 0,
    "*" => 1,
    "/" => 1,
  }

  def initialize(exp_string, expression)
    if !exp_string && !expression
      @exp_string = nil
      @expression = nil
      @symbol = nil
      @symbol_value = 0
      @expression_location_in_exp_string = 6.02E23
      @symbol_location_in_exp_string = nil
      @head = nil
      @length = nil
      @tail = nil
      @brackets = false
      @value = 0
    else
      @exp_string = exp_string
      @expression = expression
      @symbol = expression_symbol
      @symbol_value = expression_symbol_value
      @expression_location_in_exp_string = find_expression_location_in_exp_string
      @symbol_location_in_exp_string = find_symbol_location_in_exp_string
      @head = find_head
      @length = find_length
      @tail = find_tail
      @brackets = find_brackets
      @value = expression_value
    end
  end

  def expression_symbol
    @symbol = expression.match(/[\+\-\*\/]/)
    @symbol[0]
  end

  def expression_symbol_value
    @symbol_value = SYMBOL_VALUE[@symbol]
  end

  def find_expression_location_in_exp_string
    @expression_location_in_exp_string = @exp_string =~ /#{Regexp.escape(@expression)}/
  end

  def find_symbol_location_in_exp_string
    symbol_location_in_expression = expression =~ /[\+\-\*\/]/
    @symbol_location_in_exp_string = @expression_location_in_exp_string + symbol_location_in_expression
  end

  def find_head
    @head = @expression_location_in_exp_string - 1
  end

  def find_length
    @length = @expression.to_s.length
  end

  def find_tail
    @tail = @head + @length + 1
  end

  def find_brackets
    @brackets = false
    if exp_string[@head] == "(" && exp_string[@tail] == ")"
      @brackets = true
    end
    @brackets
  end

  def expression_value
    par = Parser.new(expression)
    par.calculation
  end
end

class Reducer
  attr_accessor :input, :str_exps, :obj_exps, :priority_exp

  def initialize(input)
    @input = input
    @str_exps = nil
    @obj_exps = []
    @priority_exp = nil
  end

  def initial_expressions
    @str_exps = nil
    @obj_exps = []
    @str_exps = @input.scan(/\d+[\+\-\*\/]\d+/)
    @str_exps.each do |exp|
      e = Expression.new(@input, exp)
      @obj_exps << e
    end
  end

  def secondary_expressions
    # if we remove the symbols associated with initial_expressions,
    # we can find secondary expressions in the rubble
    i = @input.clone
    @obj_exps.each do |obj_exp|
      i[obj_exp.symbol_location_in_exp_string] = " "
    end

    secondary_expressions = i.scan(/\d+[\+\-\*\/]\d+/)
    secondary_expressions.each do | secondary_expression |
      e = Expression.new(@input, secondary_expression)
      e.exp_string = @input
      @obj_exps << e
      @str_exps << secondary_expression
    end
    @str_exps
  end

  def priority_picker
  	standard = Expression.new(nil, nil)
  	@obj_exps.each do |obj_exp|
  		# number of hours spent on trying to optimize : 4
  		if standard.brackets
  			if obj_exp.brackets
  				if obj_exp.symbol_value > standard.symbol_value
  					standard = obj_exp
  				elsif obj_exp.symbol_value == standard.symbol_value
  					if obj_exp.expression_location_in_exp_string < standard.expression_location_in_exp_string
  						standard = obj_exp
  					else
  						next
  					end
  				else
  					next
  				end
  			else
  				next
  			end
  		else
  			if obj_exp.brackets
  				standard = obj_exp
  			else
  				if obj_exp.symbol_value > standard.symbol_value
  					standard = obj_exp
  				elsif obj_exp.symbol_value == standard.symbol_value
  					if obj_exp.expression_location_in_exp_string < standard.expression_location_in_exp_string
  						standard = obj_exp
  					else
  						next
  					end
  				else
  					next
  				end
  			end
  		end
  	end
  	@obj_exps.delete(standard)
  	@priority_exp = standard
  end

  def replace_expression
    if @priority_exp.brackets
      @priority_exp.expression = "(" + @priority_exp.expression.to_s + ")"
    end
    @input.gsub!(@priority_exp.expression, @priority_exp.value.to_s)
  end

  def output
    while initial_expressions.length > 0 do
      secondary_expressions
      priority_picker
      replace_expression
    end
    @input
  end
end

class Parser
  require 'strscan'

  attr_accessor :buffer, :expression, :symbol, :calculation

	def initialize(eqn)
		@buffer = StringScanner.new(eqn)
		@expression = []
		@symbol = ""
		@calculation = nil
		parse
		execute_calculation
	end

	def parse
    parse_element
    parse_symbol
    parse_element
	end

	def parse_element
		@expression << @buffer.scan(/\d+/)
	end

	def first_element
		@expression.first.to_i
	end

	def last_element
		@expression.last.to_i
	end

	def parse_symbol
		@symbol = @buffer.scan(/[\+\-\*\/]/)
	end

	def execute_calculation
		@calculation = first_element.send(@symbol, last_element)
	end
end
