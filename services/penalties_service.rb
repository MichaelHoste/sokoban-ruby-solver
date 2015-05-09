# Find penalties list of current node
# Careful:
#  * When run without parent_solver, returns only the local penalties of node
#  * When run with parent_solver, returns also penalties of child nodes

class PenaltiesService

  def initialize(node, parent_solver = nil)
    @node          = node
    @parent_solver = parent_solver

    initialize_penalties
    initialize_distances
  end

  def run
    sub_nodes = SubNodesService.new(@node).run

    sub_nodes.each do |sub_node|
      if !@processed_penalties_nodes.include?(sub_node)
        penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

        if penalty_value > 0
          puts "add penalty"
          puts sub_node.to_s
          puts penalty_value
          puts '------'
          @penalties << {
            :node  => sub_node,
            :value => penalty_value
          }
        end

        @processed_penalties_nodes.add(sub_node)
      end
    end

    @penalties
  end

  private

  def initialize_penalties
    if @parent_solver.nil?
      @penalties                 = []
      @processed_penalties_nodes = HashTable.new
    else
      @penalties                 = @parent_solver.penalties
      @processed_penalties_nodes = @parent_solver.processed_penalties_nodes
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
