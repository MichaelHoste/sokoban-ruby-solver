# Find children of a node by pushing each box to reachable goals
# Doesn't modify level

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
    reachable_boxes_positions.each do |box_level_pos|

      # Compute distances for this box (assuming other boxes are not-movable)
      distances = compute_distances(@level, box_level_pos)

      # For each goal position...
      goals_positions(@level).each do |goal_level_pos|
        goal_distance = distances[goal_level_pos]

        if goal_distance != Float::INFINITY && goal_distance != 0
          child_level = @level.clone

          # ...remove original box
          remove_box_from_old_position(child_level, box_level_pos)

          # ...put the box on the goal
          child_level.grid[goal_level_pos] = '*'

          # ...remove original pusher
          remove_pusher_from_old_position(child_level)

          # ...place pusher next to box
          pusher_level_pos = get_new_pusher_position(distances, goal_level_pos)
          place_pusher_to_new_position(child_level, pusher_level_pos)

          @child_levels << {
            :level  => child_level,
            :pushes => goal_distance
          }
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

  def reachable_boxes_positions
    reachable_boxes_zone = @node.pusher_zone & @node.boxes_zone

    level_positions = []

    @level.zone_pos_to_level_pos.each_pair do |zone_pos, level_pos|
      if reachable_boxes_zone.bit_1?(zone_pos)
        level_positions << level_pos
      end
    end

    level_positions
  end

  def compute_distances(level, box_level_pos)
    BoxDistancesService.new(level, {
      :m => box_level_pos / @cols,
      :n => box_level_pos % @cols
    }).run(:for_level)
  end

  def goals_positions(level)
    positions = []

    level.zone_pos_to_level_pos.values.each do |level_pos|
      if '.+*'.include? level.grid[level_pos]
        positions << level_pos
      end
    end

    positions
  end

  def remove_box_from_old_position(level, level_pos)
    if level.grid[level_pos] == '*'
      level.grid[level_pos] = '.'
    else
      level.grid[level_pos] = 's'
    end
  end

  def remove_pusher_from_old_position(level)
    old_pusher_m = level.pusher[:m]
    old_pusher_n = level.pusher[:n]

    cell = level.read_pos(old_pusher_m, old_pusher_n)

    if cell == '+'
      level.write_pos(old_pusher_m, old_pusher_n, '.')
    elsif cell == '@'                                  # not "else" because it can be '*'
      level.write_pos(old_pusher_m, old_pusher_n, 's') # if pusher is on a goal and the box
    end                                                # has already been placed in it
  end

  def get_new_pusher_position(distances, goal_level_pos)
    goal_distance = distances[goal_level_pos]

    left   = goal_level_pos - 1
    right  = goal_level_pos + 1
    top    = goal_level_pos - @cols
    bottom = goal_level_pos + @cols

    # get array of [distance, index] sorted by smallest distance to biggest distance
    pusher_level_indexes = [left, right, top, bottom].collect do |neighbour_level_pos|
      distances[neighbour_level_pos]
    end.each_with_index.sort

    # find index of pusher position
    pusher_level_index = -1
    pusher_level_indexes.each do |index|
      if index[0] < goal_distance
        pusher_level_index = index[1]
        break
      end
    end

    [left, right, top, bottom][pusher_level_index]
  end

  def place_pusher_to_new_position(level, pusher_pos)
    if level.grid[pusher_pos] == '.'
      level.grid[pusher_pos] = '+'
    else
      level.grid[pusher_pos] = '@'
    end

    level.instance_variable_set(:@pusher, {
      :m => pusher_pos / @cols,
      :n => pusher_pos % @cols
    })
  end
end
