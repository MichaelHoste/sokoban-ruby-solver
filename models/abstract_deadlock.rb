class AbstractDeadlock

  attr_reader :level

  def initialize(level)
    @level = level
  end

  def deadlocked?(node)
  end
end
