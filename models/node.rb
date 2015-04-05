class Node

  attr_reader :boxes_zone, :goals_zone, :pusher_zone

  def initialize(level_or_zones)
    if level_or_zones.is_a? Level
      level        = level_or_zones
      @boxes_zone  = Zone.new(level, Zone::BOXES_ZONE)
      @goals_zone  = Zone.new(level, Zone::GOALS_ZONE)
      @pusher_zone = Zone.new(level, Zone::PUSHER_ZONE)
    elsif level_or_zones.is_a? Array
      zones        = level_or_zones
      @boxes_zone  = zones[0]
      @goals_zone  = zones[1]
      @pusher_zone = zones[2]
    end
  end

  def won?
    @boxes_zone == @goals_zone
  end

  def level
    boxes_zone.level
  end

  def to_s
    Level.new(self).to_s
  end

  def ==(other_node)
    a = boxes_zone  == other_node.boxes_zone
    b = goals_zone  == other_node.goals_zone
    c = pusher_zone == other_node.pusher_zone
    a && b && c
  end

end
