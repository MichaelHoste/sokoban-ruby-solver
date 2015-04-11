class HashTable

  SIZE = 83609 # prime number not too close to a power of 2 and close to the
               # to te wanted elements we want to store

  def initialize
    @table = Array.new(SIZE) { Array.new }
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
  end

  def remove(node)
    node_index = index(node)

    @table[node_index].each_with_index do |node_from_table, i|
      if node_from_table == node
        @table[node_index].delete_at(i)
      end
    end
  end

  private

  def index(node)
    (
     (node.boxes_zone.zone  % SIZE) +
     (node.goals_zone.zone  % SIZE) +
     (node.pusher_zone.zone % SIZE)
    ) % SIZE
  end
end
