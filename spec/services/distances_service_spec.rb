require 'spec_helper'

describe DistancesService do

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
      expect { DistancesService.new(level).should }.to_not raise_error
    end

    it "negative" do
      level = Pack.new('spec/support/files/level.slc').levels[0]

      message = 'Error: Assume the level contains only one box and no goals'
      expect { DistancesService.new(level).should }.to raise_error message
    end
  end

  it '#run (1)', :focus => true do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#@  #  \n"\
           "#####  "

    level = Level.new(text)
    i     = Float::INFINITY

    DistancesService.new(level).run.should == [       2, 3, 4,
                                                      1, 2, 3,
                                                2, 1, 0, 1, 2,
                                                3, 2, 1,
                                                4, 3, 2       ]

    #DistancesService.new(level).run.should == [       2, i, i,
    #                                                      1, i, i,
    #                                                4, 3, 0, 1, 2,
    #                                                i, i, 3,
    #                                                i, i, 4        ]
  end

  it '#run (2)', :pending => true do
    text = "  #####\n"\
           "  #   #\n"\
           "###   #\n"\
           "# @$  #\n"\
           "#   ###\n"\
           "#   #  \n"\
           "#####  "

    level = Level.new(text)
    i     = Float::INFINITY

    DistancesService.new(level).run.should == [       2, i, i,
                                                      1, i, i,
                                                4, 3, 0, 1, 2,
                                                i, i, 3,
                                                i, i, 4        ]
  end

  it '#run (3)', :pending => true do
    text = "  #####\n"\
           "  #   #\n"\
           "###  @#\n"\
           "#  $  #\n"\
           "#   ###\n"\
           "#   #  \n"\
           "#####  "

    level = Level.new(text)
    i     = Float::INFINITY

    DistancesService.new(level).run.should == [       4, i, i,
                                                      3, i, i,
                                                2, 1, 0, 3, 4,
                                                i, i, 1,
                                                i, i, 2        ]
  end
end
