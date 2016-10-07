require 'spec_helper'

describe TreeNodePathService do

  it '#run (simple example)' do
    level = Level.new("#######\n"\
                      "#     #\n"\
                      "#  $  #\n"\
                      "#@    #\n"\
                      "#*.####\n"\
                      "#**#   \n"\
                      "####   ")

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "rrruLulDD"
  end


  it '#run (more complex example)' do
    level = Level.new("#######\n"\
                      "#     #\n"\
                      "#  $$ #\n"\
                      "# $ $@#\n"\
                      "#..####\n"\
                      "#..#   \n"\
                      "####   ")

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "uullldDDuuurrrddLLLulDDruuurrDrdLLLulDrrruLulDD"
  end

  it '#run (pusher need to be smart and move boxes around)' do
    level = Level.new("  #####\n"\
                      "  #.  #\n"\
                      "###   #\n"\
                      "# $*$ #\n"\
                      "#   ###\n"\
                      "#@ .#  \n"\
                      "##### ")

    solver    = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "rruUUrrdLulDDlluR"
  end

  it '#run (first simplified level)' do
    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #$  #          \n"\
                      "  ###   ##         \n"\
                      "  #  $ $ #         \n"\
                      "### # ## #   ######\n"\
                      "#   # ## #####  ..#\n"\
                      "# $             ..#\n"\
                      "##### ### #@##    #\n"\
                      "    #     #########\n"\
                      "    #######        ")

    solver = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "ullllllllulldRRRRRRRRRRRRRRRdrUllllllllluuuLullDDDuulldddrRRRRRRRRRRRRlllllllluuululuulDDDDDuulldddrRRRRRRRRRRRdrUlllllllluuulLulDDDuulldddrRRRRRRRRRRR"
  end

  it '#run on a tricky example' do
    level = Level.new("#######\n"\
                      "#   $.#\n"\
                      "#  $@.#\n"\
                      "#  #  #\n"\
                      "#######")

    solver = IdaStarSolver.new(level)
    tree_node = solver.run

    TreeNodePathService.new(tree_node).run.should == "LulldRRRluR"
  end
end


