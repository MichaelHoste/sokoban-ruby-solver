require 'spec_helper'

describe IdaStarSolver do

  xit '#run (complex level)', :slow => true do
    text = "################ \n"\
           "#              # \n"\
           "# # ######     # \n"\
           "# #  $ $ $ $#  # \n"\
           "# #   $@$   ## ##\n"\
           "# #  $ $ $###...#\n"\
           "# #   $ $  ##...#\n"\
           "# ##\#$$$ $ ##...#\n"\
           "#     # ## ##...#\n"\
           "#####   ## ##...#\n"\
           "    #####     ###\n"\
           "        #     #  \n"\
           "        #######  "
    # because #$$ == interpolation of process id

    level = Level.new(text)

    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should            == true
    solver.tries.should            == 64
    solver.pushes.should           == 64
    solver.penalties.size.should   == 3
    solver.total_nodes.size.should == 0
  end

  xit '#run (first level)', :slow => true do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should            == true
    solver.tries.should            == 98
    solver.pushes.should           == 97
    solver.penalties.size.should   == 6
    solver.total_nodes.size.should == 0
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

    solver.found.should            == true
    solver.tries.should            == 64
    solver.pushes.should           == 64
    solver.penalties.size.should   == 0
    solver.total_nodes.size.should == 663
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

    solver.found.should            == true
    solver.tries.should            == 49
    solver.pushes.should           == 49
    solver.penalties.size.should   == 0
    solver.total_nodes.size.should == 180
  end

  it '#run (very *very* simplified level)' do
    text =  "    #####          \n"\
            "    #@  #          \n"\
            "    #   #          \n"\
            "  ###$  ##         \n"\
            "  #    $ #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####   .#\n"\
            "#                .#\n"\
            "##### ### # ##    #\n"\
            "    #     #########\n"\
            "    #######        "

    level = Level.new(text)
    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should            == true
    solver.tries.should            == 35
    solver.pushes.should           == 34
    solver.penalties.size.should   == 0
    solver.total_nodes.size.should == 35
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

    solver.found.should            == true
    solver.tries.should            == 458
    solver.pushes.should           == 25
    solver.penalties.size.should   == 8
    solver.total_nodes.size.should == 2451
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

    solver.found.should            == true
    solver.tries.should            == 5
    solver.pushes.should           == 5
    solver.penalties.size.should   == 0
    solver.total_nodes.size.should == 5
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

    solver.found.should            == false
    solver.tries.should            == 101 # 1 push + 100 loop_tries used to detect impossible solution
    solver.pushes.should           == Float::INFINITY
    solver.penalties.size.should   == 0
    solver.total_nodes.size.should == 202
  end

end
