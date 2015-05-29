require 'spec_helper'

describe NodeChildrenToGoalsService do

  describe '#run (first level)', :focus => true do
    it '#levels' do
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

      child_levels.each do |child|
        puts child[:level].to_s
        puts child[:pushes].to_s
      end

      # child_levels.count.should == 3
      # child_levels.collect(&:class).should == [Level, Level, Level]

      # child_levels[0].to_s.should == "    #####          \n"\
      #                                "    #   #          \n"\
      #                                "    #$  #          \n"\
      #                                "  ###  $##         \n"\
      #                                "  #  $$@ #         \n"\
      #                                "### # ## #   ######\n"\
      #                                "#   # ## #####  ..#\n"\
      #                                "# $  $          ..#\n"\
      #                                "##### ### # ##  ..#\n"\
      #                                "    #     #########\n"\
      #                                "    #######        "

      # child_levels[1].to_s.should == "    #####          \n"\
      #                                "    #   #          \n"\
      #                                "    #$  #          \n"\
      #                                "  ###  $##         \n"\
      #                                "  #  $ $ #         \n"\
      #                                "### # ## #   ######\n"\
      #                                "#   # ## #####  ..#\n"\
      #                                "# $ $@          ..#\n"\
      #                                "##### ### # ##  ..#\n"\
      #                                "    #     #########\n"\
      #                                "    #######        "

      # child_levels[2].to_s.should == "    #####          \n"\
      #                                "    #   #          \n"\
      #                                "    #$  #          \n"\
      #                                "  ###  $##         \n"\
      #                                "  #  $ $ #         \n"\
      #                                "### # ## #   ######\n"\
      #                                "#   #$## #####  ..#\n"\
      #                                "# $  @          ..#\n"\
      #                                "##### ### # ##  ..#\n"\
      #                                "    #     #########\n"\
      #                                "    #######        "
    end

    # it '#nodes' do
    #   child_nodes = @service.nodes

    #   child_nodes.count.should == 3
    #   child_nodes.collect(&:class).should == [Node, Node, Node]

    #   child_nodes[0].to_s.should == "    #####          \n"\
    #                                 "    #   #          \n"\
    #                                 "    #$  #          \n"\
    #                                 "  ###  $##         \n"\
    #                                 "  #  $$@ #         \n"\
    #                                 "### # ## #   ######\n"\
    #                                 "#   # ## #####  ..#\n"\
    #                                 "# $  $          ..#\n"\
    #                                 "##### ### # ##  ..#\n"\
    #                                 "    #     #########\n"\
    #                                 "    #######        "

    #   child_nodes[1].to_s.should == "    #####          \n"\
    #                                 "    #   #          \n"\
    #                                 "    #$  #          \n"\
    #                                 "  ###  $##         \n"\
    #                                 "  #  $ $@#         \n"\
    #                                 "### # ## #   ######\n"\
    #                                 "#   # ## #####  ..#\n"\
    #                                 "# $ $           ..#\n"\
    #                                 "##### ### # ##  ..#\n"\
    #                                 "    #     #########\n"\
    #                                 "    #######        "

    #   child_nodes[2].to_s.should == "    #####          \n"\
    #                                 "    #   #          \n"\
    #                                 "    #$  #          \n"\
    #                                 "  ###  $##         \n"\
    #                                 "  #@ $ $ #         \n"\
    #                                 "### # ## #   ######\n"\
    #                                 "#   #$## #####  ..#\n"\
    #                                 "# $             ..#\n"\
    #                                 "##### ### # ##  ..#\n"\
    #                                 "    #     #########\n"\
    #                                 "    #######        "
    # end
  end
end
