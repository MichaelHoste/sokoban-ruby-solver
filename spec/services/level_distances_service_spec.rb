require 'spec_helper'

describe LevelDistancesService do

  i = Float::INFINITY

  describe '#run' do
    before :all do
      text = "  #####\n"\
             "  #   #\n"\
             "###   #\n"\
             "#  $  #\n"\
             "#   ###\n"\
             "#@  #  \n"\
             "#####  "

      @level   = Level.new(text)
      @service = LevelDistancesService.new(@level).run

      @distances_for_level = @service.distances_for_level
      @distances_for_zone  = @service.distances_for_zone
    end

    it 'return infinity when outside (for level)' do
      @distances_for_level[0][1][2].should == i
    end

    it 'works on specific cases (for level)' do
      @distances_for_level[17][24][31].should == 1
      @distances_for_level[17][24][17].should == 3
      @distances_for_level[17][24][10].should == 4
      @distances_for_level[17][24][9].should  == i
      @distances_for_level[17][24][11].should == i

      @distances_for_level[38][24][31].should == 3
      @distances_for_level[38][24][17].should == 1
      @distances_for_level[38][24][10].should == 2
    end

    it 'returns infinity when pusher is on a box (for level)' do
      @distances_for_level[17][17][11].should == i
    end

    it 'works on specific cases (for zone)' do
      @distances_for_zone[3][8][13].should == 1
      @distances_for_zone[3][8][3].should  == 3
      @distances_for_zone[3][8][0].should  == 4
      @distances_for_zone[3][8][1].should  == i
      @distances_for_zone[3][8][2].should  == i

      @distances_for_zone[16][8][13].should == 3
      @distances_for_zone[16][8][3].should  == 1
      @distances_for_zone[16][8][0].should  == 2
      @distances_for_zone[16][8][1].should  == i
    end

    it 'returns infinity when pusher is on a box (for zone)' do
      @distances_for_zone[3][3][1].should == i
    end
  end
end
