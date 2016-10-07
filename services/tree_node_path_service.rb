# Take a TreeNode and retrieve its (solution) path using the ancestors

class TreeNodePathService

  def initialize(tree_node)
    @tree_node = tree_node
  end

  def run
    nodes = successive_nodes_except_root
    path  = ""

    nodes.each_with_index do |node, i|
      current_level = root_level.clone             # | be sure the pusher is at the right position
      path.each_char { |c| current_level.move(c) } # /
      path += MovesBetweenLevelAndNodeService.new(current_level, node).run
    end

    path
  end

  private

  def root_level
    current_tree_node = @tree_node

    while current_tree_node.parent do
      current_tree_node = current_tree_node.parent
    end

    current_tree_node.node.level
  end

  def successive_nodes_except_root
    nodes             = []
    current_tree_node = @tree_node

    while current_tree_node.parent do
      nodes << current_tree_node.node
      current_tree_node = current_tree_node.parent
    end

    # logical order
    nodes.reverse
  end

end
