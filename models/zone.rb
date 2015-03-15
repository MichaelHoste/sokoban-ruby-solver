class Zone

  BOXES_ZONE  = 0
  PUSHER_ZONE = 1
  GOALS_ZONE  = 2
  CUSTOM_ZONE = 3

  attr_reader :level, :type, :zone

  def initialize(level, type = BOXES_ZONE, options = {})
    @level  = level
    @type   = type
    @zone   = 0

    initialize_boxes_zone                       if @type == BOXES_ZONE
    initialize_pusher_zone                      if @type == PUSHER_ZONE
    initialize_goal_zone                        if @type == GOALS_ZONE
    initialize_custom_zone(options[:positions]) if @type == CUSTOM_ZONE
  end

  def print
    puts to_s
  end

  def print_binary
    puts "%0#{@zone.bit_length}b" % @zone
  end

  def print_integer
    puts @zone
  end

  def to_s
    pos    = 0
    string = ""

    @level.grid.each do |char|
      spotted = false

      if ['$', '.', '*', '@', '+', 's'].include? char
        string += (@zone[pos] == 1 ? 'x' : ' ')
        pos += 1
      else
        string += char
      end
    end

    string.scan(/.{#{@level.cols}}/)
  end

  private

  def initialize_boxes_zone
    bit = 1
    @level.grid.collect do |char|
      if ['$', '.', '*', '@', '+', 's'].include? char
        if ['$', '*'].include? char
          @zone += bit
        end
        bit *= 2
      end
    end
  end

  def initialize_pusher_zone

  end

  def initialize_goal_zone
    bit = 1
    @level.grid.collect do |char|
      if ['$', '.', '*', '@', '+', 's'].include? char
        if ['.', '*', '+'].include? char
          @zone += bit
        end
        bit *= 2
      end
    end
  end

  def initialize_custom_zone(positions)
    bit = 1
    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        pos = @level.read_pos(m, n)
        if ['$', '.', '*', '@', '+', 's'].include? pos
          positions.each do |position|
            if position[:m] == m && position[:n] == n
              @zone += bit
              break
            end
          end
          bit *= 2
        end
      end
    end
  end
end
