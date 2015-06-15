class HashTable

  HUGE_SIZE    = 83609 # prime number not too close to a power of 2 and close to the
  BIG_SIZE     = 13463 # to te wanted elements we want to store
  MEDIUM_SIZE  = 1759
  SMALL_SIZE   = 97

  attr_reader :table_size, :size

  def initialize(size = :medium)
    @table_size = HashTable.const_get("#{size.to_s.upcase}_SIZE")
    @table      = Array.new(@table_size) { Array.new }
    @size       = 0
  end

  def include?(node)
    @table[index(node)].each do |node_from_table|
      if node_from_table == node
        return true
      end
    end

    return false
  end

  def add(node)
    @table[index(node)] << node
    @size = @size + 1
  end
  alias_method :<<, :add

  def remove(node)
    node_index = index(node)

    @table[node_index].each_with_index do |node_from_table, i|
      if node_from_table == node
        @table[node_index].delete_at(i)
        @size = @size - 1
        break
      end
    end
  end

  def size
    @table.collect do |array|
      array.length
    end.inject(:+)
  end

  private

  def index(node)
    (
     (node.boxes_zone.number  % @table_size) +
     (node.goals_zone.number  % @table_size) +
     (node.pusher_zone.number % @table_size)
    ) % @table_size
  end
end
