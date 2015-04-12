require 'spec_helper'

describe Solver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = Solver.new(level)
    run    = solver.run

    run.tries.should == 25453
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
    solver = Solver.new(level)
    run    = solver.run

    run.tries.should == 166
  end

end
