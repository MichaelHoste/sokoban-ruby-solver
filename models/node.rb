class Node

  attr_reader :boxes_zone, :goals_zone, :pusher_zone

  def initialize(boxes_zone, goals_zone, pusher_zone)
    @boxes_zone  = boxes_zone
    @goals_zone  = goals_zone
    @pusher_zone = pusher_zone
  end

  def solution?
    @boxes_zone == @goals_zone
  end

  def level
    boxes_zone.level
  end

end
