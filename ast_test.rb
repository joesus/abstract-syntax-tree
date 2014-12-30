require 'minitest/autorun'
require_relative 'ast'

class ASTTest < MiniTest::Unit::TestCase

  def setup
    @default_ast = ASTNode.new(:+, ASTNode.new(1), ASTNode.new(2))
    @zero_branches_ast = ASTNode.new(:+)
    @one_branch_ast = ASTNode.new(:+, ASTNode.new(1))
    @two_level_ast = ASTNode.new(:+, ASTNode.new(:+, ASTNode.new(1), ASTNode.new(2)), ASTNode.new(3))
  end

  def test_ast_initializes_with_correct_values
    assert_equal :+, @default_ast.value
    assert_equal 1, @default_ast.left.value
    assert_equal 2, @default_ast.right.value
  end

  def test_ast_initializes_with_one_branch
    assert_equal 1, @one_branch_ast.left.value
    assert_equal nil, @one_branch_ast.right
  end

  def test_ast_initialized_with_zero_branches
    assert_equal nil, @zero_branches_ast.left
    assert_equal nil, @zero_branches_ast.right
  end

  def test_leaf?
    assert_equal true, @default_ast.left.leaf?
    assert_equal false, @two_level_ast.left.leaf?
  end
end