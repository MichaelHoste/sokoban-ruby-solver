require 'spec_helper'

describe CornerDeadlock do
  before :each do
    @level = Pack.new('data/Original.slc').levels[0]
  end

  it "should detect corner deadlocks" do
    deadlock_positions = CornerDeadlock.new(@level).send(:corner_deadlock_positions)

    deadlock_zone = Zone.new(@level, Zone::CUSTOM_ZONE, {
      :positions => deadlock_positions
    })

    deadlock_positions.count.should == 11

    deadlock_zone.to_s.should == "    #####          \n"\
                                 "    #x x#          \n"\
                                 "    #   #          \n"\
                                 "  ###   ##         \n"\
                                 "  #x    x#         \n"\
                                 "### # ## #   ######\n"\
                                 "#x  # ## #####x   #\n"\
                                 "#x                #\n"\
                                 "##### ### #x##x   #\n"\
                                 "    #x   x#########\n"\
                                 "    #######        "\
  end

  it "should detect line deadlocks" do
    deadlock_positions = CornerDeadlock.new(@level).send(:line_deadlock_positions)

    deadlock_zone = Zone.new(@level, Zone::CUSTOM_ZONE, {
      :positions => deadlock_positions
    })

    deadlock_positions.count.should == 4

    deadlock_zone.to_s.should == "    #####          \n"\
                                 "    # x #          \n"\
                                 "    #   #          \n"\
                                 "  ###   ##         \n"\
                                 "  #      #         \n"\
                                 "### # ## #   ######\n"\
                                 "#   # ## #####    #\n"\
                                 "#                 #\n"\
                                 "##### ### # ##    #\n"\
                                 "    # xxx #########\n"\
                                 "    #######        "\
  end

  it "should detect deadlock positions of a level" do
    deadlock_positions = CornerDeadlock.new(@level).deadlock_positions

    deadlock_zone = Zone.new(@level, Zone::CUSTOM_ZONE, {
      :positions => deadlock_positions
    })

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
