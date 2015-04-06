# Find childs of a node (nodes created by 1 box push from this node)

class NodeChildsService

  def initialize(node)
    @node        = node
    @level       = node.level
    @cols        = @level.cols
    @rows        = @level.rows
    @pusher_zone = node.pusher_zone
    @goals_zone  = node.goals_zone
    @boxes_zone  = node.boxes_zone
  end

  def run
    # childs = []

    # reachable_boxes_zone = @pusher_zone & @boxes_zone

    # # create special level where pusher_zone represents goals
    # # and only reachable boxes are presents
    # stripped_node = Node.new([
    #   reachable_boxes_zone,
    #   @pusher_zone,
    #   @pusher_zone
    # ])
    # stripped_level = Level.new(stripped_node)

    # (0..@rows-1).each do |m|
    #   (0..@rows-1).each do |n|
    #     cell = @level.read_pos(m, n)

    #     if cell == '*'
    #       if ['+', '.'].include? @level.read_pos(m-1, n) && @level.read_pos(m+1, n) == 's'
    #         childs << Node.new([
    #           @goals_zone, @
    #         ])
    #       end
    #     end
    #   end
    # end
  end

  private

end
