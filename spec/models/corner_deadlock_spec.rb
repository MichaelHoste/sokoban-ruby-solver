require 'spec_helper'

describe CornerDeadlock do
  it "should detect deadlock positions of a level" do
    level     = Pack.new('data/Original.slc').levels[0]
    positions = CornerDeadlock.new(level).deadlock_positions
    positions.count.should == 15
  end
end
