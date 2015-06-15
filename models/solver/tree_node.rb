class TreeNode

  attr_reader   :node, :children, :g
  attr_accessor :h

  def initialize(node, g = 0)
    @node     = node
    @children = []
    @g        = g
    @h        = Float::INFINITY
  end

  def add_child(tree_node)
    @children << tree_node
  end

  def remove_child(tree_node)
    @children.delete(tree_node)
  end

  def f
    @g + @h
  end

  def won?
    @node.won?
  end

  def find_children
    a = NodeChildrenService.new(@node).run.nodes.collect do |node|
      TreeNode.new(node, @g + 1)
    end

    b = NodeChildrenToGoalsService.new(@node).run.nodes.collect do |node|
      TreeNode.new(node[:node], @g + node[:pushes])
    end

    a + b
  end

end
