# Get the minimal cost to put all the boxes to the goals
#
# Computation is made by directing each box to a different goal supposing
# there aren't any other boxes in the way.
#
# Penalty nodes/values are added afterward if needed.
#
# use the hungarian algorithm (http://en.wikipedia.org/wiki/Hungarian_algorithm)

require 'munkres'

class BoxesToGoalsMinimalCostService

  BIG_NUMBER = 10_000_000

  def initialize(node, distances_for_zone, penalties = PenaltiesList.new(1))
    @node        = node
    @boxes_zone  = node.boxes_zone
    @goals_zone  = node.goals_zone
    @pusher_zone = node.pusher_zone
    @level       = Level.new(node)
    @distances   = distances_for_zone
    @penalties   = penalties
  end

  def run
    matrix       = create_costs_matrix
    munkres      = Munkres.new(matrix)
    pairings     = munkres.find_pairings
    cost         = munkres.total_cost_of_pairing
    penalty_cost = 0

    # add penalty to cost
    temp_node = Node.new([@boxes_zone, @goals_zone, @pusher_zone])

    @penalties.reverse_each do |penalty_list|
      penalty_list.each do |penalty|
        if temp_node.include?(penalty[:node])
          penalty_cost += penalty[:value]
          temp_node.boxes_zone  = temp_node.boxes_zone  - penalty[:node].boxes_zone
          temp_node.pusher_zone = temp_node.pusher_zone | penalty[:node].pusher_zone
          # TODO: break the first loop if not enough boxes
        end
      end
    end

    # Fix because Munkres doesn't support Infinity
    {
      :cost         => cost                >= BIG_NUMBER ? Float::INFINITY : cost,
      :penalty_cost => penalty_cost        >= BIG_NUMBER ? Float::INFINITY : penalty_cost,
      :total        => cost + penalty_cost >= BIG_NUMBER ? Float::INFINITY : cost + penalty_cost
    }
  end

  private

  # Create matrix like this
  #
  #       goal1 goal2 goal3
  # box1    4     3     1
  # box2    3     6     4
  # box3    3     7     3
  def create_costs_matrix
    pusher_position = @pusher_zone.positions_of_1.first
    boxes_positions = @boxes_zone.positions_of_1
    goals_positions = @goals_zone.positions_of_1

    costs = boxes_positions.collect do |box_position|
      goals_positions.collect do |goal_position|
        distance = @distances[pusher_position][box_position][goal_position]

        # Fix because Munkres doesn't support Infinity
        distance == Float::INFINITY ? BIG_NUMBER : distance
      end
    end

    # Artificially prevent Munkres matrix to be wider than tall and crash (when less boxes than goals)
    costs += (1..goals_positions.count - boxes_positions.count).collect do |box_position|
      goals_positions.collect do |goal_position|
        0
      end
    end
  end
end
