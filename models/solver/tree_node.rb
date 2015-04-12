class TreeNode

  attr_reader   :node, :children
  attr_accessor :pushes

  def initialize(node, pushes = 0)
    @node     = node
    @children = []
    @pushes   = pushes
  end

  def add_child(tree_node)
    @children << tree_node
  end

  def remove_child(tree_node)
    @children.delete(tree_node)
  end

  def won?
    @node.won?
  end

  def deadlocked?
    DeadlockService.new(@node.to_level).run
  end

  def children
    NodeChildrenService.new(@node).run.nodes.collect do |node|
      TreeNode.new(node, @pushes + 1)
    end
  end

end
