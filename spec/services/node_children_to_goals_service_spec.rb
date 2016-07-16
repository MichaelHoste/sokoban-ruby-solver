require 'spec_helper'

describe NodeChildrenToGoalsService do

  it '#run' do
    text =  "#########  \n"\
            "# .     #  \n"\
            "#   $   ###\n"\
            "#        .#\n"\
            "# $     ###\n"\
            "#      @#  \n"\
            "#########  "

    level = Level.new(text)

    node    = level.to_node
    service = NodeChildrenToGoalsService.new(node).run

    child_levels = service.levels

    child_levels.count.should == 4
    child_levels.collect { |l| l[:level].class }.should == [Level, Level, Level, Level]

    child_levels[0][:level].to_s.should == "#########  \n"\
                                           "# *@    #  \n"\
                                           "#       ###\n"\
                                           "#        .#\n"\
                                           "# $     ###\n"\
                                           "#       #  \n"\
                                           "#########  "
    child_levels[0][:pushes].should == 3

    child_levels[1][:level].to_s.should == "#########  \n"\
                                           "# .     #  \n"\
                                           "#       ###\n"\
                                           "#       @*#\n"\
                                           "# $     ###\n"\
                                           "#       #  \n"\
                                           "#########  "
    child_levels[1][:pushes].should == 6

    child_levels[2][:level].to_s.should == "#########  \n"\
                                           "# *     #  \n"\
                                           "# @ $   ###\n"\
                                           "#        .#\n"\
                                           "#       ###\n"\
                                           "#       #  \n"\
                                           "#########  "
    child_levels[2][:pushes].should == 3

    child_levels[3][:level].to_s.should == "#########  \n"\
                                           "# .     #  \n"\
                                           "#   $   ###\n"\
                                           "#       @*#\n"\
                                           "#       ###\n"\
                                           "#       #  \n"\
                                           "#########  "
    child_levels[3][:pushes].should == 8
  end

  it '#run (2)' do
    text =  "    #####          \n"\
            "    #   #          \n"\
            "    #$  #          \n"\
            "  ###   ##         \n"\
            "  #      #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####  ..#\n"\
            "# $             ..#\n"\
            "##### ### #@##  ..#\n"\
            "    #     #########\n"\
            "    #######        "

    level = Level.new(text)

    node    = level.to_node
    service = NodeChildrenToGoalsService.new(node).run

    child_levels = service.levels

    child_levels.count.should == 12
  end

  it '#run (3)' do
    text = "        #####\n"\
           "#########   #\n"\
           "#  ....*+   #\n"\
           "#   #$###   #\n"\
           "###     #   #\n"\
           "  #     #   #\n"\
           "  #     #####\n"\
           "  #######    "

    level = Level.new(text)

    node         = level.to_node
    child_levels = NodeChildrenToGoalsService.new(node).run.nodes

    child_levels.count.should == 5
  end

  it '#run (4)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level        = Level.new(text)
    node         = level.to_node
    child_levels = NodeChildrenToGoalsService.new(node).run.levels

    child_levels.count.should == 2

    child_levels[0][:level].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#  @*###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    child_levels[0][:pushes].should == 8

    child_levels[1][:level].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #@   #\n"\
                                           "  #* ###\n"\
                                           "  ####  "
    child_levels[1][:pushes].should == 11
  end

  it '#run (5)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "###$#@ #\n"\
            "  #    #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level        = Level.new(text)
    node         = level.to_node
    child_levels = NodeChildrenToGoalsService.new(node).run.levels

    child_levels.count.should == 3

    child_levels[0][:level].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#  @*###\n"\
                                           "### #  #\n"\
                                           "  #    #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    child_levels[0][:pushes].should == 4

    child_levels[1][:level].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#   .###\n"\
                                           "### #  #\n"\
                                           "  #    #\n"\
                                           "  #@ $ #\n"\
                                           "  #* ###\n"\
                                           "  ####  "
    child_levels[1][:pushes].should == 7

    child_levels[2][:level].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#   .###\n"\
                                           "###$#  #\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #*@###\n"\
                                           "  ####  "
    child_levels[2][:pushes].should == 3
  end
end
