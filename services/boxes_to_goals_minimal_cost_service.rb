# Get the minimal cost to put all the boxes to the goals
#
# No penalities: each box is directed to a different goal but there isn't
#                any other box in the way.
#
# use the hungarian algorithm (http://en.wikipedia.org/wiki/Hungarian_algorithm)

class BoxesToGoalsMinimalCostService

  def initialize(node, distances_for_zone)
    @node        = node
    @boxes_zone  = node.boxes_zone
    @goals_zone  = node.goals_zone
    @pusher_zone = node.pusher_zone
    @level       = Level.new(node)
    @distances   = distances_for_zone
  end

  def run
    matrix   = create_costs_matrix
    munkres  = Munkres.new(matrix)
    pairings = munkres.find_pairings
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

    boxes_positions.collect do |box_position|
      goals_positions.collect do |goal_position|
        @distances[pusher_position][box_position][goal_position]
      end
    end
  end
end
