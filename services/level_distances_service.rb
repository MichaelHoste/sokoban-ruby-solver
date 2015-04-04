# Pre-compute all the distances of one level
# distance[pusher_position, box_position, goal_position] = number of pushes
# of boxes from box_position to goal_position starting with pusher position

class LevelDistancesService

  def initialize(level)
    @level = level.clone
    empty_level(@level)
  end

  def run(type = :for_zone)
    distances = initialize_distances

    (0..@level.size-1).each do |pusher_index|
      (0..@level.size-1).each do |box_index|
        result = compute_distances(pusher_index, box_index)
        distances[pusher_index][box_index] = result
      end
    end

    if type == :for_zone
      format_distances_for_zone(distances)
    elsif type == :for_level
      distances
    else
      nil
    end
  end

  private

  def initialize_distances
    size      = @level.size
    distances = Array.new(size) { |i| Array.new(size) }
  end

  def compute_distances(pusher_index, box_index)
    pusher_invalid = !Level.inside_cells.include?(@level.grid[pusher_index])
    box_invalid    = !Level.inside_cells.include?(@level.grid[box_index])

    # Cannot compute invalid pusher, or pusher and box on the same position
    if pusher_invalid || box_invalid || pusher_index == box_index
      return Array.new(@level.inside_size) { |index| Float::INFINITY }
    end

    @level.grid[pusher_index] = '@'
    @level.grid[box_index]    = '$'

    distances = BoxDistancesService.new(@level).run(:for_level)

    @level.grid[pusher_index] = 's'
    @level.grid[box_index]    = 's'

    return distances
  end

  def format_distances_for_zone(distances)
    pusher_index = -1
    distances = distances.reject do |pusher_array|
      pusher_index += 1
      !Level.inside_cells.include?(@level.grid[pusher_index])
    end

    distances.each_with_index do |pusher_array, pusher_index|
      box_index = -1
      distances[pusher_index] = pusher_array.reject do |box_array|
        box_index += 1
        !Level.inside_cells.include?(@level.grid[box_index])
      end
    end

    distances.each_with_index do |pusher_array, pusher_index|
      pusher_array.each_with_index do |box_array, box_index|
        goal_index = -1
        distances[pusher_index][box_index] = box_array.reject do |goal_array|
          goal_index += 1
          !Level.inside_cells.include?(@level.grid[goal_index])
        end
      end
    end

    distances
  end

  def empty_level(level)
    @level.grid.each_with_index do |cell, i|
      if Level.inside_cells.include? cell
        @level.grid[i] = 's'
      end
    end
  end

end
