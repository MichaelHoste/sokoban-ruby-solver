class IdaStarSolver < Solver

  def initialize(level_or_node, stack = [], check_penalties = true)
    initialize_level(level_or_node)
    initialize_stack(stack)

    @bound           = 0
    @check_penalties = check_penalties
    @dead            = false
    @found           = false
    @loop_tries      = []
    @tries           = 0
    @total_tries     = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_processed_penalties
  end

  def run
    @bound = estimate(@node)
    i = 0

    while !@found && @bound != Float::INFINITY
      solver = AStarSolver.new(@level, @stack, @bound, @check_penalties)
      solver.run

      @found         =  solver.found
      @loop_tries[i] =  solver.tries
      @tries         += solver.tries
      @total_tries   += solver.total_tries

      if !@found
        @bound = [estimate(@node), @bound + 1].max
        # TODO FIXME need to find a better solution to know where we really don't have any solution
        break if (i >= 100 && @loop_tries[i] == @loop_tries[i-100])
        i += 1
      end
    end

    # TODO Remove when better solution to find infinite
    @bound = Float::INFINITY if !@found
  end

  def pushes
    @bound
  end

  private

end
