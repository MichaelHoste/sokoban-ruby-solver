# Find childs of a node (nodes created by 1 box push from this node)

class NodeChildsService

  def initialize(node)
    @node        = node
    @level       = node.level
    @cols        = @level.cols
    @rows        = @level.rows
    @pusher_zone = node.pusher_zone
    @goals_zone  = node.goals_zone
    @boxes_zone  = node.boxes_zone
  end

  def run
    @child_levels = []

    reachable_boxes_zone = @pusher_zone & @boxes_zone

    @level.zone_pos_to_level_pos.each_pair do |zone_pos, level_pos|
      if reachable_boxes_zone.bit_1?(zone_pos)
        ways_to_move_from(level_pos).each do |move|
          ahead_pos      = move[:ahead_pos]
          behind_pos     = move[:behind_pos]
          ahead_zone_pos = @level.level_pos_to_zone_pos[ahead_pos]

          correct_pusher_position = @pusher_zone.bit_1?(ahead_zone_pos) if !ahead_zone_pos.nil?
          pusher_position_not_box = !['$', '*'          ].include?(@level.grid[ahead_pos])
          nothing_behind_box      =  ['.', '@', '+', 's'].include?(@level.grid[behind_pos])

          if correct_pusher_position && pusher_position_not_box && nothing_behind_box
            new_level = @level.clone

            remove_box_from_old_position(new_level, level_pos)

            remove_pusher_from_old_position(new_level)

            place_pusher_to_new_position(new_level, level_pos)

            add_box_to_new_position(new_level, behind_pos)

            @child_levels << new_level
          end
        end
      end
    end

    self
  end

  def levels
    @child_levels
  end

  def nodes
    @child_nodes ||= @child_levels.collect { |level| Node.new(level) }
  end

  private

  def ways_to_move_from(level_pos)
    [
      {
        :ahead_pos  => level_pos - 1,
        :behind_pos => level_pos + 1
      },
      {
        :ahead_pos  => level_pos + 1,
        :behind_pos => level_pos - 1
      },
      {
        :ahead_pos  => level_pos - @level.cols,
        :behind_pos => level_pos + @level.cols
      },
      { :ahead_pos  => level_pos + @level.cols,
        :behind_pos => level_pos - @level.cols
      }
    ]
  end

  def remove_box_from_old_position(new_level, level_pos)
    if new_level.grid[level_pos] == '*'
      new_level.grid[level_pos] = '.'
    else
      new_level.grid[level_pos] = 's'
    end
  end

  def remove_pusher_from_old_position(new_level)
    old_pusher_m = new_level.pusher[:pos_m]
    old_pusher_n = new_level.pusher[:pos_n]

    if new_level.read_pos(old_pusher_m, old_pusher_n) == '+'
      new_level.write_pos(old_pusher_m, old_pusher_n, '.')
    else
      new_level.write_pos(old_pusher_m, old_pusher_n, 's')
    end
  end

  def place_pusher_to_new_position(new_level, level_pos)
    if new_level.grid[level_pos] == '.'
      new_level.grid[level_pos] = '+'
    else
      new_level.grid[level_pos] = '@'
    end

    new_level.send(:initialize_pusher_position)
  end

  def add_box_to_new_position(new_level, behind_pos)
    if new_level.grid[behind_pos] == '.'
      new_level.grid[behind_pos] = '*'
    else
      new_level.grid[behind_pos] = '$'
    end
  end

end
