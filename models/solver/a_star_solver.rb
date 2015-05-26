class AStarSolver < Solver

  attr_reader :bound

  def initialize(level_or_node, parent_solver = nil, bound = Float::INFINITY, check_penalties = true)
    initialize_level(level_or_node)

    @bound           = bound
    @parent_solver   = parent_solver
    @check_penalties = check_penalties
    @found           = false
    @pushes          = Float::INFINITY
    @tries           = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_processed_penalties
    initialize_processed
    initialize_waiting
    initialize_tree
    initialize_log

    @start_time      = Time.now
  end

  def run
    @list = [@root]

    while !@list.empty? && !next_candidate.won?
      current   = extract_next_candidate

      found     = find_penalties(current.node)
      current.h = estimate(current.node) if found

      if current.f <= @bound && !processed?(current)
        current.find_children.each do |child|
          if !deadlocked?(child) && !processed?(child) && !waiting?(child)
            child.h = estimate(child.node)

            if child.f <= @bound
              add_to_waiting_list(child)
              add_to_tree(current, child)
            end
          end
        end

        process(current)
      end

      print_log
    end

    @found  = !@list.empty? && next_candidate.won?
    @pushes = @found ? next_candidate.g : Float::INFINITY
  end

  private

  def initialize_processed
    @processed_nodes = HashTable.new
  end

  def initialize_waiting
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
    has_penalty      = @penalties.include?(tree_node.node)

    # TODO optimize to not loop through every penalty
    if has_penalty
      has_infinite_penalty = !@penalties.any? do |penalty|
        penalty[:node] == tree_node.node && penalty[:value] == Float::INFINITY
      end.empty?
    end

    one_box_deadlock || (has_penalty && has_infinite_penalty)
  end

  def find_penalties(node)
    if @check_penalties
      if !@processed_penalties.include?(node)
        return PenaltiesService.new(node, self).run
      end
    end
    return false
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

  def print_log
    if !@list.empty?
      @tries += 1
      if @tries % 100 == 0 && (@parent_solver.nil? || @parent_solver.parent_solver.nil?)
        puts @tries
        #puts @list.first.node.to_s
      end
    end
  end

end
