# Take a level (with exact pusher position) and a node (without exact pusher
# position) and returns path of moves/pushes between them.
#
# For this service to work, only one box must have been pushed
# between level and node (can be multiple pushes)

class MovesBetweenLevelAndNodeService

  def initialize(level, node)
    @level = level
    @node  = node
    @cols  = level.cols
    @rows  = level.rows
  end

  def run
    box_before, box_after = box_before_and_after_positions(@level, @node.to_level)

    path = pushes_path(@level, box_before, box_after)

    complete_pushes_path_with_moves(@level, box_before, path)
  end

  private

  def box_before_and_after_positions(level1, level2)
    box_before = nil
    box_after  = nil

    (0..@rows-1).each do |m|
      (0..@cols-1).each do |n|
        level1_cell = level1.read_pos(m, n)
        level2_cell = level2.read_pos(m, n)

        if level1_cell != level2_cell
          if '*$'.include?(level1_cell) && !'*$'.include?(level2_cell)
            box_before = { :m => m, :n => n }
          elsif !'*$'.include?(level1_cell) && '*$'.include?(level2_cell)
            box_after  = { :m => m, :n => n }
          end
        end

        break if box_before && box_after
      end
      break if box_before && box_after
    end

    [box_before, box_after]
  end

  # travel path in reverse (from box_after to initial level using dijkstra in BoxDistancesService)
  def pushes_path(level, box_before, box_after)
    new_level = level_with_1_box_and_1_goal(level, box_before, box_after)

    path      = ""
    distances = BoxDistancesService.new(new_level).run(:all_for_level)
    m, n      = box_after[:m], box_after[:n]
    pushes    = distance_of(distances, m, n)

    # pushes
    while distance_of(distances, m, n) != 0
      if distance_of(distances, m+1, n, :from_bottom) == pushes - 1
        m    = m + 1
        path = "U#{path}"
      elsif distance_of(distances, m-1, n, :from_top) == pushes - 1
        m    = m - 1
        path = "D#{path}"
      elsif distance_of(distances, m, n+1, :from_right) == pushes - 1
        n    = n + 1
        path = "L#{path}"
      elsif distance_of(distances, m, n-1, :from_left) == pushes - 1
        n    = n - 1
        path = "R#{path}"
      end

      pushes = pushes - 1
    end

    path
  end

  def level_with_1_box_and_1_goal(level, box, goal)
    new_level = level.clone

    # replace all boxes by walls
    new_level.grid.tr!('*$', '#')

    # remove all goals
    new_level.grid.tr!('.', 's')
    new_level.grid.tr!('+', '@')

    # Put box on box position
    new_level.write_pos(box[:m], box[:n], '$')

    # Put goal on goal position
    goal_char = new_level.read_pos(goal[:m], goal[:n])

    if goal_char == '@'
      new_level.write_pos(goal[:m], goal[:n], '+')
    elsif goal_char == '$'
      new_level.write_pos(goal[:m], goal[:n], '*')
    else
      new_level.write_pos(goal[:m], goal[:n], '.')
    end

    new_level
  end

  # before pushes and between them
  def complete_pushes_path_with_moves(level, box_before, path)
    level          = level.clone
    box_before     = { :m => box_before[:m], :n => box_before[:n]   }
    pusher_pre_pos = {}
    new_path       = ""

    # moves between pushes (when box changes direction)
    path.each_char.with_index do |direction, i|
      case direction
        when 'U' then pusher_pre_pos = { :m => box_before[:m] + 1, :n => box_before[:n] }
        when 'D' then pusher_pre_pos = { :m => box_before[:m] - 1, :n => box_before[:n] }
        when 'L' then pusher_pre_pos = { :m => box_before[:m],     :n => box_before[:n] + 1 }
        when 'R' then pusher_pre_pos = { :m => box_before[:m],     :n => box_before[:n] - 1 }
      end

      pusher_gap_path = MovesBetweenTwoPositionsService.new(level, { :m => level.pusher[:m], :n => level.pusher[:n] }, pusher_pre_pos).run

      (pusher_gap_path + direction).each_char { |d| level.move(d) }

      new_path = new_path + pusher_gap_path + direction

      case direction
        when 'U' then box_before = { :m => box_before[:m] - 1, :n => box_before[:n] }
        when 'D' then box_before = { :m => box_before[:m] + 1, :n => box_before[:n] }
        when 'L' then box_before = { :m => box_before[:m],     :n => box_before[:n] - 1 }
        when 'R' then box_before = { :m => box_before[:m],     :n => box_before[:n] + 1 }
      end
    end

    new_path
  end

  def distance_of(distances, m, n, from_direction = nil)
    if !from_direction.nil?
      distances[m*@cols + n][from_direction]
    else
      distances[m*@cols + n].values.min
    end
  end

end
