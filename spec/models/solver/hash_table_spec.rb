require 'spec_helper'

describe HashTable do
  it '.initialize' do
    hash_table = HashTable.new
    hash_table.instance_variable_get('@table').size.should == hash_table.table_size
  end

  it '#include?' do
    level_1 = Pack.new('spec/support/files/level.slc').levels[0]
    node_1  = Node.new(level_1)

    level_2 = level_1.clone
    level_2.move('u')
    node_2  = Node.new(level_2)

    level_3 = level_2.clone
    6.times { level_3.move('l') }
    node_3  = Node.new(level_3)

    hash_table = HashTable.new
    hash_table.add(node_1)

    hash_table.include?(node_1).should == true
    hash_table.include?(node_2).should == true  # because pusher is still
                                                # on same pusher_zone
    hash_table.include?(node_3).should == false
  end

  it '#add' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = Node.new(level)

    hash_table = HashTable.new
    hash_table.add(node)

    hash_table.include?(node).should == true
  end

  it '#remove' do
    level_1 = Pack.new('spec/support/files/level.slc').levels[0]
    node_1  = Node.new(level_1)

    level_2 = level_1.clone
    level_2.move('u')
    6.times { level_2.move('l') }
    node_2  = Node.new(level_2)

    hash_table = HashTable.new
    hash_table.add(node_1)
    hash_table.add(node_2)

    hash_table.include?(node_1).should == true
    hash_table.include?(node_2).should == true

    hash_table.remove(node_1)

    hash_table.include?(node_1).should == false
    hash_table.include?(node_2).should == true
  end

  it '#size' do
    level_1 = Pack.new('spec/support/files/level.slc').levels[0]
    node_1  = Node.new(level_1)

    level_2 = level_1.clone
    level_2.move('u')
    node_2  = Node.new(level_2)

    hash_table = HashTable.new
    hash_table.add(node_1)
    hash_table.add(node_2)

    hash_table.size.should == 2
  end
end
