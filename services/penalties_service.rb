# Find penalties of current node

class PenaltiesService

  attr_reader :penalties

  def initialize(node, parent_solver = nil)
    @node          = node
    @parent_solver = parent_solver
    @penalties     = []

    initialize_distances
  end

  def run
    box_zones_minus_1_box(@node.boxes_zone).each do |sub_boxes_zone|
      # create pusher_zone based on new sub_boxes_zone (only if removed box is on pusher_zone)
      sub_node = Node.new([sub_boxes_zone, @node.goals_zone, @node.pusher_zone])

      @penalties += PenaltiesService.new(sub_node).run

      penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

      if penalty_value > 0
        @penalties << {
          :node  => sub_node,
          :value => penalty_value
        }
      end
    end

    @penalties
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

  # Get new boxes zone from zone minus 1 box, each time
  # by removing 1 position from zone.
  # Only generate sub zone with at least 2 boxes.
  def box_zones_minus_1_box(zone)
    positions_of_1 = zone.positions_of_1

    if positions_of_1.count > 2
      positions_of_1.collect do |pos|
        sub_zone = zone.clone
        sub_zone.set_bit_0(pos)
        sub_zone
      end
    else
      []
    end
  end

  def real_pushes(node)
    solver = IdaStarSolver.new(node, @parent_solver)
    solver.run
    solver.pushes
  end

  def estimate_pushes(node)
    BoxesToGoalsMinimalCostService.new(node, @distances_for_zone, @penalties).run
  end
end
