# Get path of pusher moves between 2 (free) positions of a level

class MovesBetweenTwoPositionsService

  def initialize(level, pos1, pos2)
    @level = level
    @pos1  = pos1
    @pos2  = pos2
    @cols  = level.cols
    @rows  = level.rows
  end

  def run
    path      = ""
    distances = pusher_dijkstra(@level, @pos1)
    m         = @pos2[:m]
    n         = @pos2[:n]
    moves     = distances[m*@cols + n]

    while distances[m*@cols + n] != 0
      if distances[(m+1)*@cols + n] == moves - 1
        m    = m + 1
        path = "u#{path}"
      elsif distances[(m-1)*@cols + n] == moves - 1
        m    = m - 1
        path = "d#{path}"
      elsif distances[m*@cols + (n+1)] == moves - 1
        n    = n + 1
        path = "l#{path}"
      elsif distances[m*@cols + (n-1)] == moves - 1
        n    = n - 1
        path = "r#{path}"
      end

      moves = moves - 1
    end

    path
  end

  private

  def pusher_dijkstra(level, start_position)
    distances = Array.new(@rows * @cols, Float::INFINITY)

    heap = []
    heap << {
      :m     => start_position[:m],
      :n     => start_position[:n],
      :value => 0
    }

    while heap.size > 0
      item  = heap.shift
      m     = item[:m]
      n     = item[:n]
      value = item[:value]

      if !'#*$'.include?(level.read_pos(m, n)) && item[:value] < distances[m * @cols + n]
        distances[m * @cols + n] = item[:value]

        heap << { :m => m + 1, :n => n,     :value => value + 1 }
        heap << { :m => m - 1, :n => n,     :value => value + 1 }
        heap << { :m => m,     :n => n + 1, :value => value + 1 }
        heap << { :m => m,     :n => n - 1, :value => value + 1 }
      end
    end

    distances
  end
end
