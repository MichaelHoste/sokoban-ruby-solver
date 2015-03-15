class Zone

  BOXES_ZONE    = 0
  PUSHER_ZONE   = 1
  GOAL_ZONE     = 2
  DEADLOCK_ZONE = 3

  attr_reader :level, :type, :zone, :length

  def initialize(level, type = BOXES_ZONE)
    @level  = level
    @type   = type
    @length = initialize_length

    initialize_boxes_zone    if @type == BOXES_ZONE
    initialize_pusher_zone   if @type == PUSHER_ZONE
    initialize_goal_zone     if @type == GOAL_ZONE
    initialize_deadlock_zone if @type == DEADLOCK_ZONE
  end

  def print
    puts to_s
  end

  def print_binary
    puts "%0#{@length}b" % @zone
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

  # length of zone (number of inside positions)
  def initialize_length
    @level.grid.count do |char|
      ['$', '.', '*', '@', '+', 's'].include? char
    end
  end

  def initialize_boxes_zone
    @zone = 0
    bit  = 1

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

  end

  def initialize_deadlock_zone

  end

end
