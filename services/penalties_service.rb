# Find penalties list of current node

class PenaltiesService

  attr_reader :penalties, :stack, :distances_for_zone, :deadlock_zone, :null_zone,
              :processed_penalties

  def initialize(node, stack = [], bound = Float::INFINITY)
    @node  = node
    @level = node.to_level
    @bound = bound

    initialize_stack(stack)
    initialize_deadlocks
    initialize_distances
    initialize_penalties
    initialize_processed_penalties
  end

  def run
    found_new_penalty = false

    sub_nodes = SubNodesService.new(@node).run

    sub_nodes.each do |sub_node|
      if !@processed_penalties.include?(sub_node) # && sub_node.num_of_boxes <= 3
        @processed_penalties << sub_node

        real     = real_pushes(sub_node)
        estimate = estimate_pushes(sub_node)

        if real - estimate[:total] > 0
          penalty = {
            :node  => sub_node,
            :value => estimate[:penalty_cost] + (real - estimate[:total])
          }
          @penalties << penalty

          found_new_penalty = true

          puts "new penalty (#{@penalties.size})"
          puts penalty[:node].to_s
          puts "value: #{penalty[:value]}"
          puts "-----------------------------------"
        end
      end
    end

    found_new_penalty
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

  def estimate_pushes(node)
    BoxesToGoalsMinimalCostService.new(
      node,
      @distances_for_zone,
      @penalties
    ).run
  end
end
