require 'spec_helper'

describe Solver do

  it '#run', :focus => true do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    Solver.new(level).run
  end

end
