# Pre-compute all the distances of one level
# distance[pusher_position, box_position, goal_position] = number of pushes
# of boxes from box_position to goal_position starting with pusher position

class LevelDistancesService

  def initialize(level)
    @level        = level.clone
    @inside_cells = Level.inside_cells
    empty_level(@level)
  end

  def run
    @distances = initialize_distances

    (0..@level.size-1).each do |pusher_index|
      (0..@level.size-1).each do |box_index|
        if @distances[pusher_index][box_index].nil?
          result = compute_distances(pusher_index, box_index)
          @distances[pusher_index][box_index] = result

          # to avoid similar recomputation of distances
          apply_result_to_similar_pusher_positions(pusher_index, box_index, result)
        end
      end
    end

    self
  end

  def distances_for_level
    @distances
  end

  def distances_for_zone
    @zone_distances ||= format_distances_for_zone(@distances)
  end

  private

  def initialize_distances
    size      = @level.size
    distances = Array.new(size) { |i| Array.new(size) }
  end

  def compute_distances(pusher_index, box_index)
    pusher_invalid = !@inside_cells.include?(@level.grid[pusher_index])
    box_invalid    = !@inside_cells.include?(@level.grid[box_index])

    # Cannot compute invalid pusher, or pusher and box on the same position
    if pusher_invalid || box_invalid || pusher_index == box_index
      return Array.new(@level.inside_size) { |index| Float::INFINITY }
    end

    @level.grid[pusher_index] = '@'
    @level.grid[box_index]    = '$'
    @level.pusher[:m] = pusher_index / @level.cols
    @level.pusher[:n] = pusher_index % @level.cols

    distances = BoxDistancesService.new(@level).run(:minimum_for_level)

    @level.grid[pusher_index] = 's'
    @level.grid[box_index]    = 's'

    return distances
  end

  def format_distances_for_zone(distances)
    pusher_index = -1

    distances.collect do |pusher_array|
      pusher_index += 1
      if @inside_cells.include?(@level.grid[pusher_index])
        box_index = -1

        pusher_array.collect do |box_array|
          box_index += 1
          if @inside_cells.include?(@level.grid[box_index])
            goal_index = -1

            box_array.collect do |goal_array|
              goal_index += 1
              if @inside_cells.include?(@level.grid[goal_index])
                goal_array
              else
                nil
              end
            end.compact
          else
            nil
          end
        end.compact
      else
        nil
      end
    end.compact
  end

  def apply_result_to_similar_pusher_positions(pusher_index, box_index, result)
    pusher_inside = @inside_cells.include? @level.grid[pusher_index]
    box_inside    = @inside_cells.include? @level.grid[box_index]

    if pusher_inside && box_inside && pusher_index != box_index
      @level.grid[pusher_index] = '@'
      @level.grid[box_index]    = '$'
      @level.pusher[:m] = pusher_index / @level.cols
      @level.pusher[:n] = pusher_index % @level.cols

      pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

      @level.zone_pos_to_level_pos.each_pair do |zone_pos, level_pos|
        if pusher_zone.bit_1?(zone_pos)
          @distances[level_pos][box_index] = result
        end
      end

      @level.grid[pusher_index] = 's'
      @level.grid[box_index]    = 's'
    end
  end

  def empty_level(level)
    @level.grid.each_char.with_index do |cell, i|
      if @inside_cells.include? cell
        @level.grid[i] = 's'
      end
    end
  end

end
