require 'spec_helper'

describe NodeChildsService do

  describe '#run', :focus => true do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = level.to_node

    puts node.to_s

    puts NodeChildsService.new(node).run
  end

end
