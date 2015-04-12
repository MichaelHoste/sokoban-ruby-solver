class Solver

  attr_reader :tries

  def initialize(level)
    @level  = level
    @node   = level.to_node

    # Deadlocks
    @deadlock_positions = DeadlockService.new(@level).run
    @deadlock_zone      = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone          = Zone.new(@level, Zone::CUSTOM_ZONE, { :number    => 0 })

    # Distances for level
    distances_service    = LevelDistancesService.new(@level).run
    @distances_for_level = distances_service.distances_for_level
    @distances_for_zone  = distances_service.distances_for_zone

    # Hashtable
    @open_nodes   = HashTable.new
    @closed_nodes = HashTable.new

    @root   = TreeNode.new(@node)
    @root.h = estimate(@root)

    @tries = 0
  end

  def run
    @list = [@root]

    while !next_candidate.won? && !@list.empty?
      current = process_next_candidate

      current.find_children.each do |child|
        if !deadlocked?(child)
          estimate(child)

          if !waiting?(child) && !processed?(child)
            add_to_waiting_list(child)
            add_to_tree(current, child)
          end
        end
      end

      print_log
    end
  end

  private

  def next_candidate
    @list.first
  end

  def process_next_candidate
    candidate = @list.shift
    @open_nodes.remove(candidate.node)
    @closed_nodes.add(candidate.node)

    candidate
  end

  def waiting?(tree_node)
    @open_nodes.include?(tree_node.node)
  end

  def processed?(tree_node)
    @closed_nodes.include?(tree_node.node)
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
    # Add to open nodes
    @open_nodes.add(tree_node.node)

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
