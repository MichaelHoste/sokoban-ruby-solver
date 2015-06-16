require 'spec_helper'

describe Zone do
  before :all do
    @level = Pack.new('spec/support/files/level.slc').levels[0]
  end

  describe '.initialize' do
    it "creates boxes zone" do
      zone = Zone.new(@level, Zone::BOXES_ZONE)

      zone.to_s.should == "    #####          \n"\
                          "    #   #          \n"\
                          "    #x  #          \n"\
                          "  ###  x##         \n"\
                          "  #  x x #         \n"\
                          "### # ## #   ######\n"\
                          "#   # ## #####    #\n"\
                          "# x  x            #\n"\
                          "##### ### # ##    #\n"\
                          "    #     #########\n"\
                          "    #######        "
    end

    it "creates goals zone" do
      zone = Zone.new(@level, Zone::GOALS_ZONE)

      zone.to_s.should == "    #####          \n"\
                          "    #   #          \n"\
                          "    #   #          \n"\
                          "  ###   ##         \n"\
                          "  #      #         \n"\
                          "### # ## #   ######\n"\
                          "#   # ## #####  xx#\n"\
                          "#               xx#\n"\
                          "##### ### # ##  xx#\n"\
                          "    #     #########\n"\
                          "    #######        "
    end

    it "creates pusher zone" do
      zone = Zone.new(@level, Zone::PUSHER_ZONE)

      zone.to_s.should == "    #####          \n"\
                          "    #   #          \n"\
                          "    #   #          \n"\
                          "  ###   ##         \n"\
                          "  #    xx#         \n"\
                          "### # ##x#   ######\n"\
                          "#   # ##x#####xxxx#\n"\
                          "#    xxxxxxxxxxxxx#\n"\
                          "#####x###x#x##xxxx#\n"\
                          "    #xxxxx#########\n"\
                          "    #######        "
    end

    it "creates custom zone with positions" do
      zone = Zone.new(@level, Zone::CUSTOM_ZONE, {
        :positions => [{ :m => 5, :n => 3 }]
      })

      zone.to_s.should == "    #####          \n"\
                          "    #   #          \n"\
                          "    #   #          \n"\
                          "  ###   ##         \n"\
                          "  #      #         \n"\
                          "###x# ## #   ######\n"\
                          "#   # ## #####    #\n"\
                          "#                 #\n"\
                          "##### ### # ##    #\n"\
                          "    #     #########\n"\
                          "    #######        "
    end

    it "creates custom zone with numbers" do
      zone = Zone.new(@level, Zone::CUSTOM_ZONE, :number => 4666327499276288)


      zone.to_s.should == "    #####          \n"\
                          "    #   #          \n"\
                          "    #x  #          \n"\
                          "  ###  x##         \n"\
                          "  #  x x #         \n"\
                          "### # ## #   ######\n"\
                          "#   # ## #####    #\n"\
                          "# x  x            #\n"\
                          "##### ### # ##    #\n"\
                          "    #     #########\n"\
                          "    #######        "
    end
  end

  it '#==' do
    zone_1 = Zone.new(@level, Zone::BOXES_ZONE)
    zone_2 = Zone.new(@level, Zone::BOXES_ZONE)

    zone_1.should == zone_2
  end

  it '#&' do
    zone_1 = Zone.new(@level, Zone::PUSHER_ZONE)
    zone_2 = Zone.new(@level, Zone::BOXES_ZONE)

    zone = zone_1 & zone_2

    zone.to_s.should == "    #####          \n"\
                        "    #   #          \n"\
                        "    #   #          \n"\
                        "  ###   ##         \n"\
                        "  #    x #         \n"\
                        "### # ## #   ######\n"\
                        "#   # ## #####    #\n"\
                        "#    x            #\n"\
                        "##### ### # ##    #\n"\
                        "    #     #########\n"\
                        "    #######        "
  end

  it '#|' do
    zone_1 = Zone.new(@level, Zone::GOALS_ZONE)
    zone_2 = Zone.new(@level, Zone::BOXES_ZONE)

    zone = zone_1 | zone_2

    zone.to_s.should == "    #####          \n"\
                        "    #   #          \n"\
                        "    #x  #          \n"\
                        "  ###  x##         \n"\
                        "  #  x x #         \n"\
                        "### # ## #   ######\n"\
                        "#   # ## #####  xx#\n"\
                        "# x  x          xx#\n"\
                        "##### ### # ##  xx#\n"\
                        "    #     #########\n"\
                        "    #######        "
  end

  it '#| (2)' do
    zone_1 = Zone.new(@level, Zone::PUSHER_ZONE)
    zone_2 = Zone.new(@level, Zone::GOALS_ZONE)

    zone = zone_1 | zone_2

    zone.should == zone_1
  end

  it '#-' do
    zone_1 = Zone.new(@level, Zone::PUSHER_ZONE)
    zone_2 = Zone.new(@level, Zone::GOALS_ZONE)

    zone = zone_1 - zone_2

    zone.to_s.should == "    #####          \n"\
                        "    #   #          \n"\
                        "    #   #          \n"\
                        "  ###   ##         \n"\
                        "  #    xx#         \n"\
                        "### # ##x#   ######\n"\
                        "#   # ##x#####xx  #\n"\
                        "#    xxxxxxxxxxx  #\n"\
                        "#####x###x#x##xx  #\n"\
                        "    #xxxxx#########\n"\
                        "    #######        "
  end

  it '#- (2)' do
    zone_1 = Zone.new(@level, Zone::GOALS_ZONE)
    zone_2 = Zone.new(@level, Zone::PUSHER_ZONE)

    zone = zone_1 - zone_2

    zone.to_s.should == "    #####          \n"\
                        "    #   #          \n"\
                        "    #   #          \n"\
                        "  ###   ##         \n"\
                        "  #      #         \n"\
                        "### # ## #   ######\n"\
                        "#   # ## #####    #\n"\
                        "#                 #\n"\
                        "##### ### # ##    #\n"\
                        "    #     #########\n"\
                        "    #######        "
  end

  context 'Zone inclusions' do
    text_1 =  "#######\n"\
              "#  $. #\n"\
              "# @$. #\n"\
              "#  $. #\n"\
              "#######"

    text_2 =  "#######\n"\
              "# $ . #\n"\
              "#@$ . #\n"\
              "# $ . #\n"\
              "#######"

    level_1 = Level.new(text_1)
    node_1  = level_1.to_node

    level_2 = Level.new(text_2)
    node_2  = level_2.to_node

    it '#in?' do
      node_2.pusher_zone.in?(node_1.pusher_zone).should == true
      node_1.pusher_zone.in?(node_2.pusher_zone).should == false

      node_2.goals_zone.in?(node_1.goals_zone).should == true
      node_1.goals_zone.in?(node_2.goals_zone).should == true
    end

    it '#include?' do
      node_1.pusher_zone.include?(node_2.pusher_zone).should == true
      node_2.pusher_zone.include?(node_1.pusher_zone).should == false

      node_1.goals_zone.include?(node_2.goals_zone).should == true
      node_2.goals_zone.include?(node_1.goals_zone).should == true
    end
  end

  it '#bit_1?' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.bit_1?(0).should == false
    zone.bit_1?(1).should == false
    zone.bit_1?(2).should == false
    zone.bit_1?(3).should == true
  end

  it '#bit_0?' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.bit_0?(0).should == true
    zone.bit_0?(1).should == true
    zone.bit_0?(2).should == true
    zone.bit_0?(3).should == false
  end

  it '#set_bit_1' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.set_bit_1(0)
    zone.set_bit_1(7)

    zone.to_s.should == "    #####          \n"\
                        "    #x  #          \n"\
                        "    #x  #          \n"\
                        "  ### xx##         \n"\
                        "  #  x x #         \n"\
                        "### # ## #   ######\n"\
                        "#   # ## #####    #\n"\
                        "# x  x            #\n"\
                        "##### ### # ##    #\n"\
                        "    #     #########\n"\
                        "    #######        "
  end

  it '#set_bit_0' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.set_bit_0(3)
    zone.set_bit_0(5) # no effect

    zone.to_s.should == "    #####          \n"\
                        "    #   #          \n"\
                        "    #   #          \n"\
                        "  ###  x##         \n"\
                        "  #  x x #         \n"\
                        "### # ## #   ######\n"\
                        "#   # ## #####    #\n"\
                        "# x  x            #\n"\
                        "##### ### # ##    #\n"\
                        "    #     #########\n"\
                        "    #######        "
  end

  it '#positions_of_1' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.positions_of_1.should == [3, 8, 11, 13, 28, 31]
  end

  it '#positions_of_0' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.positions_of_0.should == [0, 1, 2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 16,
                                   17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27,
                                   29, 30, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                                   41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,
                                   52, 53, 54, 55]
  end

  it '#clone' do
    zone_1 = Zone.new(@level, Zone::BOXES_ZONE)
    zone_2 = zone_1.clone

    zone_1.should      == zone_2
    zone_1.to_s.should == zone_2.to_s

    zone_1.set_bit_1(0)

    zone_1.should_not      == zone_2
    zone_1.to_s.should_not == zone_2.to_s
  end

  it '#to_binary' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.to_binary.should == "10000100101000000000000001001000000000000000000000000"
  end

  it '#to_full_binary' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.to_full_binary.should == "00010000100101000000000000001001000000000000000000000000"
  end

  it '#to_integer' do
    zone = Zone.new(@level, Zone::BOXES_ZONE)
    zone.to_integer.should == 4666327499276288
  end
end
