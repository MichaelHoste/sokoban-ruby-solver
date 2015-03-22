require 'spec_helper'

describe GoalsDistanceService do
  # before :all do
  #   @level = Pack.new('spec/support/files/level.slc').levels[0]
  # end

  context "#valid?" do
    it "positive" do
      text =  "    #####          \n"\
              "    #   #          \n"\
              "    #   #          \n"\
              "  ###  $##         \n"\
              "  #      #         \n"\
              "### # ## #   ######\n"\
              "#   # ## #####    #\n"\
              "#                 #\n"\
              "##### ### #@##    #\n"\
              "    #     #########\n"\
              "    #######        "

      level = Level.new(text)
      expect { GoalsDistanceService.new(level).should }.to_not raise_error
    end

    it "negative" do
      level = Pack.new('spec/support/files/level.slc').levels[0]

      message = 'Error: Assume the level contains only one box and no goals'
      expect { GoalsDistanceService.new(level).should }.to raise_error message
    end
  end

  it '#run' do
    text = "  #####\n"\
           "  #.  #\n"\
           "###   #\n"\
           "#  *  #\n"\
           "#   ###\n"\
           "#@ .#  \n"\
           "#####  "

    level = Level.new(text)

    #GoalsDistanceService.new(level).run.should == [
    #  []
    #]
  end
end
