class IdaStarSolver

  attr_reader :found, :pushes, :tries

  def initialize(level_or_node, options = {})
    if level_or_node.is_a? Level
      @level = level_or_node
      @node  = level_or_node.to_node
    elsif level_or_node.is_a? Node
      @node  = level_or_node
      @level = level_or_node.to_level
    end

    # Deadlocks
    @deadlock_positions = options[:deadlock_positions] || DeadlockService.new(@level).run

    # Distances for level
    if options[:distances_for_zone]
      @distances_for_zone = options[:distances_for_zone]
    else
      distances_service    = LevelDistancesService.new(@level).run
      @distances_for_zone  = distances_service.distances_for_zone
    end

    @found  = false
    @pushes = Float::INFINITY
    @tries  = 0
  end

  def run
    @pushes = bound = estimate(@node)

    while !@found
      solver = AStarSolver.new(@level, bound, {
        :deadlock_positions => @deadlock_positions,
        :distances_for_zone => @distances_for_zone
      })
      solver.run

      @found =  solver.found
      @tries += solver.tries

      if !@found
        @pushes = bound = bound + 1
      end
    end
  end

  private

  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone
    ).run
  end
end
