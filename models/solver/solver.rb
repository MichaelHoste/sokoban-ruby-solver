class Solver

  attr_reader :found, :pushes, :tries,
              :deadlock_positions, :distances_for_zone, :deadlock_zone, :null_zone

  def initialize
  end

  private

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

  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone
    ).run
  end
end
