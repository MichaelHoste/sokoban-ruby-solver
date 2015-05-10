class IdaStarSolver < Solver

  def initialize(level_or_node, parent_solver = nil, check_penalties = true)
    initialize_level(level_or_node)

    @parent_solver   = parent_solver
    @check_penalties = check_penalties
    @found           = false
    @pushes          = Float::INFINITY
    @loop_tries      = []
    @tries           = 0

    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_penalties_hashtable

    @start_time      = Time.now
  end

  def run
    @pushes = bound = estimate(@node)
    i       = 0

    while !@found && bound != Float::INFINITY
      puts "START IDA with bound: #{bound}" if @parent_solver.nil?
      puts @level.to_s

      solver = AStarSolver.new(@level, self, bound, @check_penalties)
      solver.run

      @found         =  solver.found
      @loop_tries[i] =  solver.tries
      @tries         += solver.tries

      if !@found
        @pushes = bound = [estimate(@node), bound + 1].max
        # TODO FIXME need to find a better solution to know where we really don't have any solution
        break if (i >= 100 && @loop_tries[i] == @loop_tries[i-100])
        i += 1
      end
    end

    puts "#{elapsed_time.to_i} ms (#{i+1} loop(s))"

    @pushes = Float::INFINITY if !@found
  end

  private

end
