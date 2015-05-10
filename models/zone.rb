class Zone

  BOXES_ZONE  = 0
  PUSHER_ZONE = 1
  GOALS_ZONE  = 2
  CUSTOM_ZONE = 3

  attr_reader :level, :number

  def initialize(level, type = BOXES_ZONE, options = {})
    @level        = level
    @number       = 0
    @inside_cells = Level.inside_cells

    initialize_boxes_zone           if type == BOXES_ZONE
    initialize_goal_zone            if type == GOALS_ZONE
    initialize_custom_zone(options) if type == CUSTOM_ZONE
    initialize_pusher_zone          if type == PUSHER_ZONE
  end

  # Assume same level for speed
  def ==(other_zone)
    @number == other_zone.number
  end

  # zone intersection
  def &(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @number & other_zone.number })
  end

  # zone union
  def |(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @number | other_zone.number })
  end

  # zone inclusion
  def in?(other_zone)
    (self | other_zone) == other_zone
  end

  # zone inclusion
  def include?(other_zone)
    (self | other_zone) == self
  end

  def bit_1?(position)
    @number[@level.inside_size - position - 1] == 1
  end

  def bit_0?(position)
    @number[@level.inside_size - position - 1] == 0
  end

  def set_bit_1(position)
    if @number[@level.inside_size - position - 1] == 0
      @number += 2**(@level.inside_size - position - 1)
    end
  end

  def set_bit_0(position)
    if @number[@level.inside_size - position - 1] == 1
      @number -= 2**(@level.inside_size - position - 1)
    end
  end

  def positions_of_1
    b = to_full_binary
    (0..b.length).find_all { |i| b[i,1] == '1' }
  end

  def positions_of_0
    b = to_full_binary
    (0..b.length).find_all { |i| b[i,1] == '0' }
  end

  def clone
    Zone.new(@level, CUSTOM_ZONE, { :number => @number })
  end

  def to_s
    pos    = 0
    size   = @level.inside_size
    string = ""

    @level.grid.each do |char|
      if @inside_cells.include? char
        string += (@number[size-pos-1] == 1 ? 'x' : ' ')
        pos += 1
      else
        string += char
      end
    end

    string.scan(/.{#{@level.cols}}/).join("\n")
  end

  # binary representation of zone
  def to_binary
    @number.to_s(2)
  end

  # full binary representation (includes extra 0 at beginning)
  def to_full_binary
    "%0#{@level.inside_size}b" % @number
  end

  def to_integer
    @number
  end

  private

  def initialize_boxes_zone
    bit = 2 ** (@level.inside_size - 1)
    @level.grid.each do |char|
      if @inside_cells.include? char
        if ['$', '*'].include? char
          @number += bit
        end
        bit /= 2
      end
    end
  end

  def initialize_goal_zone
    bit = 2 ** (@level.inside_size - 1)

    @level.zone_pos_to_level_pos.values.each do |level_pos|
      char = @level.grid[level_pos]
      if @inside_cells.include? char
        if ['.', '*', '+'].include? char
          @number += bit
        end
        bit /= 2
      end
    end
  end

  def initialize_custom_zone(options)
    if options[:number]
      @number = options[:number]
    elsif options[:positions]
      positions = convert_to_zone_positions(options[:positions])

      positions.each do |position|
        @number += 2 ** (@level.inside_size - position - 1)
      end
    end
  end

  def initialize_pusher_zone
    positions = []

    pusher_positions_rec(@level.pusher[:pos_m],
                         @level.pusher[:pos_n],
                         positions)

    # don't use hash directly in pusher_position_rec for optimization
    positions_hash = convert_positions_to_hash(positions)

    initialize_custom_zone(:positions => positions_hash)
  end

  def pusher_positions_rec(m, n, positions)
    grid_pos = m * @level.cols + n
    cell     = @level.grid[grid_pos]

    if cell != '#' && !positions.include?(grid_pos)
      positions << grid_pos

      if cell != '$' && cell != '*'
        pusher_positions_rec(m+1, n,   positions)
        pusher_positions_rec(m-1, n,   positions)
        pusher_positions_rec(m,   n+1, positions)
        pusher_positions_rec(m,   n-1, positions)
      end
    end
  end

  def convert_positions_to_hash(positions)
    positions.collect do |position|
      {
        :m => (position / @level.cols).floor,
        :n => position % @level.cols
      }
    end
  end

  def convert_to_zone_positions(level_positions)
    cols = @level.cols

    level_positions.collect do |pos|
      @level.level_pos_to_zone_pos[cols*pos[:m] + pos[:n]]
    end.compact
  end
end
