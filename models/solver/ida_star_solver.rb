class IdaStarSolver < Solver

  def initialize(level_or_node, parent_solver = nil)
    initialize_level(level_or_node)

    @parent_solver = parent_solver
    @found         = false
    @pushes        = Float::INFINITY
    @loop_tries    = []
    @tries         = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
  end

  def run
    @pushes = bound = estimate(@node)
    i       = 0

    while !@found
      solver = AStarSolver.new(@level, bound, self)
      solver.run

      @found         =  solver.found
      @loop_tries[i] =  solver.tries
      @tries         += solver.tries

      if !@found
        @pushes = bound = bound + 1
        # TODO FIXME need to find a better solution to know where we really don't have any solution
        break if (i >= 10 && @loop_tries[i] == @loop_tries[i-10])
        i += 1
      end
    end

    @pushes = Float::INFINITY if !@found
  end

  private

end
