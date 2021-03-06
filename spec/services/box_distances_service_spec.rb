require 'spec_helper'

describe BoxDistancesService do

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
      expect { BoxDistancesService.new(level).should }.to_not raise_error
    end

    it 'negative because of goals and boxes' do
      level = Pack.new('spec/support/files/level.slc').levels[0]

      message = "Error: BoxDistancesService without 'box_position' assumes the level contains only one box"
      expect { BoxDistancesService.new(level).should }.to raise_error message
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

    BoxDistancesService.new(level)
                       .run(:minimum_for_zone).should == [       2, i, i,
                                                                 1, i, i,
                                                           4, 3, 0, 1, 2,
                                                           i, i, 3,
                                                           i, i, 4        ]

    BoxDistancesService.new(level)
                       .run(:minimum_for_level).should == [ i, i, i, i, i, i, i,
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
    BoxDistancesService.new(level).run.should == [       2, i, i,
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
    BoxDistancesService.new(level).run.should == [       4, i, i,
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

    BoxDistancesService.new(level).run(:minimum_for_zone).should == [ i, i, i,    8, 9,
                                                                      5, 4, 3, 2, 7, 8,
                                                                               1, 8, 9,
                                                                               0, 9,
                                                                               1, 10 ]

    BoxDistancesService.new(level).run(:minimum_for_level)
                       .should == [ i, i, i, i, i, i,  i, i,
                                    i, i, i, i, i, 8,  9, i,
                                    i, 5, 4, 3, 2, 7,  8, i,
                                    i, i, i, i, 1, 8,  9, i,
                                    i, i, i, i, 0, 9,  i, i,
                                    i, i, i, i, 1, 10, i, i,
                                    i, i, i, i, i, i,  i, i ]
  end

  it '#run (5)' do
    text =  "    #####          \n"\
            "    #   #          \n"\
            "    #   #          \n"\
            "  ###   ##         \n"\
            "  #   $  #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####    #\n"\
            "#                 #\n"\
            "##### ### #@##    #\n"\
            "    #     #########\n"\
            "    #######        "

    level = Level.new(text)

    BoxDistancesService.new(level).run
                       .should == [ 4, i, i,
                                    3, i, i,
                                    2, i, i,
                              3, 2, 1, 0, 1, 2,
                              i,    2,    i,
                        i, i, i,    3,    i,                      16, 15, 16, 17,
                        8, 7, 6, 5, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
                                    5,          i,     i,         16, 15, 16, 17,
                                    6, i, i, i, i ]
  end

  it '#run (6)' do
    text =  "#########  \n"\
            "#       #  \n"\
            "#   #   ###\n"\
            "#         #\n"\
            "# $     ###\n"\
            "#      @#  \n"\
            "#########  "

    level = Level.new(text)

    BoxDistancesService.new(level).run(:minimum_for_zone)
                       .should == [ 4, 3, 4, 5, 6, 7, 8,
                                    3, 2, 3,    5, 6, 7,
                                    2, 1, 2, 3, 4, 5, 6, 7, 8,
                                    1, 0, 1, 2, 3, 4, 5,
                                    2, 1, 2, 3, 4, 5, 6 ]
  end

  it '#run (7)' do
    text =  "  ####  \n"\
            "###@ #  \n"\
            "#    #  \n"\
            "#    ###\n"\
            "### #  #\n"\
            "  # #$ #\n"\
            "  #    #\n"\
            "  #  ###\n"\
            "  ####  "

    level = Level.new(text)

    BoxDistancesService.new(level).run(:minimum_for_zone)
                       .should == [   8, 9,
                              9,  8,  7, 8,
                              10, 9,  6, 9,
                                  5,     1, i,
                                  4,     0, i,
                                  3,  2, 1, i,
                                  12, i ]
  end

  it '#run with multiple boxes' do
    text =  "  ####  \n"\
            "###@ #  \n"\
            "#    #  \n"\
            "# $  ###\n"\
            "### #  #\n"\
            "  # #$ #\n"\
            "  #    #\n"\
            "  #  ###\n"\
            "  ####  "

    level = Level.new(text)

    BoxDistancesService.new(level, { :m => 3, :n => 2 }).run(:minimum_for_zone)
                       .should == [   i, i,
                                i, i, i, i,
                                1, 0, 1, 2,
                                     2,    i, i,
                                     3,    i, i,
                                     4, i, i, i,
                                     5, i ]

    # check the level was not modified by the service!
    level.to_s.should == text
  end

  it '#run with multiple neighbours boxes' do
    text =  "  ####  \n"\
            "###@ #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### # .#\n"\
            "  # $$ #\n"\
            "  #    #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)

    BoxDistancesService.new(level, { :m => 5, :n => 4 }).run(:minimum_for_zone)
                       .should == [   i, i,
                                i, i, i, i,
                                i, i, i, i,
                                   i,    i, i,
                                   i, 0, i, i,
                                   i, i, i, i,
                                   i, i ]

    # check the level was not modified by the service!
    level.to_s.should == text
  end

  it '#run with multiple boxes and goals' do
    text =  "  ####  \n"\
            "###+ #  \n"\
            "#    #  \n"\
            "# $  ###\n"\
            "### #  #\n"\
            "  # #$ #\n"\
            "  #* . #\n"\
            "  #  ###\n"\
            "  ####  "

    level = Level.new(text)

    BoxDistancesService.new(level, { :m => 3, :n => 2 }).run(:minimum_for_zone)
                       .should == [   i, i,
                                i, i, i, i,
                                1, 0, 1, 2,
                                      2,    i, i,
                                      3,    i, i,
                                      i, i, i, i,
                                      i, i ]

    # check the level was not modified by the service!
    level.to_s.should == text

    BoxDistancesService.new(level, { :m => 6, :n => 3 }).run(:minimum_for_zone)
                       .should == [   i, i,
                                i, i, i, i,
                                i, i, i, i,
                                      i,    i, i,
                                      i,    i, i,
                                      0, i, i, i,
                                      1, i ]

    # check the level was not modified by the service!
    level.to_s.should == text

    BoxDistancesService.new(level, { :m => 5, :n => 5 }).run(:minimum_for_zone)
                       .should == [   i, i,
                                i, i, i, i,
                                i, i, i, i,
                                      i,    i, i,
                                      i,    i, i,
                                      i, i, i, i,
                                      i, i ]

    # check the level was not modified by the service!
    level.to_s.should == text
  end
end
