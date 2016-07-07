# Create every sub nodes from a node
# (node with every box combination of n-1, n-2 ... 2 boxes)

class SubNodesService

  def initialize(node)
    @node        = node
    @level       = node.to_level

    @empty_level = @level.clone

    @empty_level.grid.tr!('$*', 's')
  end

  def run
    # Create sub boxes zones
    sub_boxes_zones = sub_boxes_zones(@node.boxes_zone)

    # Create sub boxes nodes
    sub_boxes_zones.collect do |sub_boxes_zone|
      Node.new([sub_boxes_zone, @node.goals_zone, build_pusher_zone(sub_boxes_zone)])
    end
  end

  private

  def sub_boxes_zones(boxes_zone)
    zone_size       = boxes_zone.positions_of_1.count
    sub_boxes_zones = [[boxes_zone]] # create temp array with
                                     # a[0] the original zone with n boxes
                                     # a[1] sub_zones with n-1 boxes
                                     # a[2] sub_zones with n-2 boxes
                                     # etc.

    # '3' because we don't take sub_boxes_zones with only 1 box
    (0..zone_size-3).each do |i|
      sub_boxes_zones[i+1] = []

      sub_boxes_zones[i].each do |sub_boxes_zone|
        sub_boxes_zones[i+1].concat(boxes_zones_minus_1_box(sub_boxes_zone))
      end

      sub_boxes_zones[i+1].uniq! { |zone| zone.to_binary }
    end

    # concatenate the array and remove original boxes_zone
    sub_boxes_zones.flatten.drop(1).reverse!
  end

  def boxes_zones_minus_1_box(boxes_zone)
    positions_of_1 = boxes_zone.positions_of_1

    if positions_of_1.count > 1
      positions_of_1.collect do |pos|
        sub_boxes_zone = boxes_zone.clone
        sub_boxes_zone.set_bit_0(pos)
        sub_boxes_zone
      end
    else
      []
    end
  end

  # TODO optimize creation of pusherzone here!
  def build_pusher_zone(boxes_zone)
    new_level = @empty_level.clone

    boxes_zone.positions_of_1.each do |position|
      level_pos                 = new_level.zone_pos_to_level_pos[position]
      new_level.grid[level_pos] = '$'
    end

    Zone.new(new_level, Zone::PUSHER_ZONE)
  end

end
