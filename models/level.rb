# Class containing a level and every methods about it
#
# Positions in grid start in the upper-left corner with (m=0,n=0).
#
# Example : (2,4) means third rows and fifth cols starting in the upper-left
# corner.
#
# Grid is made like this in loaded files :
#
#      #####                 # -> wall
#      #   #                 $ -> box
#      #$  #                 . -> goal
#    ###  $##                * -> box on a goal (not in this figure)
#    #  $ $ #                @ -> pusher
#  ### # ## #   ######       + -> pusher on a goal
#  #   # ## #####  ..#       s -> inside floor (generated by recursive
#  # $  $          ..#            algorithm)
#  ##### ### #@##  ..#
#      #     #########
#      #######

class Level

  attr_reader :name, :copyright, :rows, :cols, :grid, :boxes,
              :goals, :pusher

  def initialize(xml_level)
    xml_level_node = Nokogiri::XML(xml_level)
    copyright_node = xml_level_node.css('Level').attr('Copyright')

    @name      = xml_level_node.css('Level').attr('Id').text.strip
    @copyright = copyright_node ? copyright_node.text.strip : ""
    @rows      = xml_level_node.css('Level').attr('Height').text.strip.to_i
    @cols      = xml_level_node.css('Level').attr('Width').text.strip.to_i
    @pusher    = {}

    initialize_grid(xml_level_node)
    initialize_pusher_position
    initialize_floor
    initialize_boxes_and_goals
  end

  def read_pos(m, n)
    if m < @rows && n < @cols && m >= 0 && n >= 0
      @grid[@cols*m + n]
    else
      raise "Try to read value out of level's grid"
    end
  end

  def write_pos(m, n, letter)
    if m < @rows && n < @cols && m >= 0 && n >= 0
      @grid[@cols*m + n] = letter
    else
      raise "Try to write value out of level's grid"
    end
  end

  # Direction should be 'u', 'd', 'l', 'r' in lowercase or uppercase
  def can_move?(direction)
    m = @pusher[:pos_m]
    n = @pusher[:pos_n]

    direction = direction.downcase

    # Following of the direction, test 2 cells
    if direction == 'u'
      move1 = read_pos(m-1, n)
      move2 = read_pos(m-2, n)
    elsif direction == 'd'
      move1 = read_pos(m+1, n)
      move2 = read_pos(m+2, n)
    elsif direction == 'l'
      move1 = read_pos(m, n-1)
      move2 = read_pos(m, n-2)
    elsif direction == 'r'
      move1 = read_pos(m, n+1)
      move2 = read_pos(m, n+2)
    end

    # Check that's not a wall, or two boxes, or one boxes and a wall
    !(move1 == '#' || ((move1 == '*' || move1 == '$') && (move2 == '*' || move2 == '$' || move2 == '#')))
  end

  # Direction should be 'u', 'd', 'l', 'r' in lowercase or uppercase
  # Return 0 if no move, 1 if normal move, 2 if box push.
  def move(direction)
    action = true
    m      = @pusher[:pos_m]
    n      = @pusher[:pos_n]

    direction = direction.downcase

    # Following of the direction, test 2 cells
    if direction == 'u' && can_move?('u')
      m_1 = m-1
      m_2 = m-2
      n_1 = n_2 = n
      @pusher[:pos_m] -= 1
    elsif direction == 'd' && can_move?('d')
      m_1 = m+1
      m_2 = m+2
      n_1 = n_2 = n
      @pusher[:pos_m] += 1
    elsif direction == 'l' && can_move?('l')
      n_1 = n-1
      n_2 = n-2
      m_1 = m_2 = m
      @pusher[:pos_n] -= 1
    elsif direction == 'r' && can_move?('r')
      n_1 = n+1
      n_2 = n+2
      m_1 = m_2 = m
      @pusher[:pos_n] += 1
    else
      action = false
      state = 0
    end

    # Move accepted
    if action
      state = 1

      # Test on cell (m,n)
      if read_pos(m, n) == '+'
        write_pos(m, n, '.')
      else
        write_pos(m, n, 's')
      end

      # Test on cell (m_2,n_2)
      if ['$', '*'].include? read_pos(m_1, n_1)
        if read_pos(m_2, n_2) == '.'
          write_pos(m_2, n_2, '*')
        else
          write_pos(m_2, n_2, '$')
        end

        state = 2
      end

      # Test on cell (m_1, n_1)
      if ['.', '*'].include? read_pos(m_1, n_1)
        write_pos(m_1, n_1, '+')
      else
        write_pos(m_1, n_1, '@')
      end
    end

    return state
  end

  def won?
    !(@grid.any? { |cell| cell == '$' })
  end

  def print
    puts to_s
  end

  def to_s
    @grid.join.gsub('s', ' ').scan(/.{#{@cols}}/).join("\n")
  end

  # compare on the grid only!
  def ==(other_level)
    @grid == other_level.grid
  end

  private

  def initialize_grid(xml_level_node)
    lines = xml_level_node.css("L").collect(&:text)
    @grid = lines.collect { |line| line.ljust @cols }.join.split('')
  end

  def initialize_pusher_position
    pos = @grid.index { |cell| ['@', '+'].include? cell }
    @pusher[:pos_n] = pos % @cols
    @pusher[:pos_m] = (pos / @cols).floor
  end

  # Transform empty spaces inside level in floor represented by 's'.
  def initialize_floor
    initialize_floor_rec(@pusher[:pos_m], @pusher[:pos_n])

    # Set back symbols to regular symbols
    @grid = @grid.join('')
                 .gsub('p', '.').gsub('d', '$').gsub('a', '*')
                 .split('')
  end

  # Recursive function used by make_floor
  def initialize_floor_rec(m, n)
    cell = read_pos(m, n)

    # Change of values to "floor" or "visited"
    if cell == ' '
      write_pos(m, n, 's') # floor
    elsif cell == '.'
      write_pos(m, n, 'p') # visited goal
    elsif cell == '$'
      write_pos(m, n, 'd') # visited box
    elsif cell == '*'
      write_pos(m, n, 'a') # visited box
    end

    # If non-visited cell, test neighbours cells
    if !['#', 's', 'p', 'd', 'a'].include? cell
      initialize_floor_rec(m+1, n)
      initialize_floor_rec(m-1, n)
      initialize_floor_rec(m, n+1)
      initialize_floor_rec(m, n-1)
    end
  end

  def initialize_boxes_and_goals
    @boxes = @grid.count { |cell| ['*', '$'].include? cell }
    @goals = @grid.count { |cell| ['+', '*', '.'].include? cell }

    if @boxes != @goals
      raise 'Level error: there must be the same number of boxes and goals'
    end
  end
end
