require 'spec_helper'

describe LevelComplexityService do

  it '#run (1) - first level' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    LevelComplexityService.new(level).run.should == 91
  end

end
