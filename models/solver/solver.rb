class Solver

  attr_reader :level, :node, :found, :bound, :tries, :stack,
              :distances_for_zone, :deadlock_zone, :null_zone,
              :penalties, :processed_penalties

  attr_accessor :total_tries, :dead


  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone,
      @penalties
    ).run[:total]
  end

  private

  def initialize_level(level_or_node)
    if level_or_node.is_a? Level
      @level = level_or_node
      @node  = level_or_node.to_node
    elsif level_or_node.is_a? Node
      @node  = level_or_node
      @level = level_or_node.to_level
    end
  end

  def initialize_stack(parent_stack)
    @stack = parent_stack.dup
    @stack << self
  end

  def initialize_deadlocks
    if @stack.size == 1
      deadlock_positions = DeadlockService.new(@level).run
      @deadlock_zone     = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => deadlock_positions })
      @null_zone         = Zone.new(@level, Zone::CUSTOM_ZONE, { :number    => 0 })
    else
      @deadlock_zone = @stack.first.deadlock_zone
      @null_zone     = @stack.first.null_zone
    end
  end

  def initialize_distances
    if @stack.size == 1
      distances_service   = LevelDistancesService.new(@level).run
      @distances_for_zone = distances_service.distances_for_zone
    else
      @distances_for_zone = @stack.first.distances_for_zone
    end
  end

  def initialize_penalties
    if @stack.size == 1
      @penalties = PenaltiesList.new(@node.num_of_boxes)
    else
      @penalties = @stack.first.penalties
    end
  end

  def initialize_processed_penalties
    if @stack.size == 1
      @processed_penalties = HashTable.new(:big)
    else
     @processed_penalties = @stack.first.processed_penalties
    end
  end
end
