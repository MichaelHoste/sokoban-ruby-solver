require 'spec_helper'

describe AStarSolver, :pending => true do

  xit '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level)
    solver.run

    solver.tries.should  == 4883
    solver.pushes.should == 97
  end

  xit '#run (simple level)' do
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

    solver.tries.should  == 129
    solver.pushes.should == 25
  end

  xit '#run (level with less boxes than goals)' do
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

    solver.tries.should  == 5
    solver.pushes.should == 5
  end

  xit '#run (impossible level)' do
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

    solver.tries.should  == 1
    solver.pushes.should == Float::INFINITY
  end

end
