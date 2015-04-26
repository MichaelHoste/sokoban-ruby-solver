class IdaStarSolver < Solver

  def initialize(level_or_node, parent_solver = nil)
    initialize_level(level_or_node)

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

end
