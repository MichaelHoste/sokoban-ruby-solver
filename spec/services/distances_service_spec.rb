require 'spec_helper'

describe DistancesService do

  i = Float::INFINITY

  context "#valid?" do
    it 'positive' do
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
      expect { DistancesService.new(level).should }.to_not raise_error
    end

    it 'negative because of goals and boxes' do
      level = Pack.new('spec/support/files/level.slc').levels[0]

      message = 'Error: Assumes the level contains only one box and one pusher (no goals)'
      expect { DistancesService.new(level).should }.to raise_error message
    end
  end

  it '#run (1)' do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#@  #  \n"\
           "#####  "

    level = Level.new(text)
    DistancesService.new(level).run(:for_zone).should == [       2, i, i,
                                                                 1, i, i,
                                                           4, 3, 0, 1, 2,
                                                           i, i, 3,
                                                           i, i, 4        ]

    DistancesService.new(level).run(:for_level).should == [ i, i, i, i, i, i, i,
                                                            i, i, i, 2, i, i, i,
                                                            i, i, i, 1, i, i, i,
                                                            i, 4, 3, 0, 1, 2, i,
                                                            i, i, i, 3, i, i, i,
                                                            i, i, i, 4, i, i, i,
                                                            i, i, i, i, i, i, i ]
  end

  it '#run (2)' do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "# @$  #\n"\
           "#   ###\n"\
           "#   #  \n"\
           "#####  "

    level = Level.new(text)
    DistancesService.new(level).run.should == [       2, i, i,
                                                      1, i, i,
                                                4, 3, 0, 1, 2,
                                                i, i, 3,
                                                i, i, 4        ]
  end

  it '#run (3)' do
    text = "  #####\n"\
           "  #   #\n"\
           "###  @#\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#   #  \n"\
           "#####  "

    level = Level.new(text)
    DistancesService.new(level).run.should == [       4, i, i,
                                                      3, i, i,
                                                2, 1, 0, 3, 4,
                                                i, i, 1,
                                                i, i, 2        ]
  end

  it '#run (4)' do
    text = "########\n"\
           "#   #  #\n"\
           "#    @ #\n"\
           "####   #\n"\
           "   #$ ##\n"\
           "   #  # \n"\
           "   #### "

    level = Level.new(text)

    DistancesService.new(level).run(:for_zone).should == [ i, i, i,    8, 9,
                                                           5, 4, 3, 2, 7, 8,
                                                                    1, 8, 9,
                                                                    0, 9,
                                                                    1, 10 ]

    DistancesService.new(level).run(:for_level).should == [ i, i, i, i, i, i,  i, i,
                                                            i, i, i, i, i, 8,  9, i,
                                                            i, 5, 4, 3, 2, 7,  8, i,
                                                            i, i, i, i, 1, 8,  9, i,
                                                            i, i, i, i, 0, 9,  i, i,
                                                            i, i, i, i, 1, 10, i, i,
                                                            i, i, i, i, i, i,  i, i ]
  end
end
