class MinimalBoxesToGoalsDistanceService

  def initialize(node, distances)
    @node      = node
    @level     = Level.new(node)
    @distances = distances

    # if !valid?
    #   raise 'Error: Assumes the level contains only one box and one pusher (no goals)'
    # end
  end

  def run

  end

  private

  def valid?

  end

end
