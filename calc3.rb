require 'strscan'

class Calculator
  def self.calculate(input)
    expression = Expression.parse(input)
    expression.evaluate
  end

end

class Expression
  def self.parse(input)
    scanner = StringScanner.new(input.gsub(/\s/, ""))
    parse_expression(scanner)
  end

  def self.parse_expression(scanner)
    if number = scanner.scan(/\d+/)
      Value.new(number)
    elsif scanner.scan(/\(/)
      operation = parse_operation(scanner)
      scanner.scan(/\)/)
      operation
    end
  end

  def self.parse_operation(scanner)
    left = parse_expression(scanner)
    operator = scanner.scan(/[\+\-\*\/]/)
    right = parse_expression(scanner)
    Operation.new(left, operator, right)
  end
end

class Value
  def initialize(value)
    @value = value
  end

  def evaluate
    @value.to_i
  end
end

class Operation
  def initialize(left, operator, right)
    @left = left
    @operator = operator
    @right = right
  end

  def evaluate
    @left.evaluate.send(@operator, @right.evaluate)
  end
end
