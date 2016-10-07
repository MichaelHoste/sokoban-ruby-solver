class AStarSolver < Solver

  def initialize(level_or_node, stack = [], bound = Float::INFINITY, check_penalties = true)
    initialize_level(level_or_node)
    initialize_stack(stack)

    @bound           = bound
    @check_penalties = check_penalties
    @dead            = false
    @found           = false
    @tries           = 0
    @total_tries     = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_processed_penalties
    initialize_processed_nodes
    initialize_waiting_nodes
    initialize_tree
  end

  def run
    @list = [@root]

    while !@dead && !@list.empty? && !next_candidate.won?
      current = extract_next_candidate

      find_penalties(current.node)
      current.h = estimate(current.node)

      if !@dead && current.f <= @bound && !processed?(current)
        current.find_children.each do |child|
          if !@dead && !deadlocked?(child) && !processed?(child) && !waiting?(child)
            child.h = estimate(child.node)

            if child.f <= @bound
              add_to_waiting_list(child)
              add_to_tree(current, child)
            end
          end
        end

        process(current)
      end

      @tries       += 1 if !@list.empty?
      @total_tries += 1 if !@list.empty?
    end

    @found = !@list.empty? && next_candidate.won?

    if @found
      @bound              = next_candidate.g
      @solution_tree_node = next_candidate
    else
      @bound              = Float::INFINITY
      @solution_tree_node = nil
    end

    @solution_tree_node
  end

  def pushes
    @bound
  end

  private

  def initialize_processed_nodes
    @processed_nodes = HashTable.new
  end

  def initialize_waiting_nodes
    @waiting_nodes = HashTable.new
  end

  def initialize_tree
    @root   = TreeNode.new(@node)
    @root.h = estimate(@root.node)
  end

  def next_candidate
    @list.first
  end

  def extract_next_candidate
    @list.shift
  end

  def process(tree_node)
    @waiting_nodes.remove(tree_node.node)
    @processed_nodes.add(tree_node.node)
  end

  def processed?(tree_node)
    @processed_nodes.include?(tree_node.node)
  end

  def waiting?(tree_node)
    @waiting_nodes.include?(tree_node.node)
  end

  def deadlocked?(tree_node)
    one_box_deadlock = (tree_node.node.boxes_zone & @deadlock_zone) != @null_zone
  end

  def find_penalties(node)
    if @check_penalties
      if !@processed_penalties.include?(node)
        PenaltiesService.new(node, @stack, @bound).run
      end
    end
  end

  def add_to_waiting_list(tree_node)
    # Add to waiting nodes
    @waiting_nodes.add(tree_node.node)

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

end
