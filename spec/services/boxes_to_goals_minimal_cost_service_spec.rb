require 'spec_helper'

describe BoxesToGoalsMinimalCostService do

  i = Float::INFINITY

  it '#run (1) - first level' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone

    BoxesToGoalsMinimalCostService.new(node, distances).run[:total].should == 95
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

    BoxesToGoalsMinimalCostService.new(node, distances).run[:total].should == 9
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

    BoxesToGoalsMinimalCostService.new(node, distances).run[:total].should == 11
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

    BoxesToGoalsMinimalCostService.new(node, distances).run[:total].should == 6
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

    penalties = PenaltiesList.new(3)

    penalties << {
      :node => Level.new("  ####  \n"\
                         "###  #  \n"\
                         "#    #  \n"\
                         "#   .###\n"\
                         "### #@.#\n"\
                         "  # $  #\n"\
                         "  #  $ #\n"\
                         "  #. ###\n"\
                         "  ####  ").to_node,
      :value => 3
    }

    penalties << {
      :node => Level.new("  ####  \n"\
                         "###  #  \n"\
                         "#    #  \n"\
                         "#   .###\n"\
                         "### #@.#\n"\
                         "  # $$ #\n"\
                         "  #    #\n"\
                         "  #. ###\n"\
                         "  ####  ").to_node,
      :value => 3
    }

    BoxesToGoalsMinimalCostService.new(node, distances, penalties).run[:total].should == 14
  end

  it "#run (5) - level with a lot of penalties" do
    text = "        #####\n"\
           "#########   #\n"\
           "#  ......$  #\n"\
           "#   #$###   #\n"\
           "### $@$ #   #\n"\
           "  # $ $ #   #\n"\
           "  #     #####\n"\
           "  #######    "

    level = Level.new(text)
    node  = level.to_node

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone
    penalties = PenaltiesList.new(6)

    content = File.read(File.join('spec', 'support', 'files', 'penalties.txt'))

    content.split("-----------------------------------\n").collect do |penalty_content|
      lines = penalty_content.lines
      lines.shift
      penalty_value = lines.pop.split(': ')[1].to_i

      penalties << {
        :node  => Level.new(lines.join).to_node,
        :value => penalty_value
      }
    end

    BoxesToGoalsMinimalCostService.new(node, distances, penalties).run[:total].should == 32
  end

end
