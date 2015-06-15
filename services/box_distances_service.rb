# From a level with one pusher and one box, compute number of pushes to any
# position from the level

class BoxDistancesService

  def initialize(level)
    @level = level.clone
    @rows  = @level.rows
    @cols  = @level.cols

    if !valid?
      raise "Error: Assumes the level contains only one box and one pusher (no goals)"
    end
  end

  def run(type = :for_zone)
    heap      = []
    distances = []
    box       = {}

    # Initialize distances and box position
    (0..@rows-1).each do |m|
      (0..@cols-1).each do |n|
        cell = @level.grid[m * @cols + n]

        if cell != ' ' && cell != '#'
          distances << {
            :from_left   => Float::INFINITY,
            :from_right  => Float::INFINITY,
            :from_top    => Float::INFINITY,
            :from_bottom => Float::INFINITY
          }
        else
          distances << nil
        end

        if cell == '$'
          box = { :m => m, :n => n }
        end
      end
    end

    # Populate heap with first moves of box
    [:from_bottom, :from_top, :from_left, :from_right].each do |direction|
      heap << {
        :box_m     => box[:m],
        :box_n     => box[:n],
        :pusher_m  => @level.pusher[:pos_m],
        :pusher_n  => @level.pusher[:pos_n],
        :direction => direction,
        :weight    => 0
      }
    end

    # remove pusher and box from level
    @level.write_pos(@level.pusher[:pos_m], @level.pusher[:pos_n], 's')
    @level.write_pos(box[:m], box[:n], 's')

    # Iterate through the heap starting with lover weights
    i = 1
    while heap.size > 0
      i += 1
      next_item = heap.min_by { |pos| pos[:weight] }
      heap.delete(next_item)

      dijkstra(heap, distances, next_item)
    end

    if [:for_zone, :for_level].include? type
      send("format_distances_#{type}", distances)
    else
      nil
    end
  end

  private

  def dijkstra(heap, distances, item)
    pos          = item[:box_m]*@cols + item[:box_n]
    box_cell     = @level.read_pos(item[:box_m],    item[:box_n])
    pusher_cell  = @level.read_pos(item[:pusher_m], item[:pusher_n])
    direction    = item[:direction]
    weight       = item[:weight]

    if box_cell == 's' && pusher_cell == 's' && distances[pos][direction] > weight
      # Place box and pusher
      @level.write_pos(item[:box_m],    item[:box_n],    '$')
      @level.write_pos(item[:pusher_m], item[:pusher_n], '@')
      @level.send(:initialize_pusher_position)

      # Place new pusher (place where it will be before pushing the box in the direction)
      if direction == :from_bottom
        new_pusher = { :m => item[:box_m] + 1, :n => item[:box_n] }
        new_box    = { :m => item[:box_m] - 1, :n => item[:box_n] }
      elsif direction == :from_top
        new_pusher = { :m => item[:box_m] - 1, :n => item[:box_n] }
        new_box    = { :m => item[:box_m] + 1, :n => item[:box_n] }
      elsif direction == :from_left
        new_pusher = { :m => item[:box_m], :n => item[:box_n] - 1 }
        new_box    = { :m => item[:box_m], :n => item[:box_n] + 1 }
      elsif direction == :from_right
        new_pusher = { :m => item[:box_m], :n => item[:box_n] + 1 }
        new_box    = { :m => item[:box_m], :n => item[:box_n] - 1 }
      end

      # Pusher zone from real pusher position
      pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

      # Zone where the pusher need to be for pushing in this direction (only 1 position)
      custom_zone = Zone.new(@level, Zone::CUSTOM_ZONE, :positions => [:m => new_pusher[:m], :n => new_pusher[:n]])

      # Can the pusher push in the needed direction?
      correct_pusher_position = (custom_zone & pusher_zone).to_binary.scan(/1/).count == 1

      if correct_pusher_position
        distances[pos][direction] = weight

        [:from_bottom, :from_top, :from_left, :from_right].each do |direction|
          heap << {
            :box_m     => new_box[:m],
            :box_n     => new_box[:n],
            :pusher_m  => item[:box_m],
            :pusher_n  => item[:box_n],
            :direction => direction,
            :weight    => weight + 1
          }
        end
      end

      # remove box and pusher
      @level.write_pos(item[:box_m],    item[:box_n],    's')
      @level.write_pos(item[:pusher_m], item[:pusher_n], 's')
    end
  end

  # keep only useful distances for zones (only inside, no walls or outside)
  def format_distances_for_zone(distances)
    values = []

    distances.each_with_index do |distance, i|
      if distance
        values << [ distance[:from_left], distance[:from_right],
                    distance[:from_top], distance[:from_bottom] ].min
      end
    end

    values
  end

  # keep only useful distances for levels (every position)
  def format_distances_for_level(distances)
    values = []

    distances.each do |distance|
      if distance
        values << [ distance[:from_left], distance[:from_right],
                    distance[:from_top], distance[:from_bottom] ].min
      else
        values << Float::INFINITY
      end
    end

    values
  end

  def valid?
    one_box        = @level.grid.count { |cell| ['*', '$'].include? cell      }    == 1
    no_goals       = @level.grid.count { |cell| ['.', '*', '+'].include? cell }    == 0
    one_pusher     = @level.grid.count { |cell| '@' == cell                   }    == 1
    correct_pusher = @level.read_pos(@level.pusher[:pos_m], @level.pusher[:pos_n]) == '@'

    one_box && no_goals && one_pusher && correct_pusher
  end

end
