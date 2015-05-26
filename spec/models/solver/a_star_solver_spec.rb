require 'spec_helper'

describe AStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level, nil, Float::INFINITY, false)
    solver.run

    solver.found.should                    == true
    solver.tries.should                    == 4883
    solver.pushes.should                   == 97
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
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
    solver.tries.should                    == 79
    solver.pushes.should                   == 25
    solver.penalties.size.should           == 22
    solver.processed_penalties.size.should == 92
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
    solver.tries.should                    == 5
    solver.pushes.should                   == 5
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
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
    solver.tries.should                    == 1
    solver.pushes.should                   == Float::INFINITY
    solver.penalties.size.should           == 0
    solver.processed_penalties.size.should == 0
  end

end
