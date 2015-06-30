require 'spec_helper'

describe IdaStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 97
    solver.penalties.size.should           == 5
    solver.processed_penalties.size.should == 436
    solver.tries.should                    == 9
    solver.total_tries.should              == 1074
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
    solver.processed_penalties.size.should == 39
    solver.tries.should                    == 5
    solver.total_tries.should              == 68
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
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 7
    solver.tries.should                    == 3
    solver.total_tries.should              == 12
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
    solver.tries.should                    == 2
    solver.total_tries.should              == 2
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
    solver.penalties.size.should           == 18
    solver.processed_penalties.size.should == 71
    solver.tries.should                    == 268
    solver.total_tries.should              == 2545
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
    solver.tries.should                    == 2
    solver.total_tries.should              == 2
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

  xit '#run (complex level)', :slow do
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

  it '#run a specific level of Dimitri-Yorick pack', :slow do
    text = "        #####\n"\
           "#########   #\n"\
           "#  ......$  #\n"\
           "#   #$###   #\n"\
           "### $@$ #   #\n"\
           "  # $ $ #   #\n"\
           "  #     #####\n"\
           "  #######    "

    level = Level.new(text)

    solver = IdaStarSolver.new(level)
    solver.run

    puts solver.found.to_s
    puts solver.pushes.to_s
    puts solver.penalties.size.to_s
    puts solver.processed_penalties.size.to_s
    puts solver.tries.to_s
    puts solver.total_tries.to_s

    # Avec goals
    # true
    # 32
    # 1493
    # 3239
    # 30
    # 2295636

    solver.found.should                    == true
    solver.pushes.should                   == 32
    solver.penalties.size.should           == 1250
    solver.processed_penalties.size.should == 3347
    solver.tries.should                    == 57
    solver.total_tries.should              == 1215309
  end

  xit '#run on complete Dimitri-Yorick pack', :slow do
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

  it '#run on a complex level of Dimitri-Yorick pack', :slow do
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

end
