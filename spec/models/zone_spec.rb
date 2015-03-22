require 'spec_helper'

describe Zone do
  before :each do
    @level = Pack.new('data/Original.slc').levels[0]
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
                          "    #######        "\
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
                          "    #######        "\
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
                          "    #######        "\
    end

    it "creates custom zone" do
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
                          "    #######        "\
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
                        "    #######        "\
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
                        "    #######        "\
  end

  it '#| (2)' do
    zone_1 = Zone.new(@level, Zone::PUSHER_ZONE)
    zone_2 = Zone.new(@level, Zone::BOXES_ZONE)

    zone = zone_1 | zone_2

    zone.should == zone_1
  end
end
