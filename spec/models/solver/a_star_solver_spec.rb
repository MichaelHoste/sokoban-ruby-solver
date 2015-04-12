require 'spec_helper'

describe AStarSolver do

  it '#run (first level)'  do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level)
    solver.run

    solver.tries.should == 4883
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

    solver.tries.should == 129
  end

end