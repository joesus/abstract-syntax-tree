require 'minitest/autorun'
require_relative 'ast'

class ASTTest < MiniTest::Unit::TestCase

  def setup
    @one_node = ASTNode.new(value: 1)
    @two_node = ASTNode.new(value: 2)
    @three_node = ASTNode.new(value: 3)
    @plus_node = ASTNode.new(value: :+)


    @default_ast = ASTNode.new(value: :+,
                               left: @one_node,
                               right: @two_node)
    @zero_branches_ast = @plus_node

    @one_branch_ast = ASTNode.new(value: :+,
                                  left: @one_node)
    @one_branch_ast.left.parent = @one_branch_ast

    @two_levels_left = ASTNode.new(value: :+,
                                   left: ASTNode.new(value: :+,
                                                     left: ASTNode.new(value: 1),
                                                     right: ASTNode.new(value: 2)),
                                   right: ASTNode.new(value: 3))

    @two_levels_right = ASTNode.new(value: :+, left: ASTNode.new(value: 1), right: ASTNode.new(value: :+, left: ASTNode.new(value: 2), right: ASTNode.new(value: 3)))
    @two_levels_both = ASTNode.new(value: :+, left: ASTNode.new(value: :+, left: ASTNode.new(value: 1), right: ASTNode.new(value: 2)), right: ASTNode.new(value: :+, left: ASTNode.new(value: 3), right: ASTNode.new(value: 4)))
    @three_levels = ASTNode.new(value: :+,
                                left: ASTNode.new(value: :+,
                                                  left: ASTNode.new(value: 1),
                                                  right: ASTNode.new(value: 2)
                                ),
                                right: ASTNode.new(value: :+,
                                                   left: ASTNode.new(value: 3),
                                                   right: ASTNode.new(value: :+,
                                                                      left: ASTNode.new(value: 4),
                                                                      right: ASTNode.new(value: 5))
                                ))
    @tree = ASTNode.new(value: :+,
                                left: ASTNode.new(value: :+,
                                                  left: ASTNode.new(value: 1),
                                                  right: ASTNode.new(value: 2)
                                ),
                                right: ASTNode.new(value: :+,
                                                   left: ASTNode.new(value: 3),
                                                   right: ASTNode.new(value: :+,
                                                                      left: ASTNode.new(value: 4),
                                                                      right: ASTNode.new(value: 5))
                                ))
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

  def test_to_s_three_levels
    assert_equal "(1 + 2) + (3 + (4 + 5))", @three_levels.to_s
  end

  def test_find_by_value
    assert_equal @two_levels_left.left.left, @two_levels_left.find_by_value(1)
    assert_equal @default_ast.left, @default_ast.find_by_value(1)
    assert_equal @two_levels_right.right.right, @two_levels_right.find_by_value(3)
    assert_equal @three_levels.right.right.left, @three_levels.find_by_value(4)
  end

  def test_moving_branches
    # find the nodes
    five = @tree.find_by_value(5)
    two = @tree.find_by_value(2)
    # store their parents
    temp5parent = @tree.find_by_value(5).parent.parent
    temp2parent = two.parent
    # swap the children of those parents
    temp5parent.right = two
    temp2parent.right = five.parent

    assert_equal "(1 + (4 + 5)) + (3 + 2)", @tree.to_s
  end

  def test_parse_one_level
    one_level = ASTNode.parse("1 + 2")
    assert_equal one_level.to_s, @default_ast.to_s
  end

  def test_parse_two_levels
    two_levels_left = ASTNode.parse("(1 + 2) + 3")
    assert_equal @two_levels_left.to_s, two_levels_left.to_s
  end

  def test_parse_three_levels
    binding.pry
    three_levels = ASTNode.parse("(1 + 2) + (3 + (4 + 5))")
    assert_equal three_levels.to_s, @tree.to_s
  end
end