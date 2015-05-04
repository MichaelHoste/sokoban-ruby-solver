require 'spec_helper'

describe IdaStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should  == 6797
    solver.pushes.should == 97
  end

  it '#run (simplified first level)', :focus => true do
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
    solver.processed_penalties_nodes.size.should == 131
  end

  it '#run (less simplified first level)' do
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

    puts solver.tries
    puts solver.pushes
    puts solver.processed_penalties_nodes.size

    solver.tries.should                          == 64
    solver.pushes.should                         == 64
    solver.processed_penalties_nodes.size.should == 967
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
    solver.processed_penalties_nodes.size.should == 14

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

    solver.tries.should                          == 101 # because of 1push + 100 loop_tries used to detect impossible solution
    solver.pushes.should                         == Float::INFINITY
    solver.processed_penalties_nodes.size.should == 1

  end

end
