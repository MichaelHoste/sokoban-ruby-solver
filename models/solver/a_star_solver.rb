class AStarSolver < Solver

  def initialize(level_or_node, bound = Float::INFINITY, parent_solver = nil)
    initialize_level(level_or_node)

    @bound         = bound
    @parent_solver = parent_solver

    initialize_deadlocks
    initialize_distances

    @processed_nodes = HashTable.new

    @root   = TreeNode.new(@node)
    @root.h = estimate(@root.node)

    @found  = false
    @pushes = Float::INFINITY
    @tries  = 0
  end

  def run
    @list = [@root]

    while !@list.empty? && !next_candidate.won?
      current = process_next_candidate

      current.find_children.each do |child|
        if !deadlocked?(child)
          child.h = estimate(child.node)

          if child.f <= @bound && !processed?(child)
            add_to_waiting_list(child)
            add_to_tree(current, child)
          end
        end
      end

      print_log
    end

    @found  = !@list.empty? && next_candidate.won?
    @pushes = next_candidate.g if @found
  end

  private

  def next_candidate
    @list.first
  end

  def process_next_candidate
    @list.shift
  end

  def processed?(tree_node)
    @processed_nodes.include?(tree_node.node)
  end

  def deadlocked?(tree_node)
    (tree_node.node.boxes_zone & @deadlock_zone) != @null_zone
  end

  def add_to_waiting_list(tree_node)
    # Add to processed nodes
    @processed_nodes.add(tree_node.node)

    # add to waiting list
    index = @list.bsearch_lower_boundary do |item|
      [item.f, item.h] <=> [tree_node.f, tree_node.h]
    end

    if index.nil?
      @list << tree_node
    else
      @list.insert(index, tree_node)
    end
  end

  def add_to_tree(tree_node, child)
    tree_node.add_child(child)
  end

  def print_log
    @tries += 1
    if @tries % 100 == 0
      puts @tries
      puts @list.first.node.to_s
    end
  end

end
