class AStarSolver < Solver

  def initialize(level_or_node, bound = Float::INFINITY, parent_solver = nil)
    initialize_level(level_or_node)

    @bound         = bound
    @parent_solver = parent_solver
    @found         = false
    @pushes        = Float::INFINITY
    @tries         = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_penalties_hashtable
    initialize_hashtable
    initialize_tree
  end

  def run
    @list = [@root]

    while !@list.empty? && !next_candidate.won?
      current = process_next_candidate

      current.find_children.each do |child|
        if !deadlocked?(child)
          find_new_penalties(child.node)
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
    @pushes = @found ? next_candidate.g : Float::INFINITY
  end

  private

  def initialize_hashtable
    @processed_nodes = HashTable.new
  end

  def initialize_tree
    @root   = TreeNode.new(@node)
    @root.h = estimate(@root.node)
  end

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

  def find_new_penalties(node)
    new_penalties = PenaltiesService.new(node, self).run
    new_penalties.each do |new_penalty|
      @penalties << new_penalty
    end
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
    if !@list.empty?
      @tries += 1
      if @tries % 100 == 0
        puts @tries
        puts @list.first.node.to_s
      end
    end
  end

end
