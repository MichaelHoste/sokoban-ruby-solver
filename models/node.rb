class Node

  attr_reader :pusher_zone, :boxes_zone

  def initialize(pusher_zone, boxes_zone)
    @pusher_zone = pusher_zone
    @boxes_zone  = boxes_zone
  end

  # def solution?
  #   @boxes_zone == solver.goals_zone
  # end

end
