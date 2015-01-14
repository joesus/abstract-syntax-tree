require 'minitest/autorun'
require_relative 'ast'

class ASTTest < MiniTest::Unit::TestCase

  def setup
    @default_ast = ASTNode.new(value: :+,
                               left: ASTNode.new(value: 1),
                               right: ASTNode.new(value: 2),
                               parent: true)
    @zero_branches_ast = ASTNode.new(value: :+)
    @one_branch_ast = ASTNode.new(value: :+,
                                  left: ASTNode.new(value: 1))
    @two_levels_left = ASTNode.new(value: :+,
                                   left: ASTNode.new(value: :+, left: ASTNode.new(value: 1), right: ASTNode.new(value: 2)),
                                   right: ASTNode.new(value: 3),
                                   parent: true)
    @two_levels_right = ASTNode.new(value: :+,
                                    left: ASTNode.new(value: 1),
                                    right: ASTNode.new(value: :+, left: ASTNode.new(value: 2), right: ASTNode.new(value: 3)),
                                    parent: true)
    @two_levels_both = ASTNode.new(value: :+,
                                   left: ASTNode.new(value: :+, left: ASTNode.new(value: 1), right: ASTNode.new(value: 2)),
                                   right: ASTNode.new(value: :+, left: ASTNode.new(value: 3), right: ASTNode.new(value: 4)),
                                   parent: true)
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
    assert_equal false, @two_levels_left.left.leaf?
  end

  def test_to_s_one_level
    assert_equal "1 + 2", @default_ast.to_s
  end

  def test_to_s_two_levels
    assert_equal "(1 + 2) + 3", @two_levels_left.to_s
    assert_equal "1 + (2 + 3)", @two_levels_right.to_s
    assert_equal "(1 + 2) + (3 + 4)", @two_levels_both.to_s
  end
end