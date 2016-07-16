# From a level with one pusher and one box, compute number of pushes to put
# the box on any position of the level

class BoxDistancesService

  def initialize(level)
    @level  = level
    @rows   = level.rows
    @cols   = level.cols
    @pusher = level.pusher

    if !valid?
     raise "Error: BoxDistancesService assumes the level contains only one box and one pusher (no goals)"
    end
  end

  def run(type = :for_zone)
    heap      = []
    distances = []
    box       = {}

    # Initialize all distances with infinity
    distances = Array.new(@rows * @cols) do {
        :from_left   => Float::INFINITY,
        :from_right  => Float::INFINITY,
        :from_top    => Float::INFINITY,
        :from_bottom => Float::INFINITY
      }
    end

    # Initialize box position
    box_index = @level.grid.index('$')
    box       = {
      :m => box_index / @cols,
      :n => box_index % @cols
    }

    # Populate heap with first moves of box
    [:from_bottom, :from_top, :from_left, :from_right].each do |direction|
      heap << {
        :box       => box,
        :pusher    => @pusher,
        :direction => direction,
        :weight    => 0
      }
    end

    # remove pusher from level
    pusher_m_before = @pusher[:m]
    pusher_n_before = @pusher[:n]
    @level.write_pos(@pusher[:m], @pusher[:n], 's')

    # remove box from level
    box_m_before = box[:m]
    box_n_before = box[:n]
    @level.write_pos(box[:m], box[:n], 's')

    # Iterate through the heap starting with lower weights
    while heap.size > 0
      dijkstra(heap, heap.pop, distances)
    end

    # Place box and pusher back
    @level.write_pos(pusher_m_before, pusher_n_before, '@')
    @level.write_pos(box_m_before, box_n_before, '$')
    @level.send(:initialize_pusher_position)

    if [:for_zone, :for_level].include? type
      send("format_distances_#{type}", distances)
    else
      nil
    end
  end

  private

  def dijkstra(heap, item, distances)
    pos          = item[:box][:m]*@cols + item[:box][:n]
    box_cell     = @level.read_pos(item[:box][:m],    item[:box][:n])
    pusher_cell  = @level.read_pos(item[:pusher][:m], item[:pusher][:n])
    direction    = item[:direction]
    weight       = item[:weight]

    if box_cell == 's' && pusher_cell == 's' && distances[pos][direction] > weight
      # Place box and pusher
      @level.write_pos(item[:box][:m],    item[:box][:n],    '$')
      @level.write_pos(item[:pusher][:m], item[:pusher][:n], '@')
      @level.send(:initialize_pusher_position)

      # Place new pusher (place where it will be before pushing the box in the direction)
      if direction == :from_bottom
        new_pusher = { :m => item[:box][:m] + 1, :n => item[:box][:n] }
        new_box    = { :m => item[:box][:m] - 1, :n => item[:box][:n] }
      elsif direction == :from_top
        new_pusher = { :m => item[:box][:m] - 1, :n => item[:box][:n] }
        new_box    = { :m => item[:box][:m] + 1, :n => item[:box][:n] }
      elsif direction == :from_left
        new_pusher = { :m => item[:box][:m], :n => item[:box][:n] - 1 }
        new_box    = { :m => item[:box][:m], :n => item[:box][:n] + 1 }
      elsif direction == :from_right
        new_pusher = { :m => item[:box][:m], :n => item[:box][:n] + 1 }
        new_box    = { :m => item[:box][:m], :n => item[:box][:n] - 1 }
      end

      # Pusher zone from real pusher position
      pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

      # Can the pusher push in the needed direction?
      new_pusher_zone_pos     = @level.level_pos_to_zone_pos[new_pusher[:m] * @cols + new_pusher[:n]]
      correct_pusher_position = new_pusher_zone_pos && pusher_zone.bit_1?(new_pusher_zone_pos)

      if correct_pusher_position
        distances[pos][direction] = weight

        [:from_bottom, :from_top, :from_left, :from_right].each do |new_direction|
          index = heap.index { |heap_item| heap_item[:weight] <= weight + 1 } # keep it sorted DESC on weight!
          heap.insert(index.to_i, { # to_i because nil should be pos 0
            :box       => new_box,
            :pusher    => item[:box],
            :direction => new_direction,
            :weight    => weight + 1
          })
        end
      end

      # remove box and pusher
      @level.write_pos(item[:box][:m],    item[:box][:n],    's')
      @level.write_pos(item[:pusher][:m], item[:pusher][:n], 's')
    end
  end

  # keep only useful distances for zones (only inside, no walls or outside)
  def format_distances_for_zone(distances)
    distances.collect.with_index do |distance, pos|
      if !' #'.include?(@level.grid[pos])
        [ distance[:from_left], distance[:from_right],
          distance[:from_top], distance[:from_bottom] ].min
      else
        nil
      end
    end.compact
  end

  # keep only useful distances for levels (every position)
  def format_distances_for_level(distances)
    distances.collect do |distance|
      [ distance[:from_left], distance[:from_right],
        distance[:from_top], distance[:from_bottom] ].min
    end
  end

  def valid?
    one_box        = @level.grid.count('$')   == 1
    no_goals       = @level.grid.count('.*+') == 0
    one_pusher     = @level.grid.count('@')   == 1
    correct_pusher = @level.read_pos(@pusher[:m], @pusher[:n]) == '@'

    one_box && no_goals && one_pusher && correct_pusher
  end

end
