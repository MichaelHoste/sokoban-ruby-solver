class Node

  attr_reader :boxes_zone, :pusher_zone

  def initialize(boxes_zone, pusher_zone)
    @boxes_zone  = boxes_zone
    @pusher_zone = pusher_zone
  end

  # def solution?
  #   @boxes_zone == solver.goals_zone
  # end

end
