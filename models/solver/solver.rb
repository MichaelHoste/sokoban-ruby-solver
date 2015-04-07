class Solver

  def initialize(level)
    @level              = level
    @node               = level.to_node
    @root               = TreeNode.new(@node)

    @list               = [@root]
    @open_nodes         = {}

    @deadlock_positions = DeadlockService.new(@level).run
    @deadlock_zone      = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone          = Zone.new(@level, Zone::CUSTOM_ZONE, { :number => 0 })
  end

  def run
    i = 0
    while !@list.first.won? && !@list.empty?
      current = @list.shift

      current.children.each do |child|
        if !deadlocked?(child.node) && !@open_nodes.has_key?(child.node.id)
          current.add_child(child)
          @open_nodes[child.node.id] = child.node
          @list.unshift(child)
        end
      end
      i += 1
      if i % 100 == 0
        puts i
        puts @list.first.node.to_s
      end
    end

    puts @list.first.node.to_s
  end

  private

  def deadlocked?(node)
    (node.boxes_zone & @deadlock_zone) != @null_zone
  end

end
