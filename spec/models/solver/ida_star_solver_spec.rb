require 'spec_helper'

describe IdaStarSolver, :focus => true do

  it '#run (first level)'  do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = IdaStarSolver.new(level)
    solver.run

    solver.tries.should == 6795
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

    solver.tries.should == 147
  end

end
