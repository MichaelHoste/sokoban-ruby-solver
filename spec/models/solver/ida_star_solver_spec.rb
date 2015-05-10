require 'spec_helper'

describe IdaStarSolver do

  xit '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    puts solver.tries
    puts solver.pushes
    puts solver.penalties.size
    puts solver.processed_penalties_nodes.size

    solver.tries.should                          == 6797
    solver.pushes.should                         == 97
    solver.penalties.size.should                 == 0
    solver.processed_penalties_nodes.size.should == 0
  end

  it '#run (little bit simplified first level)', :slow => true do
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

    level = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should                          == 64
    solver.pushes.should                         == 64
    solver.penalties.size.should                 == 12
    solver.processed_penalties_nodes.size.should == 642
  end

  it '#run (very simplified first level)' do
    text =  "    #####          \n"\
            "    #   #          \n"\
            "    #$  #          \n"\
            "  ###   ##         \n"\
            "  #    $ #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####   .#\n"\
            "# $             ..#\n"\
            "##### ### #@##    #\n"\
            "    #     #########\n"\
            "    #######        "

    level = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should                          == 49
    solver.pushes.should                         == 49
    solver.penalties.size.should                 == 2
    solver.processed_penalties_nodes.size.should == 131
  end

  it '#run (simple level)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should                          == 235
    solver.pushes.should                         == 25
    solver.penalties.size.should                 == 16
    solver.processed_penalties_nodes.size.should == 94
  end

  it '#run (level with less boxes than goals)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  #  $ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should                          == 5
    solver.pushes.should                         == 5
    solver.penalties.size.should                 == 0
    solver.processed_penalties_nodes.size.should == 0 # no penalties with 1 box
  end

  it '#run (impossible level)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#  $ #  \n"\
            "#   .###\n"\
            "###$#@.#\n"\
            "  #    #\n"\
            "  #    #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should                          == 101 # 1 push + 100 loop_tries used to detect impossible solution
    solver.pushes.should                         == Float::INFINITY
    solver.penalties.size.should                 == 0
    solver.processed_penalties_nodes.size.should == 0   # no penalties with 1 box
  end

end
