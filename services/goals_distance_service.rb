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
    one_box  = @level.grid.count { |cell| ['*', '$'].include? cell      } == 1
    no_goals = @level.grid.count { |cell| ['.', '*', '+'].include? cell } == 0

    one_box && no_goals
  end

end
