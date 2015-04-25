require 'spec_helper'

describe IdaStarSolver do

  it '#run (first level)'  do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should  == 6799
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
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should  == 759
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
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should  == 5
    solver.pushes.should == 5
  end

end
