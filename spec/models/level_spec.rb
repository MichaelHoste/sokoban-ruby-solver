require 'spec_helper'

describe Level do
  before :each do
    @level = Pack.new('data/Original.slc').levels[0]
  end

  it '.initialize' do
    @level.name.should == '1'
  end
end
