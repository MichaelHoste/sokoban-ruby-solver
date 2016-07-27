# Find penalties list of current node

class PenaltiesService

  attr_reader :level, :node, :penalties, :bound, :stack, :distances_for_zone,
              :deadlock_zone, :null_zone, :processed_penalties

  attr_accessor :dead

  def initialize(node, stack = [], bound = Float::INFINITY)
    @node  = node
    @level = node.to_level
    @bound = bound
    @dead  = false

    initialize_stack(stack)
    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_processed_penalties

    @bound = estimate(@node) if @bound == Float::INFINITY
  end

  def run
    sub_nodes = SubNodesService.new(@node).run

    sub_nodes.each do |sub_node|
      if !@dead && !@processed_penalties.include?(sub_node) && sub_node.num_of_boxes <= 5
        @processed_penalties << sub_node

        real       = real_pushes(sub_node)
        estimation = BoxesToGoalsMinimalCostService.new(sub_node, @distances_for_zone, @penalties).run

        if real - estimation[:total] > 0
          penalty = {
            :node  => sub_node,
            :value => estimation[:penalty_cost] + (real - estimation[:total]) # old penalties cost + new difference found
          }
          @penalties << penalty

          flag_dead_branches

          puts "new penalty (#{@penalties.size})"
          puts penalty[:node].to_s
          puts "value: #{penalty[:value]}"
          puts "-----------------------------------"
        end
      end
    end
  end

  def estimate(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone,
      @penalties
    ).run[:total]
  end

  private

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

  def real_pushes(node)
    solver = IdaStarSolver.new(node, @stack)
    solver.run

    if @stack.size && @stack.first.class != PenaltiesService
      @stack.first.total_tries += solver.total_tries
    end

    solver.pushes
  end

  def flag_dead_branches
    found_dead_branch = false

    @stack.each do |step|
      if found_dead_branch
        step.dead = true
      else
        new_estimation = step.estimate(step.node)

        if new_estimation > step.bound
          step.dead         = true
          found_dead_branch = true
        end
      end
    end
  end
end
