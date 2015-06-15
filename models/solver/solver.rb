class Solver

  attr_reader :level, :node, :found, :pushes, :tries, :parent_solver,
              :deadlock_positions, :distances_for_zone, :deadlock_zone, :null_zone,
              :penalties, :processed_penalties, :log

  attr_accessor :total_tries

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

  def initialize_deadlocks
    if @parent_solver.nil?
      @deadlock_positions = DeadlockService.new(@level).run
    else
      @deadlock_positions = @parent_solver.deadlock_positions
    end

    @deadlock_zone = Zone.new(@level, Zone::CUSTOM_ZONE, { :positions => @deadlock_positions })
    @null_zone     = Zone.new(@level, Zone::CUSTOM_ZONE, { :number    => 0 })
  end

  def initialize_distances
    if @parent_solver.nil?
      distances_service   = LevelDistancesService.new(@level).run
      @distances_for_zone = distances_service.distances_for_zone
    else
      @distances_for_zone = @parent_solver.distances_for_zone
    end
  end

  def initialize_penalties
    if @parent_solver.nil?
      @penalties = PenaltiesList.new(@node.num_of_boxes)
    else
      @penalties = @parent_solver.penalties
    end
  end

  def initialize_processed_penalties
    @processed_penalties = @parent_solver.nil? ? HashTable.new(:big) : @parent_solver.processed_penalties
  end

  def initialize_log
    @log = Logger.new(self)
  end

  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone,
      @penalties
    ).run[:total]
  end

  def elapsed_time
    (Time.now - @start_time) * 1000.0
  end
end
