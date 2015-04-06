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
    childs = []

    reachable_boxes_zone = @pusher_zone & @boxes_zone

    @level.zone_pos_to_level_pos.each_pair do |zone_pos, level_pos|
      if reachable_boxes_zone.bit_1?(zone_pos)
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
        ].each do |move|
          ahead_pos  = move[:ahead_pos]
          behind_pos = move[:behind_pos]

          not_wall                = @level.grid[ahead_pos] != '#'
          correct_pusher_position = @pusher_zone.bit_1?(@level.level_pos_to_zone_pos[ahead_pos]) if not_wall
          nothing_behind_box      = ['.', '@', '+', 's'].include?(@level.grid[behind_pos])

          if not_wall && correct_pusher_position && nothing_behind_box
            new_level = @level.clone

            # Remove box from old position
            if new_level.grid[level_pos] == '*'
              new_level.grid[level_pos] = '.'
            else
              new_level.grid[level_pos] = 's'
            end

            # remove pusher from old position
            old_pusher_m = new_level.pusher[:pos_m]
            old_pusher_n = new_level.pusher[:pos_n]

            if new_level.read_pos(old_pusher_m, old_pusher_n) == '+'
              new_level.write_pos(old_pusher_m, old_pusher_n, '.')
            else
              new_level.write_pos(old_pusher_m, old_pusher_n, 's')
            end

            # place pusher to new position
            if new_level.grid[level_pos] == '.'
              new_level.grid[level_pos] = '+'
            else
              new_level.grid[level_pos] = '@'
            end

            new_level.send(:initialize_pusher_position)

            # Add box to new position
            if new_level.grid[behind_pos] == '.'
              new_level.grid[behind_pos] = '*'
            else
              new_level.grid[behind_pos] = '$'
            end

            childs << new_level
          end
        end
      end
    end

    childs
  end

  private

end
