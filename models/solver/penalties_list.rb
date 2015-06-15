class PenaltiesList

  def initialize(num_of_boxes)
    @penalties    = Array.new(num_of_boxes) { Array.new }
    @num_of_boxes = num_of_boxes
  end

  def add(penalty)
    node_num_of_boxes = penalty[:node].num_of_boxes

    @penalties[node_num_of_boxes - 1] << penalty
    @penalties[node_num_of_boxes - 1].sort! { |x, y| x[:value] <=> y[:value] }
    @penalties[node_num_of_boxes - 1].reverse!
  end
  alias_method :<<, :add

  def each(&block)
    @penalties.each(&block)
  end

  def reverse_each(&block)
    @penalties.reverse_each(&block)
  end

  def all
    (0..@num_of_boxes-1).collect do |index|
      @penalties[index]
    end.inject(:+)
  end

  def include?(node)
    @penalties[node.num_of_boxes - 1].each do |penalty|
      return true if penalty[:node] == node
    end

    return false
  end

  def size
    (0..@num_of_boxes-1).collect do |index|
      @penalties[index].count
    end.inject(:+)
  end
  alias_method :count, :size

end
