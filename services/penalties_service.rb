# Find penalties list of current node

class PenaltiesService

  #attr_reader :penalties

  def initialize(node, parent_solver = nil)
    @node          = node
    @parent_solver = parent_solver

    initialize_distances
  end

  def run
    sub_nodes = SubNodesService.new(@node).run

    sub_nodes.each do |sub_node|
      if !@parent_solver.processed_penalties_nodes.include?(sub_node) # && !@penalties.any? { |p| p[:node] == sub_node }
        penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

        if penalty_value > 0
          puts "-------"
          # if @parent_solver
          puts @parent_solver.penalties.count
          # end
          puts sub_node.to_s
          puts penalty_value
          puts "-------"

          @parent_solver.penalties << {
            :node  => sub_node,
            :value => penalty_value
          }
        end

        @parent_solver.processed_penalties_nodes.add(sub_node)
      end
    end

    @parent_solver.penalties
  end

  private

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
    # if @parent_solver.nil?
    #   total_penalties = @penalties
    # else
    #   total_penalties = @parent_solver.penalties + @penalties
    # end

    BoxesToGoalsMinimalCostService.new(node, @distances_for_zone, @parent_solver.penalties).run
  end
end
