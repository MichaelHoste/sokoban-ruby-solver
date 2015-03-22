class GoalsDistanceService

  def initialize(level)
    @level = level

    if !valid?
      raise 'Error: Assume the level contains only one box and no goals'
    end
  end

  def run
    box_pos   = {}
    distances = []

    (0..@level.rows-1).each do |m|
      (0..@level.cols-1).each do |n|
        if @level.read_pos(m, n) == '$'
          box_pos = { :m => m, :n => n }

          distances << {
            :from_left   => 0,
            :from_right  => 0,
            :from_top    => 0,
            :from_bottom => 0
          }
        else
          distances << {
            :from_left   => Float::INFINITY,
            :from_right  => Float::INFINITY,
            :from_top    => Float::INFINITY,
            :from_bottom => Float::INFINITY
          }
        end
      end
    end

    heap = []
    heap << { :m => box_pos[:m] - 1, :n => box_pos[:n],     :direction => :from_bottom, :weight => 1 }
    heap << { :m => box_pos[:m] + 1, :n => box_pos[:n],     :direction => :from_top,    :weight => 1 }
    heap << { :m => box_pos[:m]    , :n => box_pos[:n] + 1, :direction => :from_left,   :weight => 1 }
    heap << { :m => box_pos[:m]    , :n => box_pos[:n] - 1, :direction => :from_right,  :weight => 1 }

    while heap.size > 0
      next_item = heap.min_by { |pos| pos[:weight] }
      heap.delete(next_item)
      dijkstra_rec(heap, distances, next_item)
    end

    values = []
    distances.each_with_index do |distance, i|
      if ['@', '$', 's'].include?(@level.grid[i])
        values << [ distance[:from_left], distance[:from_right],
                    distance[:from_top], distance[:from_bottom] ].min
      end
    end

    values
  end

  private

  def dijkstra_rec(heap, distances, item)
    pos       = item[:m]*@level.cols + item[:n]
    cell      = @level.read_pos(item[:m], item[:n])
    direction = item[:direction]
    weight    = item[:weight]

    if ['s', '@'].include?(cell) && distances[pos][direction] > weight
      distances[pos][direction] = weight

      heap << { :m => item[:m] - 1, :n => item[:n],     :direction => :from_bottom, :weight => weight + 1 }
      heap << { :m => item[:m] + 1, :n => item[:n],     :direction => :from_top,    :weight => weight + 1 }
      heap << { :m => item[:m]    , :n => item[:n] + 1, :direction => :from_left,   :weight => weight + 1 }
      heap << { :m => item[:m]    , :n => item[:n] - 1, :direction => :from_right,  :weight => weight + 1 }
    end
  end

  def valid?
    one_box  = @level.grid.count { |cell| ['*', '$'].include? cell      } == 1
    no_goals = @level.grid.count { |cell| ['.', '*', '+'].include? cell } == 0

    one_box && no_goals
  end

end
