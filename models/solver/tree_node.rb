class TreeNode

  attr_reader   :node, :children, :g
  attr_accessor :parent, :h

  def initialize(node, parent = nil, g = 0)
    @node     = node
    @parent   = parent
    @children = []
    @g        = g
    @h        = Float::INFINITY
  end

  def add_child(tree_node)
    @children << tree_node
    tree_node.parent = self
  end

  def remove_child(tree_node)
    @children.delete(tree_node)
    tree_node.parent = nil
  end

  def f
    @g + @h
  end

  def won?
    @node.won?
  end

  def path
    TreeNodePathService.new(self).run
  end

  # level with pusher at correct position (by opposition to level)
  # (quite time consuming since it must replay solution path to get pusher position)
  def current_level
    level = node.level.clone

    path.each_char do |c|
      level.move(c)
    end

    level
  end

  def find_children
    direct_children = NodeChildrenService.new(@node).run.nodes.collect do |node|
      TreeNode.new(node, self, @g + 1)
    end

    goal_children = NodeChildrenToGoalsService.new(@node).run.nodes.collect do |children|
      TreeNode.new(children[:node], self, @g + children[:pushes])
    end

    # TODO test perfs without this line.
    direct_children.concat(goal_children).uniq { |treenode| treenode.node }
  end

end
