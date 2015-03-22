class GoalsDistanceService

  def initialize(level)
    @level = level

    if !valid?
      raise 'Error: Assume the level contains only one box and no goals'
    end
  end

  def run

  end

  private

  def valid?
    @level.grid.count { |cell| ['*', '$'].include? cell } == 1
  end

end
