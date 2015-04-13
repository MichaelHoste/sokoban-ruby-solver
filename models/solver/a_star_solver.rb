class AStarSolver

  attr_reader :found, :pushes, :tries

  def initialize(level_or_node, bound = Float::INFINITY, options = {})
    if level_or_node.is_a? Level
      @level = level_or_node
      @node  = level_or_node.to_node
    elsif level_or_node.is_a? Node
      @node  = level_or_node
      @level = level_or_node.to_level
    end

    @bound = bound

    # Deadlocks
    @deadlock_positions = options[:deadlock_positions] || DeadlockService.new(@level).run
    @deadlock_zone      = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone          = Zone.new(@level, Zone::CUSTOM_ZONE, { :number    => 0 })

    # Distances for level
    if options[:distances_for_zone]
      @distances_for_zone = options[:distances_for_zone]
    else
      distances_service    = LevelDistancesService.new(@level).run
      @distances_for_zone  = distances_service.distances_for_zone
    end

    # Hashtable
    @processed_nodes = HashTable.new

    @root   = TreeNode.new(@node)
    @root.h = estimate(@root)

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
          estimate(child)

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

  def estimate(tree_node)
    tree_node.h = BoxesToGoalsMinimalCostService.new(
      tree_node.node,
      @distances_for_zone
    ).run
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
