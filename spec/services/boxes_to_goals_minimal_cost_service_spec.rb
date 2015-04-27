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
            "#########  "

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run.should == 9
  end

  it "#run (3) - level with known result" do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run.should == 11
  end

  it "#run (3) - level with less boxes than goals" do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $  #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run.should == 6
  end

  it "#run (4) - level with specific penalty for 3 boxes" do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone
    penalties = PenaltiesService.new(node).run

    BoxesToGoalsMinimalCostService.new(node, distances, penalties).run.should == 11
  end

end
