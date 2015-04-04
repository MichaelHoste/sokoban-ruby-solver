class MinimalBoxesToGoalsDistanceService

  def initialize(node, distances_for_zone)
    @node        = node
    @boxes_zone  = node.boxes_zone
    @goals_zone  = node.goals_zone
    @pusher_zone = node.pusher_zone
    @level       = Level.new(node)
    @distances   = distances_for_zone
  end

  def run
    pusher_position = pusher_zone.positions_of_1.first
    boxes_positions = boxes_zone.positions_of_1
    goals_positions = goals_zone.positions_of_1

    # Create matrix like this
    #
    #       goal1 goal2 goal3
    # box1    4     3     1
    # box2    3     6     4
    # box3    3     7     3
  end

  private

end
