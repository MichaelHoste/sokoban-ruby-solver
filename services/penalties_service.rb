# Find penalties list of current node

class PenaltiesService

  attr_reader :penalties

  def initialize(node, parent_solver = nil)
    @node          = node
    @parent_solver = parent_solver
    @penalties     = []

    initialize_distances
  end

  def run
    sub_nodes = box_zones_minus_1_box(@node.boxes_zone).collect do |sub_boxes_zone|
      Node.new([sub_boxes_zone, @node.goals_zone, build_pusher_zone(sub_boxes_zone, @node)])
    end

    sub_nodes.each do |sub_node|
      find_new_penalties(sub_node)
    end

    sub_nodes.each do |sub_node|
      penalty_value = real_pushes(sub_node) - estimate_pushes(sub_node)

      if penalty_value > 0 && !@penalties.any? { |p| p[:node] == sub_node }
        puts "-------"
        if @parent_solver
          puts @parent_solver.penalties.count + @penalties.count
        end
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

  # TODO optimize creation of pusherzone here!
  def build_pusher_zone(boxes_zone, node)
    level = node.to_level
    level.grid.each_with_index do |cell, i|
      if cell == '$' || cell == '*'
        level.grid[i] = 's'
      end
    end

    boxes_zone.positions_of_1.each do |position|
      level.grid[level.zone_pos_to_level_pos[position]] = '$'
    end

    Zone.new(level, Zone::PUSHER_ZONE)
  end

  def find_new_penalties(node)
    new_penalties = PenaltiesService.new(node, @parent_solver).run
    new_penalties.each do |new_penalty|
      @penalties << new_penalty
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
      # TODO is the order of penalties correct here?
      total_penalties = @parent_solver.penalties + @penalties
    end

    BoxesToGoalsMinimalCostService.new(node, @distances_for_zone, total_penalties).run
  end
end
