class Solver

  # open set = waiting
  # closed set = processed

  attr_reader :tries

  def initialize(level)
    @level = level
    @node  = level.to_node
    @root  = TreeNode.new(@node)

    # Deadlocks
    @deadlock_positions = DeadlockService.new(@level).run
    @deadlock_zone      = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone          = Zone.new(@level, Zone::CUSTOM_ZONE, { :number => 0 })

    # Hashtable
    @open_nodes   = HashTable.new
    @closed_nodes = HashTable.new

    @tries = 0
  end

  def run
    @list = [@root]

    while !next_candidate.won? && !@list.empty?
      current = process_next_candidate

      current.find_children.each do |child|
        if !waiting?(child) && !processed?(child) && !deadlocked?(child)
          add_to_waiting_list(child)
          add_to_tree(current, child)
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

  def add_to_waiting_list(tree_node)
    @open_nodes.add(tree_node.node)
    @list.unshift(tree_node)
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
