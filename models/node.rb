class Node

  attr_accessor :boxes_zone, :goals_zone, :pusher_zone

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
    @boxes_zone.in? @goals_zone
  end

  def level
    @boxes_zone.level
  end

  def num_of_boxes
    @boxes_zone.positions_of_1.count
  end

  def to_s
    to_level.to_s
  end

  def to_level
    Level.new(self)
  end

  # A node that's "in" another node means that boxes and goals of the
  # node are a subset of the other node. Pusherzone is the opposite since
  # less boxes means bigger pusherzone.
  def in?(other_node)
    @pusher_zone.include?(other_node.pusher_zone) && other_node.boxes_zone.include?(@boxes_zone) && other_node.goals_zone.include?(@goals_zone)
  end

  def include?(other_node)
    other_node.pusher_zone.include?(@pusher_zone) && @boxes_zone.include?(other_node.boxes_zone) && @goals_zone.include?(other_node.goals_zone)
  end

  def ==(other_node)
    @boxes_zone == other_node.boxes_zone && @goals_zone == other_node.goals_zone && @pusher_zone == other_node.pusher_zone
  end

end
