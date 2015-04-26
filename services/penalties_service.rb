# Find penalties of current node

class PenaltiesService

  def initialize(node)
    @node      = node
    @penalties = []
  end

  def run
    a = box_zones_minus_1_box(@node.boxes_zone).each do |sub_boxes_zone|
      sub_node = Node.new([sub_boxes_zone, @node.goals_zone, @node.pusher_zone])

      @penalties += PenaltiesService.new(sub_node).run

      # estimate
      solver = IdaStarSolver.new(sub_node)
      solver.run
      real = solver.pushes

      # real
      @distances_for_zone = LevelDistancesService.new(@node.to_level).run.distances_for_zone
      estimate = BoxesToGoalsMinimalCostService.new(sub_node, @distances_for_zone).run
    end

    return a
  end

  private

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
end
