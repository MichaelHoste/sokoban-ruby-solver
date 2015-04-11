require 'spec_helper'

describe Solver do

  it '#run (first level)', :focus => true do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    Solver.new(level).run
  end

  it '#run (simple level)', :pending => true do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)

    Solver.new(level).run
  end

end
