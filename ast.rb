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
    string << self.left.to_s+' ' if !self.left.nil?
    string << self.value.to_s
    string << ' '+self.right.to_s if !self.right.nil?
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

  protected

  def add_parens?
    self.operator? && self.parent
  end

  def operator?
    self.value =~ /[-+*\/]/
  end

end