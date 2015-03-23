# Get distances from one box to any other position
# depending on the pusher's start position

class DistancesService

  def initialize(level)
    @level = level.clone

    if !valid?
      raise 'Error: Assume the level contains only one box and no goals'
    end
  end

  def run
    heap      = []
    distances = []
    box_pos   = {}

    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        distances << {
          :from_left   => Float::INFINITY,
          :from_right  => Float::INFINITY,
          :from_top    => Float::INFINITY,
          :from_bottom => Float::INFINITY
        }

        if @level.read_pos(m, n) == '$'
          box_pos = { :m => m, :n => n }
        end
      end
    end

    [:from_bottom, :from_top, :from_left, :from_right].each do |direction|
      heap << { :m => box_pos[:m], :n => box_pos[:n], :direction => direction, :weight => 0 }
    end

    while heap.size > 0
      next_item = heap.min_by { |pos| pos[:weight] }
      heap.delete(next_item)

      dijkstra(heap, distances, next_item)
    end

    format_distances(distances)
  end

  private

  def dijkstra(heap, distances, item)
    pos       = item[:m]*@level.cols + item[:n]
    cell      = @level.read_pos(item[:m], item[:n])
    direction = item[:direction]
    weight    = item[:weight]

    if ['@', '$', 's'].include?(cell) && distances[pos][direction] > weight
      distances[pos][direction] = weight

      # place box at pos
      @level.write_pos(item[:m], item[:n], '$')

      # place pusher based on last direction variable (if from_left, start left)
      if direction == :from_bottom
        @level.write_pos(item[:m] + 1, item[:n],     '@')
      elsif direction == :from_top
        @level.write_pos(item[:m] - 1, item[:n],     '@')
      elsif direction == :from_left
        @level.write_pos(item[:m],     item[:n] - 1, '@')
      elsif direction == :from_right
        @level.write_pos(item[:m],     item[:n] + 1, '@')
      end

      pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

      puts pusher_zone.to_s

      # For each move, execute only if new from_position is on pusherzone
      custom_zone = Zone.new(@level, Zone::CUSTOM_ZONE, :positions => [:m => item[:m] + 1, :n => item[:n]])
      if (custom_zone & pusher_zone).to_binary.scan(/1/).count == 1
        heap << { :m => item[:m] - 1, :n => item[:n],     :direction => :from_bottom, :weight => weight + 1 }
      end

      puts custom_zone.to_s
      puts ((custom_zone & pusher_zone).to_binary.scan(/1/).count == 1).to_s

      custom_zone = Zone.new(@level, Zone::CUSTOM_ZONE, :positions => [:m => item[:m] - 1, :n => item[:n]])
      if (custom_zone & pusher_zone).to_binary.scan(/1/).count == 1
        heap << { :m => item[:m] + 1, :n => item[:n],     :direction => :from_top,    :weight => weight + 1 }
      end

      puts custom_zone.to_s
      puts ((custom_zone & pusher_zone).to_binary.scan(/1/).count == 1).to_s

      custom_zone = Zone.new(@level, Zone::CUSTOM_ZONE, :positions => [:m => item[:m]    , :n => item[:n] - 1])
      if (custom_zone & pusher_zone).to_binary.scan(/1/).count == 1
        heap << { :m => item[:m]    , :n => item[:n] + 1, :direction => :from_left,   :weight => weight + 1 }
      end

      puts custom_zone.to_s
      puts ((custom_zone & pusher_zone).to_binary.scan(/1/).count == 1).to_s

      custom_zone = Zone.new(@level, Zone::CUSTOM_ZONE, :positions => [:m => item[:m]    , :n => item[:n] + 1])
      if (custom_zone & pusher_zone).to_binary.scan(/1/).count == 1
        heap << { :m => item[:m]    , :n => item[:n] - 1, :direction => :from_right,  :weight => weight + 1 }
      end

      puts custom_zone.to_s
      puts ((custom_zone & pusher_zone).to_binary.scan(/1/).count == 1).to_s

      raise

      # remove box from pos
      @level.write_pos(item[:m], item[:n], 's')
    end
  end

  # keep only useful distances (only inside, no walls or outside)
  def format_distances(distances)
    values = []

    distances.each_with_index do |distance, i|
      if ['@', '$', 's'].include?(@level.grid[i])
        values << [ distance[:from_left], distance[:from_right],
                    distance[:from_top], distance[:from_bottom] ].min
      end
    end

    values
  end

  def valid?
    one_box  = @level.grid.count { |cell| ['*', '$'].include? cell      } == 1
    no_goals = @level.grid.count { |cell| ['.', '*', '+'].include? cell } == 0

    one_box && no_goals
  end

end
