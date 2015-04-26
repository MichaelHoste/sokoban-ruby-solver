class IdaStarSolver < Solver

  def initialize(level_or_node, parent_solver = nil)
    if level_or_node.is_a? Level
      @level = level_or_node
      @node  = level_or_node.to_node
    elsif level_or_node.is_a? Node
      @node  = level_or_node
      @level = level_or_node.to_level
    end

    @parent_solver = parent_solver
    @found         = false
    @pushes        = Float::INFINITY
    @tries         = 0

    initialize_deadlocks
    initialize_distances
  end

  def run
    @pushes = bound = estimate(@node)

    while !@found
      solver = AStarSolver.new(@level, bound, self)
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
