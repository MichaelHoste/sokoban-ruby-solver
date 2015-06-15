require 'spec_helper'

describe AStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 97
    solver.penalties.size.should           == 5
    solver.processed_penalties.size.should == 436
    solver.tries.should                    == 9
    solver.total_tries.should              == 1074
  end

  it '#run first level without penalties' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level, nil, Float::INFINITY, false)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 97
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 29
    solver.total_tries.should              == 29
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
    solver = AStarSolver.new(level)
    solver.run

    solver.found.should                    == true
    solver.pushes.should                   == 25
    solver.penalties.size.should           == 23
    solver.processed_penalties.size.should == 76
    solver.tries.should                    == 69
    solver.total_tries.should              == 2548
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
    solver = AStarSolver.new(level)
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
    solver = AStarSolver.new(level)
    solver.run

    solver.found.should                    == false
    solver.pushes.should                   == Float::INFINITY
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
    solver.tries.should                    == 1
    solver.total_tries.should              == 1
  end

end
