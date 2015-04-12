class IdaStarSolver

  attr_reader :tries

  def initialize(level)
    @level = level
    @node  = level.to_node

    # Deadlocks
    @deadlock_positions = DeadlockService.new(@level).run

    # Distances for level
    distances_service   = LevelDistancesService.new(@level).run
    @distances_for_zone = distances_service.distances_for_zone

    @tries = 0
  end

  def run
    bound = estimate(@node)
    found = false

    while !found
      solver = AStarSolver.new(@level, bound, {
        :deadlock_positions => @deadlock_positions,
        :distances_for_zone => @distances_for_zone
      })

      found  = solver.run
      @tries = solver.tries

      bound  = bound + 1
    end

    return true
  end

  private

  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone
    ).run
  end
end
