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
      # TODO optimize creation of pusherzone here!
      sub_node = Node.new([sub_boxes_zone, @node.goals_zone, Zone.new(@node.to_level, Zone::PUSHER_ZONE)])

      new_penalties = PenaltiesService.new(sub_node, @parent_solver).run
      new_penalties.each do |new_penalty|
        @penalties << new_penalty
      end

      penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

      if penalty_value > 0
        puts "-------"
        puts @parent_solver.penalties.count + @penalties.count
        puts sub_node.to_s
        puts penalty_value
        puts "-------"

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
    if @parent_solver.nil?
      total_penalties = @penalties
    else
      total_penalties = @parent_solver.penalties + @penalties
    end

    BoxesToGoalsMinimalCostService.new(node, @distances_for_zone, total_penalties).run
  end
end
