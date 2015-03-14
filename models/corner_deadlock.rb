class CornerDeadlock < AbstractDeadlock

  attr_reader :deadlock_positions

  def initialize(level)
    super
    @deadlock_positions = []
    @deadlock_positions += corner_deadlock_positions(level)
    #@deadlock_positions += line_deadlock_positions(level)
  end

  def deadlocked?(node)
  end

  private

  def corner_deadlock_positions(level)
    positions = []

    for m in (0..level.rows-1)
      for n in (0..level.cols-1)
        cell = level.read_pos(m, n)

        # If not outside, not wall, not goal and in a corner
        if ![' ', '#', '.', '*', '+'].include? cell
          if in_corner?(level, m, n)
            positions << { :m => m, :n => n }
          end
        end
      end
    end

    positions
  end

  def in_corner?(level, m, n)
    l = level.read_pos(m, n-1)
    r = level.read_pos(m, n+1)
    u = level.read_pos(m-1, n)
    d = level.read_pos(m+1, n)

    (u == '#' && l == '#') || (u == '#' && r == '#')  || (d == '#' && l == '#') || (d == '#' && r == '#')
  end
end
