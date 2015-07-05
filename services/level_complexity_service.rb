# From a level with one pusher and one box, compute number of pushes to any
# position from the level

class LevelComplexityService

  def initialize(level)
    @level = level
    @grid  = level.grid
    @rows  = level.rows
    @cols  = level.cols

    @weighted_grid = Array.new(level.size, 0)
  end

  def run
    (0..@rows-1).each do |m|
      (0..@cols-1).each do |n|
        cell = @grid[m*@cols + n]

        if cell == '$' || cell == '*'
          fill_weighted_grid(m*@cols + n)
        end
      end
    end

    values = @weighted_grid.collect do |value|
      if value == 0
        0
      elsif value < 10
        value > 1 ? 2**(value-1) : 0
      elsif value < 100
        3**(value/10)
      elsif value < 1000
        5**(value/100)
      end
    end

    values.inject(&:+)#.to_f / @level.boxes
  end

  def fill_weighted_grid(position)
    neighbours = [
      position - 1,         # left
      position + 1,         # right
      position + @cols,     # down
      position - @cols,     # up
      position + @cols - 1, # down-left
      position + @cols + 1, # down-right
      position - @cols - 1, # up-left
      position - @cols + 1, # up-right
    ]

    neighbours.each do |neighbour|
      cell = @grid[neighbour]

      # If neighbour is empty, +1
      if cell == 's' || cell == '.' || cell == '@' || cell == '+'
        @weighted_grid[neighbour] += 1
      # If neighbour is a wall, +10
      elsif cell == '#'
        @weighted_grid[neighbour] += 10
      # If neighbour is another box, +100
      elsif cell == '$' || cell == '*'
        @weighted_grid[neighbour] += 100
      end
    end
  end

end
