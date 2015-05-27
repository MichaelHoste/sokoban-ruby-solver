# Find penalties list of current node
# Careful:
#  * When run without parent_solver, returns only the local penalties of node
#  * When run with parent_solver, returns also penalties of child nodes

class PenaltiesService

  attr_reader :penalties

  def initialize(node, parent_solver = nil)
    @node          = node
    @parent_solver = parent_solver

    initialize_penalties
    initialize_processed_penalties
    initialize_distances
  end

  def run
    found_new_penalty = false

    sub_nodes = SubNodesService.new(@node).run

    sub_nodes.each do |sub_node|
      if !@processed_penalties.include?(sub_node)
        @processed_penalties << sub_node

        penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

        if penalty_value > 0
          @penalties << {
            :node  => sub_node,
            :value => penalty_value
          }

          found_new_penalty = true

          @parent_solver.log.print_penalty(@penalties.last) if !@parent_solver.nil?

          puts "new penalty (#{@penalties.size})"
          puts sub_node.to_s
          puts "value: #{penalty_value}"
          puts "-----------------------------------"
        end
      end
    end

    found_new_penalty
  end

  private

  def initialize_penalties
    if @parent_solver.nil?
      @penalties = []
    else
      @penalties = @parent_solver.penalties
    end
  end

  def initialize_processed_penalties
    if @parent_solver.nil?
      @processed_penalties = HashTable.new
    else
      @processed_penalties = @parent_solver.processed_penalties
    end
  end

  def initialize_distances
    if @parent_solver.nil?
      distances_service   = LevelDistancesService.new(@node.to_level).run
      @distances_for_zone = distances_service.distances_for_zone
    else
      @distances_for_zone = @parent_solver.distances_for_zone
    end
  end

  def real_pushes(node)
    solver = IdaStarSolver.new(node, @parent_solver)
    solver.run

    if !@parent_solver.nil?
      @parent_solver.total_tries += solver.total_tries
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
