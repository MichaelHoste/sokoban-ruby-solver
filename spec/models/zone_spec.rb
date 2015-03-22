require 'spec_helper'

describe Zone do
  before :each do
    @level = Pack.new('data/Original.slc').levels[0]
  end

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
