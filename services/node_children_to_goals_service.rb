# Find children of a node by pushing each box to reachable goals

class NodeChildrenToGoalsService

  def initialize(node)
    @node        = node
    @level       = node.level
    @cols        = @level.cols
    @rows        = @level.rows
  end

  def run
    @child_levels = []

    # for each reachable box
    reachable_boxes.values.each do |box_level_pos|

      # Create level with one box and other boxes transformed as walls
      restricted_level = create_restricted_level(box_level_pos)

      # prepare level for distances
      level_for_distances = restricted_level.clone

      level_for_distances.grid.each_with_index do |cell, i|
        if cell == '.'
          level_for_distances.grid[i] = 's'
        elsif cell == '+'
          level_for_distances.grid[i] = '@'
        elsif cell == '*'
          level_for_distances.grid[i] = '$'
        end
      end

      # Get distances from this box to other positions
      distances = BoxDistancesService.new(level_for_distances).run(:for_zone)

      # For each goal position...
      restricted_level.zone_pos_to_level_pos.each_pair do |restricted_zone_pos, restricted_level_pos|
        if ['.', '+', '*'].include? restricted_level.grid[restricted_level_pos]
          goal_distance = distances[restricted_zone_pos]

          if goal_distance != Float::INFINITY && goal_distance != 0
            child_level = @level.clone

            # ...remove original box
            if child_level.grid[box_level_pos] == '*'
              child_level.grid[box_level_pos] = '.'
            else
              child_level.grid[box_level_pos] = 's'
            end

            # ...put the box on the goal
            child_level.grid[restricted_level_pos] = '*'

            # ...remove original pusher
            old_pusher_m = child_level.pusher[:pos_m]
            old_pusher_n = child_level.pusher[:pos_n]

            if child_level.read_pos(old_pusher_m, old_pusher_n) == '+'
              child_level.write_pos(old_pusher_m, old_pusher_n, '.')
            elsif child_level.read_pos(old_pusher_m, old_pusher_n) == '@'
              child_level.write_pos(old_pusher_m, old_pusher_n, 's')
            end

            # ...place pusher next to box
            left   = restricted_level_pos - 1
            right  = restricted_level_pos + 1
            top    = restricted_level_pos - @cols
            bottom = restricted_level_pos + @cols

            pusher_level_indexes = [left, right, top, bottom].collect do |neighbour_level_pos|
              neighbour_zone_pos = restricted_level.level_pos_to_zone_pos[neighbour_level_pos]
              if !neighbour_zone_pos.nil?
                distances[neighbour_zone_pos]
              else
                Float::INFINITY
              end
            end.each_with_index.sort.reverse

            pusher_level_index = -1
            pusher_level_indexes.each do |index|
              if index[0] < goal_distance
                pusher_level_index = index[1]
                break
              end
            end

            pusher_level_pos = [left, right, top, bottom][pusher_level_index]

            if child_level.grid[pusher_level_pos] == '.'
              child_level.grid[pusher_level_pos] = '+'
            else
              child_level.grid[pusher_level_pos] = '@'
            end

            child_level.send(:initialize_pusher_position)

            @child_levels << {
              :level  => child_level,
              :pushes => goal_distance
            }
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
    @child_nodes ||= @child_levels.collect do |level|
      {
        :node   => Node.new(level[:level]),
        :pushes => level[:pushes]
      }
    end
  end

  private

  def reachable_boxes
    reachable_boxes_zone = @node.pusher_zone & @node.boxes_zone

    positions = {}

    @level.zone_pos_to_level_pos.each_pair do |zone_pos, level_pos|
      if reachable_boxes_zone.bit_1?(zone_pos)
        positions[zone_pos] = level_pos
      end
    end

    positions
  end

  def create_restricted_level(box_level_pos)
    restricted_level = @level.clone

    # Create level with one box and transform other boxes to walls
    restricted_level.grid.each_with_index do |cell, i|
      if ['$', '*'].include?(cell) && box_level_pos != i
        restricted_level.grid[i] = '#'
      end
    end

    # inside of levels can be smaller than before
    restricted_level.send(:initialize_floor)
    restricted_level.send(:initialize_level_zone_positions)

    restricted_level
  end

  # def remove_box_from_old_position(new_level, level_pos)
  #   if new_level.grid[level_pos] == '*'
  #     new_level.grid[level_pos] = '.'
  #   else
  #     new_level.grid[level_pos] = 's'
  #   end
  # end

  # def remove_pusher_from_old_position(new_level)
  #   old_pusher_m = new_level.pusher[:pos_m]
  #   old_pusher_n = new_level.pusher[:pos_n]

  #   if new_level.read_pos(old_pusher_m, old_pusher_n) == '+'
  #     new_level.write_pos(old_pusher_m, old_pusher_n, '.')
  #   else
  #     new_level.write_pos(old_pusher_m, old_pusher_n, 's')
  #   end
  # end

  # def place_pusher_to_new_position(new_level, level_pos)
  #   if new_level.grid[level_pos] == '.'
  #     new_level.grid[level_pos] = '+'
  #   else
  #     new_level.grid[level_pos] = '@'
  #   end

  #   new_level.send(:initialize_pusher_position)
  # end

  # def add_box_to_new_position(new_level, behind_pos)
  #   if new_level.grid[behind_pos] == '.'
  #     new_level.grid[behind_pos] = '*'
  #   else
  #     new_level.grid[behind_pos] = '$'
  #   end
  # end

end
