require 'pry-nav'

class ASTNode
  attr_accessor :value, :left, :right

  def initialize(value, left=nil, right=nil)
    @value = value
    @left = left
    @right = right
  end

  def to_s
    string ||= ""
    if self.left.leaf?
      string << "#{self.left.value}"
    else
      string << "(#{self.left.to_s})"
    end
    string << " #{self.value} "
    if self.right.leaf?
      string << "#{self.right.value}"
    else
      string << "(#{self.right.to_s})"
    end
  end

  def leaf?
    self.left.nil? && self.right.nil? rescue nil
  end

end