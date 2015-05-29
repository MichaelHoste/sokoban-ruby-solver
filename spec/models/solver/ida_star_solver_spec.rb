require 'spec_helper'

describe IdaStarSolver do

  xit '#run (complex level)' do
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

    solver.found.should                    == true
    solver.pushes.should                   == 64
    solver.penalties.size.should           == 3
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 64
    solver.total_tries.should              == 1111
  end

  it '#run on complete Dimitri-Yorick pack', :slow => true, :focus => true do
    pack = Pack.new('data/Dimitri-Yorick.slc')

    global_found               = 0
    global_pushes              = 0
    global_penalties           = 0
    global_processed_penalties = 0
    global_tries               = 0
    global_total_tries         = 0

    pack.levels.each do |level|
      solver = IdaStarSolver.new(level)
      solver.run

      global_found               &&= global_found
      global_pushes              +=  solver.pushes
      global_penalties           +=  solver.penalties.size
      global_processed_penalties +=  solver.processed_penalties.size
      global_tries               +=  solver.tries
      global_total_tries         +=  solver.total_tries
    end

    puts global_found
    puts global_pushes
    puts global_penalties
    puts global_processed_penalties
    puts global_tries
    puts global_total_tries

    global_found.should                    == true
    global_pushes.should                   == 20
    global_penalties.size.should           == 73
    global_processed_penalties.size.should == 1456
    global_tries.should                    == 22
    global_total_tries.should              == 9727
  end

  it '#run on a complex level of Dimitri-Yorick pack', :slow => true do
   text =  "########\n"\
           "#......#\n"\
           "# $##$ #\n"\
           "#  ##  #\n"\
           "# $$@$$#\n"\
           "#      #\n"\
           "#   #  #\n"\
           "########"

    level = Level.new(text)

    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 20
    solver.penalties.size.should           == 73
    solver.processed_penalties.size.should == 1456
    solver.tries.should                    == 22
    solver.total_tries.should              == 9727

    # Be sure that this penalty is computed
    penalty = {
      :node  => Level.new("########\n"\
                          "#+.....#\n"\
                          "#  ##$ #\n"\
                          "#  ##$ #\n"\
                          "#      #\n"\
                          "#      #\n"\
                          "#   #  #\n"\
                          "########").to_node,
      :value => Float::INFINITY
    }

    solver.penalties.should include(penalty)
  end

  it '#run (first level)', :slow => true do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 97
    solver.penalties.size.should           == 7
    solver.processed_penalties.size.should == 2727
    solver.tries.should                    == 97
    solver.total_tries.should              == 86555
  end

  it '#run (little bit simplified first level)' do
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

    solver.found.should                    == true
    solver.pushes.should                   == 64
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 291
    solver.tries.should                    == 64
    solver.total_tries.should              == 6294
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

    solver.found.should                    == true
    solver.pushes.should                   == 49
    solver.total_tries.should              == 1280
    solver.penalties.size.should           == 0
    solver.tries.should                    == 49
    solver.processed_penalties.size.should == 74
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

    solver.found.should                    == true
    solver.pushes.should                   == 34
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 35
    solver.total_tries.should              == 35
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

    solver.found.should                    == true
    solver.pushes.should                   == 25
    solver.penalties.size.should           == 16
    solver.processed_penalties.size.should == 86
    solver.tries.should                    == 253
    solver.total_tries.should              == 2471
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

    solver.found.should                    == true
    solver.pushes.should                   == 5
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 5
    solver.total_tries.should              == 5
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

    solver.found.should                    == false
    solver.pushes.should                   == Float::INFINITY
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 101 # 1 push + 100 loop_tries used to detect impossible solution
    solver.total_tries.should              == 101
  end

end
