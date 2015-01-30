require 'pry-nav'

class ASTNode
  attr_accessor :value, :left, :right, :parent

  def initialize(args={})
    self.value = args[:value]
    self.left =  args[:left]
    self.right = args[:right]
    self.parent = args[:parent]
  end

  def left=(node)
    @left = node
    node.parent = self unless node.nil?
  end

  def right=(node)
    @right = node
    node.parent = self unless node.nil?
  end

  def to_s
    string = ''
    string << '(' if add_parens?
    string << self.left.to_s + ' ' unless self.left.nil?
    string << self.value.to_s
    string << ' ' + self.right.to_s unless self.right.nil?
    string << ')' if add_parens?
    string
  end

  def root?
    self.parent.nil?
  end

  def leaf?
    self.left.nil? && self.right.nil? rescue nil
  end

  def find_by_value(val)
    target ||= nil
    if self.value == val
      target = self
    else
      if self.left
        target = self.left.find_by_value(val)
      end

      if self.right && target.nil?
        target = self.right.find_by_value(val)
      end
    end
    target
  end

  def execute
    if self.operator?
      OP_FUNCTION[self.value].call(
        (self.left.execute rescue nil),
        (self.right.execute rescue nil))
    else
      self.value
    end
  end

  protected

  def add_parens?
    self.operator? && self.parent
  end

  def operator?
    self.value =~ /[-+*\/]/
  end

  OP_PRIORITY = { :+ => 0, :- => 0, :* => 1, :/ => 1, "(" => 2, ")" => 2}
  OPERATORS = ['+', '-', '/', '*', :+, :-, :/, :*]
  OP_FUNCTION = {
    :+ => lambda {|x, y| x + y},
    :- => lambda {|x, y| x - y},
    :* => lambda {|x, y| x * y},
    :/ => lambda {|x, y| x / y}
  }

  def self.parse(formula)
    operator_stack, node_stack = [],[]

    formula_array = formula.gsub(/([\+\-\/\*])/,' \1 ')
    .gsub(/([\(\)])/,' \1 ')
    .split(/\s+/)

    formula_array.each do |formula_item|

      # IF ITEM IS AN OPERATOR
      if OPERATORS.include? formula_item
        # Checks to see if the new operator has a higher priority than operator previously
        # added to the operator_stack
        # If so, the operator is given the last two items on the node stack as it's child nodes
        # Otherwise, the new operator is added to the stack for later evaluation.
        stack_it(operator_stack, node_stack) until (operator_stack.empty? ||
                                                    operator_stack.last.value == '(' ||
                                                    OP_PRIORITY[formula_item.to_sym] > OP_PRIORITY[operator_stack.last.value.to_sym])

        operator_stack << ASTNode.new(value: formula_item.to_sym)
      # IF ITEM IS AN OPEN PARENS
      elsif formula_item == '('
        operator_stack << ASTNode.new(value: formula_item)
      # IF ITEM IS A CLOSED PARENS
      elsif formula_item == ')'
        # Addresses each item on the operator stack via the stack_it method
        # until the last item on the operator stack is the corresponding open parens
        while operator_stack.last.value != '(' && !operator_stack.empty?
          stack_it(operator_stack, node_stack)
        end
        # Removes the corresponding open parens so that the following operator node can be accessed
        operator_stack.pop
      # IF ITEM IS A NON-OPERATOR
      else
        formula_item = formula_item.to_i if formula_item.match(/[0-9]+/)
        node_stack << ASTNode.new(value: formula_item) unless formula_item == ""
      end
    end

    # deals with the final operator on the stack
    until operator_stack.empty?
      stack_it(operator_stack, node_stack)
    end

    node_stack.last
  end

  def self.stack_it(operator_stack, node_stack)
    temp = operator_stack.pop
    temp.right = node_stack.pop
    temp.left = node_stack.pop
    node_stack << temp
  end

end