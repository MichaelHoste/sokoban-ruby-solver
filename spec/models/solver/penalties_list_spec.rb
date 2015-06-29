require 'spec_helper'

describe PenaltiesList do

  it '.initialize' do
    penalties = PenaltiesList.new(4)
    penalties.instance_variable_get(:@num_of_boxes).should   == 4
    penalties.instance_variable_get(:@penalties).size.should == 4
  end

  it '#add' do
    penalties = PenaltiesList.new(4)
    penalties.size.should == 0

    node_1 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#      .#\n"\
                       "# $   ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_2 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#   $  .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_3 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#  $$ ###\n"\
                       "#      .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    penalties.add(
      :node  => node_1,
      :value => 4
    )

    penalties.add(
      :node  => node_2,
      :value => 5
    )

    penalties.add(
      :node  => node_3,
      :value => 3
    )

    # Sorted from the biggest penalty to the lower penalty
    penalties.all[0][:value].should == 5
    penalties.all[1][:value].should == 4
    penalties.all[2][:value].should == 3

    penalties.size.should == 3
  end

  context 'iterator' do
    penalties = PenaltiesList.new(4)

    node_1 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#      .#\n"\
                       "# $   ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_2 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#   $  .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_3 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#  $$ ###\n"\
                       "#   $  .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    # 2 boxes
    penalties.add(
      :node  => node_1,
      :value => 4
    )

    penalties.add(
      :node  => node_2,
      :value => 5
    )

    # 3 boxes
    penalties.add(
      :node  => node_3,
      :value => 3
    )

    it '#each' do
      i = 0
      penalties.each do |penalty_list|
        penalty_list.size.should == 0 if i == 0
        penalty_list.size.should == 2 if i == 1
        penalty_list.size.should == 1 if i == 2
        penalty_list.size.should == 0 if i == 3
        i += 1
      end
    end

    it '#reverse_each' do
      i = 0
      penalties.reverse_each do |penalty_list|
        penalty_list.size.should == 0 if i == 0
        penalty_list.size.should == 1 if i == 1
        penalty_list.size.should == 2 if i == 2
        penalty_list.size.should == 0 if i == 3
        i += 1
      end
    end
  end

  it '#all' do
    # tested in '#add' and in 'penalties_service_spec.rb'
  end

  it '#include' do
    penalties = PenaltiesList.new(4)

    node_1 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#      .#\n"\
                       "# $   ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_2 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#   $ ###\n"\
                       "#   $  .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_3 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#  $$ ###\n"\
                       "#   $  .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    node_4 = Level.new("#######  \n"\
                       "# .   #  \n"\
                       "#  $$ ###\n"\
                       "# $    .#\n"\
                       "#     ###\n"\
                       "#    @#  \n"\
                       "#######  ").to_node

    penalties.add(
      :node  => node_1,
      :value => 4
    )

    penalties.add(
      :node  => node_2,
      :value => 5
    )

    penalties.add(
      :node  => node_3,
      :value => 3
    )

    penalties.include?(node_1).should == true
    penalties.include?(node_2).should == true
    penalties.include?(node_3).should == true
    penalties.include?(node_4).should == false
  end

  it '#size' do
    # tested when asserting other tests
  end

end
