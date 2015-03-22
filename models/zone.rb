class Zone

  BOXES_ZONE  = 0
  PUSHER_ZONE = 1
  GOALS_ZONE  = 2
  CUSTOM_ZONE = 3

  attr_reader :level, :type, :zone

  def initialize(level, type = BOXES_ZONE, options = {})
    @level = level
    @type  = type
    @zone  = 0

    initialize_boxes_zone           if @type == BOXES_ZONE
    initialize_pusher_zone          if @type == PUSHER_ZONE
    initialize_goal_zone            if @type == GOALS_ZONE
    initialize_custom_zone(options) if @type == CUSTOM_ZONE
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

      if inside_cells.include? char
        string += (@zone[pos] == 1 ? 'x' : ' ')
        pos += 1
      else
        string += char
      end
    end

    string.scan(/.{#{@level.cols}}/).join("\n")
  end

  # Assume same level for speed
  def ==(other_zone)
    @zone = other_zone.zone
  end

  # zone intersection
  def &(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @zone & other_zone.zone })
  end

  # zone union
  def |(other_zone)
    Zone.new(@level, CUSTOM_ZONE, { :number =>  @zone | other_zone.zone })
  end

  private

  def initialize_boxes_zone
    bit = 1
    @level.grid.collect do |char|
      if inside_cells.include? char
        if ['$', '*'].include? char
          @zone += bit
        end
        bit *= 2
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
    if !positions.include?({ :m => m, :n => n })
      positions << { :m => m, :n => n }

      cell = @level.read_pos(m, n)

      if ['.', '@', '+', 's'].include?(cell)
        pusher_positions_rec(m+1, n,   positions)
        pusher_positions_rec(m-1, n,   positions)
        pusher_positions_rec(m,   n+1, positions)
        pusher_positions_rec(m,   n-1, positions)
      end
    end
  end

  def initialize_goal_zone
    bit = 1
    @level.grid.collect do |char|
      if inside_cells.include? char
        if ['.', '*', '+'].include? char
          @zone += bit
        end
        bit *= 2
      end
    end
  end

  def initialize_custom_zone(options)
    if options[:number]
      @zone = options[:number]
    elsif options[:positions]
      positions = options[:positions]

      bit = 1
      (0..@level.rows-1).each do |m|
        (0..@level.cols-1).each do |n|
          cell = @level.read_pos(m, n)
          if inside_cells.include? cell
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

  def inside_cells
    ['$', '.', '*', '@', '+', 's']
  end
end
