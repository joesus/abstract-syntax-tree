require 'pry-nav'

class ASTNode
  attr_accessor :value, :left, :right, :parent

  def initialize(value, left=nil, right=nil, parent=nil)
    @value = value
    @left = left
    @right = right
    @parent = parent
  end

  def to_s(string="")
    string ||= ""
    if self.parent.to_s =~ /[-+*\/]/ && self.value =~ /[-+*\/]/
      # string << "("
      string << "("
      self.left.to_s(string)
      string << " #{self.value} "
      self.right.to_s(string)
      string << ")"
    else
      self.left.to_s(string) unless self.leaf?
      self.value.to_s =~ /[-+*\/]/ ? string << " #{self.value} " : string << "#{self.value}"
      self.right.to_s(string) unless self.leaf?
    end
    string
  end

  def leaf?
    self.left.nil? && self.right.nil? rescue nil
  end

end