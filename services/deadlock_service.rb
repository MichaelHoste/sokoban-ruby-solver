class DeadlockService

  attr_reader :level, :deadlock_positions

  def initialize(level)
    @level              = level
    @deadlock_positions = []
  end

  def run
    @deadlock_positions += corner_deadlock_positions
    @deadlock_positions += line_deadlock_positions
    @deadlock_positions
  end

  private

  # When a box is in a corner and no way to remove it
  def corner_deadlock_positions
    positions = []

    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        cell = @level.read_pos(m, n)
        if ![' ', '#', '.', '*', '+'].include? cell
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
    line_deadlock_positions   = []

    corner_deadlock_positions.each do |corner_pos|
      escape = {
        :up    => false,
        :down  => false,
        :left  => false,
        :right => false,
        :goal  => false
      }

      ###
      # Test horizontal lines
      ###

      cell_pos = {
        :m => corner_pos[:m],
        :n => corner_pos[:n]
      }

      cell = @level.read_pos(cell_pos[:m], cell_pos[:n])

      while cell != '#'
        escape[:up]   = true if @level.read_pos(cell_pos[:m] - 1, cell_pos[:n]) != '#'
        escape[:down] = true if @level.read_pos(cell_pos[:m] + 1, cell_pos[:n]) != '#'
        escape[:goal] = true if ['.', '*', '+'].include? cell

        cell_pos[:n] += 1
        cell         = @level.read_pos(cell_pos[:m], cell_pos[:n])
      end

      # Mark horizontal line if up or down is full of walls and has no goal
      if (!escape[:up] || !escape[:down]) && !escape[:goal]
        cell_pos = {
          :m => corner_pos[:m],
          :n => corner_pos[:n]
        }

        while @level.read_pos(cell_pos[:m], cell_pos[:n]) != '#'
          if !corner_deadlock_positions.include?(cell_pos) && !line_deadlock_positions.include?(cell_pos)
            line_deadlock_positions << {
              :m => cell_pos[:m],
              :n => cell_pos[:n]
            }
          end
          cell_pos[:n] += 1
        end
      end

      ###
      # Test vertical lines
      ###

      escape[:goal] = false

      cell_pos = {
        :m => corner_pos[:m],
        :n => corner_pos[:n]
      }

      cell = @level.read_pos(cell_pos[:m], cell_pos[:n])

      while cell != '#'
        escape[:left]  = true if @level.read_pos(cell_pos[:m], cell_pos[:n] - 1) != '#'
        escape[:right] = true if @level.read_pos(cell_pos[:m], cell_pos[:n] + 1) != '#'
        escape[:goal]  = true if ['.', '*', '+'].include? cell

        cell_pos[:m] += 1
        cell         = @level.read_pos(cell_pos[:m], cell_pos[:n])
      end

      # Mark vertical line if left or right is full of walls and has no goal
      if (!escape[:left] || !escape[:right]) && !escape[:goal]
        cell_pos = {
          :m => corner_pos[:m],
          :n => corner_pos[:n]
        }

        while @level.read_pos(cell_pos[:m], cell_pos[:n]) != '#'
          if !corner_deadlock_positions.include?(cell_pos) && !line_deadlock_positions.include?(cell_pos)
            line_deadlock_positions << {
              :m => cell_pos[:m],
              :n => cell_pos[:n]
            }
          end
          cell_pos[:m] += 1
        end
      end
    end

    return line_deadlock_positions
  end

  def in_corner?(m, n)
    l = @level.read_pos(m, n-1)
    r = @level.read_pos(m, n+1)
    u = @level.read_pos(m-1, n)
    d = @level.read_pos(m+1, n)

    (u == '#' && l == '#') || (u == '#' && r == '#')  || (d == '#' && l == '#') || (d == '#' && r == '#')
  end
end
