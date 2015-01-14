require 'pry-nav'

class ASTNode
  attr_accessor :value, :left, :right, :parent

  def initialize(args={})
    @value = args[:value]
    @left =  args[:left]
    @right = args[:right]
    @parent = args[:parent]
  end

  def to_s(string="")
    string ||= ""
    if !self.parent && self.value =~ /[-+*\/]/
      # string << "("
      string << "("
      self.left.to_s(string)
      string << " #{self.value} "
      self.right.to_s(string)
      string << ")"
    else
      self.left.to_s(string) unless self.leaf?
      self.value =~ /[-+*\/]/ ? string << " #{self.value} " : string << "#{self.value}"
      self.right.to_s(string) unless self.leaf?
    end
    string
  end

  def leaf?
    self.left.nil? && self.right.nil? rescue nil
  end

end