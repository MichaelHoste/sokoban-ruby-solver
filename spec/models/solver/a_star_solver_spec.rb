require 'spec_helper'

describe AStarSolver do

  it '#run (first level)', :focus => true do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level)
    solver.run

    solver.tries.should  == 4883
    solver.pushes.should == 97
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

    solver.tries.should  == 129
    solver.pushes.should == 25
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

    solver.tries.should  == 5
    solver.pushes.should == 5
  end

end
