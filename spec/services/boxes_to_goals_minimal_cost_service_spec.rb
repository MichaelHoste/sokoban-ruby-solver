require 'spec_helper'

describe BoxesToGoalsMinimalCostService do

  i = Float::INFINITY

  it '#run (1) - first level' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run.should == 95
  end

  it "#run (2) - situation where boxes should be pushed to the farther goal "\
     "to minimize cost" do
    text =  "#########  \n"\
            "# .     #  \n"\
            "#   $   ###\n"\
            "#        .#\n"\
            "# $     ###\n"\
            "#      @#  \n"\
            "#########  \n"

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run.should == 9
  end

end