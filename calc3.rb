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
    expression = parse_expression(scanner)
    unless scanner.eos?
      raise "scanner not empty \"#{scanner.rest}\" still remaining"
    end
    expression
  end

  def self.parse_expression(scanner)
    if operation = parse_operation(scanner, /([\d\+\-]+)([\*\/])/)
      operation
    elsif operation = parse_operation(scanner, /([\d]+)([\+\-])/)
      operation
    elsif number = scanner.scan(/\d+/) #test for singular numbers
      Value.new(number)
    elsif scanner.scan(/\(/) #test for bracket expression
      expression = parse_expression(scanner)

      if scanner.scan(/\)/)
        expression
      end
      if operator = scanner.scan(/[\+\-\*\/]/)
        left = expression
        right = parse_expression(scanner)
        scanner.scan(/\)/)
        Operation.new(left, operator, right)
      else
        expression
      end
    end
  end

  def self.parse_operation(scanner, regex)
    if scanner.scan(regex)
      left = parse(scanner[1])
      operator = scanner[2]
      right = parse_expression(scanner)
      Operation.new(left, operator, right)
    end
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
