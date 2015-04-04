require 'spec_helper'

describe LevelDistancesService do

  i = Float::INFINITY

  context '#run :for_level' do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#@  #  \n"\
           "#####  "

    level = Level.new(text)

    distances = LevelDistancesService.new(level)
                                     .run(:for_level)

    # distances[pusher_pos][box_pos][goal_pos]

    it 'return infinity when outside' do
      distances[0][1][2].should == i
    end

    it 'works on specific cases' do
      distances[17][24][31].should == 1
      distances[17][24][17].should == 3
      distances[17][24][10].should == 4
      distances[17][24][9].should  == i
      distances[17][24][11].should == i

      distances[38][24][31].should == 3
      distances[38][24][17].should == 1
      distances[38][24][10].should == 2
    end

    it 'returns infinity when pusher is on a box' do
      distances[17][17][11].should == i
    end
  end

  context '#run :for_zone' do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#@  #  \n"\
           "#####  "

    level = Level.new(text)

    distances = LevelDistancesService.new(level)
                                     .run(:for_zone)

    # distances[pusher_pos][box_pos][goal_pos]

    it 'works on specific cases' do
      distances[3][8][13].should == 1
      distances[3][8][3].should  == 3
      distances[3][8][0].should  == 4
      distances[3][8][1].should  == i
      distances[3][8][2].should  == i

      distances[16][8][13].should == 3
      distances[16][8][3].should  == 1
      distances[16][8][0].should  == 2
      distances[16][8][1].should  == i
    end

    it 'returns infinity when pusher is on a box' do
      distances[3][3][1].should == i
    end
  end
end
