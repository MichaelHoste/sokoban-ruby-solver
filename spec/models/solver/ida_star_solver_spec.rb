require 'spec_helper'

describe IdaStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 97, 5, 436, 9, 1074]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 64, 0, 39, 5, 68]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 49, 0, 7, 3, 12]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 34, 0, 0, 2, 2]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 25, 18, 71, 268, 2545]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 5, 0, 0, 2, 2]
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

    # 1 push + 100 loop_tries used to detect impossible solution

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [false, Float::INFINITY, 0, 0, 101, 101]
  end

  it '#run on a complex level of Dimitri-Yorick pack' do
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 20, 25, 500, 8, 1292]

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

    solver.penalties.include?(penalty[:node]).should == true
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 64, 3, 0, 64, 1111]
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

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 32, 1250, 3347, 57, 1215309]
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


    [ global_found,
      global_pushes,
      global_penalties.size,
      global_processed_penalties.size,
      global_tries,
      global_total_tries ].should == [true, 32, 1250, 3347, 57, 1215309]
  end
end
