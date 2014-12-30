require 'pry-nav'

class ASTNode
  attr_accessor :value, :left, :right

  def initialize(value, left=nil, right=nil)
    @value = value
    @left = left
    @right = right
  end

  def to_s
    # implement to_s
  end

  def leaf?
    # implement leaf
  end

end