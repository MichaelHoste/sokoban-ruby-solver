require 'spec_helper'

describe CornerDeadlock do
  it "should detect deadlock positions of a level" do
    level              = Pack.new('data/Original.slc').levels[0]
    deadlock_positions = CornerDeadlock.new(level).deadlock_positions
    deadlock_zone      = Zone.new(level,
                                  Zone::CUSTOM_ZONE,
                                  { :positions => deadlock_positions })

    deadlock_positions.count.should == 15

    deadlock_zone.to_s.should == "    #####          \n"\
                                 "    #xxx#          \n"\
                                 "    #   #          \n"\
                                 "  ###   ##         \n"\
                                 "  #x    x#         \n"\
                                 "### # ## #   ######\n"\
                                 "#x  # ## #####x   #\n"\
                                 "#x                #\n"\
                                 "##### ### #x##x   #\n"\
                                 "    #xxxxx#########\n"\
                                 "    #######        "\
  end
end
