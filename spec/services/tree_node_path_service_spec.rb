require 'spec_helper'

describe TreeNodePathService do

  it '#run (simple example)' do
    text =  "#######\n"\
            "#     #\n"\
            "#  $  #\n"\
            "#@    #\n"\
            "#*.####\n"\
            "#**#   \n"\
            "####   "

    level = Level.new(text)

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "rrruLulDD"
  end


  it '#run (more complex example)' do
    text =  "#######\n"\
            "#     #\n"\
            "#  $$ #\n"\
            "# $ $@#\n"\
            "#..####\n"\
            "#..#   \n"\
            "####   "

    level = Level.new(text)

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "uullldDDuuurrrddLLLulDDruuurrDrdLLLulDrrruLulDD"
  end

  it '#run (pusher need to be smart and move boxes around)' do
    text =  "  #####\n"\
            "  #.  #\n"\
            "###   #\n"\
            "# $*$ #\n"\
            "#   ###\n"\
            "#@ .#  \n"\
            "##### "

    level = Level.new(text)

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "rruUUrrdLulDDlluR"
  end

  it '#run (first simplified level)' do
    text =  "    #####          \n"\
            "    #   #          \n"\
            "    #$  #          \n"\
            "  ###   ##         \n"\
            "  #  $ $ #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####  ..#\n"\
            "# $             ..#\n"\
            "##### ### #@##    #\n"\
            "    #     #########\n"\
            "    #######        "

    level  = Level.new(text)

    solver = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "ullllllllulldRRRRRRRRRRRRRRRdrUllllllllluuuLullDDDuulldddrRRRRRRRRRRRRlllllllluuululuulDDDDDuulldddrRRRRRRRRRRRdrUlllllllluuulLulDDDuulldddrRRRRRRRRRRR"
  end
end


