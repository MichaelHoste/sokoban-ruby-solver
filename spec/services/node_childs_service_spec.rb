require 'spec_helper'

describe NodeChildsService do

  describe '#run (first level)' do
    before :each do
      level    = Pack.new('spec/support/files/level.slc').levels[0]
      node     = level.to_node
      @service = NodeChildsService.new(node).run
    end

    it '#levels' do
      child_levels = @service.levels

      child_levels.count.should == 3
      child_levels.collect(&:class).should == [Level, Level, Level]

      child_levels[0].to_s.should == "    #####          \n"\
                                     "    #   #          \n"\
                                     "    #$  #          \n"\
                                     "  ###  $##         \n"\
                                     "  #  $$@ #         \n"\
                                     "### # ## #   ######\n"\
                                     "#   # ## #####  ..#\n"\
                                     "# $  $          ..#\n"\
                                     "##### ### # ##  ..#\n"\
                                     "    #     #########\n"\
                                     "    #######        "

      child_levels[1].to_s.should == "    #####          \n"\
                                     "    #   #          \n"\
                                     "    #$  #          \n"\
                                     "  ###  $##         \n"\
                                     "  #  $ $ #         \n"\
                                     "### # ## #   ######\n"\
                                     "#   # ## #####  ..#\n"\
                                     "# $ $@          ..#\n"\
                                     "##### ### # ##  ..#\n"\
                                     "    #     #########\n"\
                                     "    #######        "

      child_levels[2].to_s.should == "    #####          \n"\
                                     "    #   #          \n"\
                                     "    #$  #          \n"\
                                     "  ###  $##         \n"\
                                     "  #  $ $ #         \n"\
                                     "### # ## #   ######\n"\
                                     "#   #$## #####  ..#\n"\
                                     "# $  @          ..#\n"\
                                     "##### ### # ##  ..#\n"\
                                     "    #     #########\n"\
                                     "    #######        "
    end

    it '#nodes' do
      child_nodes = @service.nodes

      child_nodes.count.should == 3
      child_nodes.collect(&:class).should == [Node, Node, Node]

      child_nodes[0].to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #  $$@ #         \n"\
                                    "### # ## #   ######\n"\
                                    "#   # ## #####  ..#\n"\
                                    "# $  $          ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "

      child_nodes[1].to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #  $ $@#         \n"\
                                    "### # ## #   ######\n"\
                                    "#   # ## #####  ..#\n"\
                                    "# $ $           ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "

      child_nodes[2].to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #@ $ $ #         \n"\
                                    "### # ## #   ######\n"\
                                    "#   #$## #####  ..#\n"\
                                    "# $             ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "
    end
  end

  describe '#run (special cases)' do
    it '#run when destination is goal' do
      text =  "#######\n"\
              "#     #\n"\
              "# @$. #\n"\
              "#     #\n"\
              "#######"

      level    = Level.new(text)
      node     = level.to_node
      @service = NodeChildsService.new(node).run

      child_levels = @service.levels

      child_levels.count.should == 4

      child_levels[0].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "#  @* #\n"\
                                      "#     #\n"\
                                      "#######"

      child_levels[1].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "# $@. #\n"\
                                      "#     #\n"\
                                      "#######"

      child_levels[2].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "#  @. #\n"\
                                      "#  $  #\n"\
                                      "#######"

      child_levels[3].to_s.should ==  "#######\n"\
                                      "#  $  #\n"\
                                      "#  @. #\n"\
                                      "#     #\n"\
                                      "#######"
    end

    it '#run when box is on goal' do
      text =  "#######\n"\
              "# @   #\n"\
              "#  *  #\n"\
              "#  .  #\n"\
              "#######"

      level    = Level.new(text)
      node     = level.to_node
      @service = NodeChildsService.new(node).run

      child_levels = @service.levels

      child_levels.count.should == 4

      child_levels[0].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "#  +$ #\n"\
                                      "#  .  #\n"\
                                      "#######"

      child_levels[1].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "# $+  #\n"\
                                      "#  .  #\n"\
                                      "#######"

      child_levels[2].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "#  +  #\n"\
                                      "#  *  #\n"\
                                      "#######"

      child_levels[3].to_s.should ==  "#######\n"\
                                      "#  $  #\n"\
                                      "#  +  #\n"\
                                      "#  .  #\n"\
                                      "#######"
    end

    it '#run when other boxes on the way' do
      text =  "#######\n"\
              "#@    #\n"\
              "# $$* #\n"\
              "#     #\n"\
              "#######"

      level    = Level.new(text)
      node     = level.to_node
      @service = NodeChildsService.new(node).run

      child_levels = @service.levels

      child_levels.count.should == 6

      child_levels[0].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "# @$* #\n"\
                                      "# $   #\n"\
                                      "#######"

      child_levels[1].to_s.should ==  "#######\n"\
                                      "# $   #\n"\
                                      "# @$* #\n"\
                                      "#     #\n"\
                                      "#######"

      child_levels[2].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "# $@* #\n"\
                                      "#  $  #\n"\
                                      "#######"

      child_levels[3].to_s.should ==  "#######\n"\
                                      "#  $  #\n"\
                                      "# $@* #\n"\
                                      "#     #\n"\
                                      "#######"

      child_levels[4].to_s.should ==  "#######\n"\
                                      "#     #\n"\
                                      "# $$+ #\n"\
                                      "#   $ #\n"\
                                      "#######"

      child_levels[5].to_s.should ==  "#######\n"\
                                      "#   $ #\n"\
                                      "# $$+ #\n"\
                                      "#     #\n"\
                                      "#######"
    end

    it '#run when box against wall' do
      text =  "#######\n"\
              "#  $  #\n"\
              "#     #\n"\
              "#  @ $#\n"\
              "#######"

      level    = Level.new(text)
      node     = level.to_node
      @service = NodeChildsService.new(node).run

      child_levels = @service.levels

      child_levels.count.should == 2

      child_levels[0].to_s.should ==  "#######\n"\
                                      "#  @$ #\n"\
                                      "#     #\n"\
                                      "#    $#\n"\
                                      "#######"

      child_levels[1].to_s.should ==  "#######\n"\
                                      "# $@  #\n"\
                                      "#     #\n"\
                                      "#    $#\n"\
                                      "#######"
    end
  end
end
