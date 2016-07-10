# Quick deadlock detection (for optimization since the behaviour would stay
#                           the same using munkres and box_to_goal infinite
#                           penality, but way slower)

class DeadlockService

  def initialize(level)
    @level = level
    @grid  = level.grid
    @cols  = level.cols
  end

  def run
    corner_deadlock_positions + line_deadlock_positions
  end

  private

  def read_pos(m, n)
    @grid[m*@cols + n]
  end

  # When a box is in a corner and no way to remove it
  def corner_deadlock_positions
    positions = []

    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        cell = read_pos(m, n)

        if not ' #.*+'.include? cell
          if in_corner?(m, n)
            positions << { :m => m, :n => n }
          end
        end
      end
    end

    positions
  end

  # When there is a box against a wall and no way to remove it
  def line_deadlock_positions
    corner_deadlock_positions = corner_deadlock_positions()

    line_deadlock_positions = []
    line_deadlock_positions += vertical_deadlock_positions(corner_deadlock_positions)
    line_deadlock_positions += horizontal_deadlock_positions(corner_deadlock_positions)

    line_deadlock_positions
  end

  def horizontal_deadlock_positions(corner_deadlock_positions)
    line_deadlock_positions = []

    corner_deadlock_positions.each do |corner_pos|
      escape_up   = false
      escape_down = false
      escape_goal = false

      m = corner_pos[:m]
      n = corner_pos[:n]

      cell = read_pos(m, n)

      while cell != '#'
        escape_up   = true if read_pos(m - 1, n) != '#'
        escape_down = true if read_pos(m + 1, n) != '#'
        escape_goal = true if '.*+'.include? cell

        n += 1
        cell = read_pos(m, n)
      end

      # Mark horizontal line if up or down is full of walls and has no goal
      if (!escape_up || !escape_down) && !escape_goal
        m = corner_pos[:m]
        n = corner_pos[:n]

        while read_pos(m, n) != '#'
          cell_pos = { :m => m, :n => n }

          if !corner_deadlock_positions.include?(cell_pos) && !line_deadlock_positions.include?(cell_pos)
            line_deadlock_positions << { :m => m, :n => n }
          end

          n += 1
        end
      end
    end

    line_deadlock_positions
  end

  def vertical_deadlock_positions(corner_deadlock_positions)
    line_deadlock_positions = []

    corner_deadlock_positions.each do |corner_pos|
      escape_left  = false
      escape_right = false
      escape_goal  = false

      m = corner_pos[:m]
      n = corner_pos[:n]

      cell = read_pos(m, n)

      while cell != '#'
        escape_left  = true if read_pos(m, n - 1) != '#'
        escape_right = true if read_pos(m, n + 1) != '#'
        escape_goal  = true if '.*+'.include? cell

        m += 1
        cell = read_pos(m, n)
      end

      # Mark vertical line if left or right is full of walls and has no goal
      if (!escape_left || !escape_right) && !escape_goal
        m = corner_pos[:m]
        n = corner_pos[:n]

        while read_pos(m, n) != '#'
          cell_pos = { :m => m, :n => n }

          if !corner_deadlock_positions.include?(cell_pos) && !line_deadlock_positions.include?(cell_pos)
            line_deadlock_positions << { :m => m, :n => n }
          end

          m += 1
        end
      end
    end

    line_deadlock_positions
  end

  def in_corner?(m, n)
    l = read_pos(m, n-1)
    r = read_pos(m, n+1)
    u = read_pos(m-1, n)
    d = read_pos(m+1, n)

    (u == '#' && l == '#') || (u == '#' && r == '#')  || (d == '#' && l == '#') || (d == '#' && r == '#')
  end
end
