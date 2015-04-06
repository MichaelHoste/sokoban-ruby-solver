class Zone

  BOXES_ZONE  = 0
  PUSHER_ZONE = 1
  GOALS_ZONE  = 2
  CUSTOM_ZONE = 3

  attr_reader :level, :type, :zone

  def initialize(level, type = BOXES_ZONE, options = {})
    @level        = level
    @type         = type
    @zone         = 0
    @inside_cells = Level.inside_cells

    initialize_boxes_zone           if @type == BOXES_ZONE
    initialize_pusher_zone          if @type == PUSHER_ZONE
    initialize_goal_zone            if @type == GOALS_ZONE
    initialize_custom_zone(options) if @type == CUSTOM_ZONE
  end

  # Assume same level for speed
  def ==(other_zone)
    @zone == other_zone.zone
  end

  # zone intersection
  def &(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @zone & other_zone.zone })
  end

  # zone union
  def |(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @zone | other_zone.zone })
  end

  def bit_1?(position)
    @zone[@level.inside_size - position - 1] == 1
  end

  def bit_0?(position)
    @zone[@level.inside_size - position - 1] == 0
  end

  def positions_of_1
    b = to_full_binary
    (0...b.length).find_all { |i| b[i,1] == '1' }
  end

  def positions_of_0
    b = to_full_binary
    (0...b.length).find_all { |i| b[i,1] == '0' }
  end

  def to_s
    pos    = 0
    size   = @level.inside_size
    string = ""

    @level.grid.each do |char|
      if @inside_cells.include? char
        string += (@zone[size-pos-1] == 1 ? 'x' : ' ')
        pos += 1
      else
        string += char
      end
    end

    string.scan(/.{#{@level.cols}}/).join("\n")
  end

  # binary representation of zone
  def to_binary
    @zone.to_s(2)
  end

  # full binary representation (includes extra 0 at beginning)
  def to_full_binary
    "%0#{@level.inside_size}b" % @zone
  end

  def to_integer
    @zone
  end

  private

  def initialize_boxes_zone
    bit = 2 ** (@level.inside_size - 1)
    @level.grid.each do |char|
      if @inside_cells.include? char
        if ['$', '*'].include? char
          @zone += bit
        end
        bit /= 2
      end
    end
  end

  def initialize_pusher_zone
    positions = []

    pusher_positions_rec(@level.pusher[:pos_m],
                         @level.pusher[:pos_n],
                         positions)

    initialize_custom_zone(:positions => positions)
  end

  def pusher_positions_rec(m, n, positions)
    cell = @level.read_pos(m, n)

    if cell != '#' && !positions.include?({ :m => m, :n => n })
      positions << { :m => m, :n => n }

      if cell != '$' && cell != '*'
        pusher_positions_rec(m+1, n,   positions)
        pusher_positions_rec(m-1, n,   positions)
        pusher_positions_rec(m,   n+1, positions)
        pusher_positions_rec(m,   n-1, positions)
      end
    end
  end

  def initialize_goal_zone
    bit = 2 ** (@level.inside_size - 1)
    @level.grid.each do |char|
      if @inside_cells.include? char
        if ['.', '*', '+'].include? char
          @zone += bit
        end
        bit /= 2
      end
    end
  end

  def initialize_custom_zone(options)
    if options[:number]
      @zone = options[:number]
    elsif options[:positions]
      positions = deep_copy(options[:positions])
      positions = convert_to_zone_positions(positions)

      bit = 2 ** (@level.inside_size - 1)

      (0..@level.inside_size-1).each do |zone_pos|
        if positions.include? zone_pos
          positions.delete(zone_pos)
          @zone += bit
        end
        bit /= 2
      end
    end
  end

  # http://stackoverflow.com/a/4157635/1243212
  def deep_copy(array)
    Marshal.load(Marshal.dump(array))
  end

  def convert_to_zone_positions(level_positions)
    zone_positions = []
    zone_position  = 0
    cols           = @level.cols

    level_positions.sort! do |p1, p2|
      p1[:m] * cols + p1[:n] <=> p2[:m] * cols + p2[:n]
    end

    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        cell = @level.read_pos(m, n)
        if @inside_cells.include? cell
          if level_positions.any? && level_positions.first[:m] == m && level_positions.first[:n] == n
            zone_positions << zone_position
            level_positions.shift
          end
          zone_position += 1
        end
      end
    end

    zone_positions
  end
end
