class Solver

  def initialize(level)
    @level              = level
    @node               = level.to_node
    @root               = TreeNode.new(@node)

    @deadlock_positions = DeadlockService.new(@level).run
    @deadlock_zone      = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone          = Zone.new(@level, Zone::CUSTOM_ZONE, { :number => 0 })
  end

  def run
    @list       = [@root]
    @open_nodes = HashTable.new

    i = 0
    while !@list.first.won? && !@list.empty?
      current = @list.shift

      current.children.each do |child|
        if !@open_nodes.present?(child.node)
          @open_nodes.add(child.node)

          if !deadlocked?(child.node)
            current.add_child(child)
            @list.unshift child
          end
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
