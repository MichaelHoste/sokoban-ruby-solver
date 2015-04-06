require 'spec_helper'

describe Node do
  before :all do
    @level = Pack.new('spec/support/files/level.slc').levels[0]
  end

  it '.initialize (level)' do
    node  = Node.new(@level)

    node.boxes_zone.to_s.should == "    #####          \n"\
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

    node.goals_zone.to_s.should == "    #####          \n"\
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

    node.pusher_zone.to_s.should == "    #####          \n"\
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

  it '.initialize (zones)' do
    boxes_zone  = Zone.new(@level, Zone::BOXES_ZONE)
    goals_zone  = Zone.new(@level, Zone::GOALS_ZONE)
    pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

    node  = Node.new([boxes_zone, goals_zone, pusher_zone])

    node.boxes_zone.to_s.should == "    #####          \n"\
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

    node.goals_zone.to_s.should == "    #####          \n"\
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

    node.pusher_zone.to_s.should == "    #####          \n"\
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

  it '#won?' do
    level = Pack.new('spec/support/files/won_level.slc').levels[0]
    node  = Node.new(level)
    node.won?.should == true
  end

  it '#to_s' do
    node  = Node.new(@level)

    node.to_s.should ==  "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $@#         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $  $          ..#\n"\
                         "##### ### # ##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "
  end

  it '#to_level' do
    node  = Node.new(@level)

    target_level = Level.new("    #####          \n"\
                             "    #   #          \n"\
                             "    #$  #          \n"\
                             "  ###  $##         \n"\
                             "  #  $ $@#         \n"\
                             "### # ## #   ######\n"\
                             "#   # ## #####  ..#\n"\
                             "# $  $          ..#\n"\
                             "##### ### # ##  ..#\n"\
                             "    #     #########\n"\
                             "    #######        ")

    node.to_level.should == target_level
  end

  it '#==' do
    node_1 = Node.new(@level)

    boxes_zone  = Zone.new(@level, Zone::BOXES_ZONE)
    goals_zone  = Zone.new(@level, Zone::GOALS_ZONE)
    pusher_zone = Zone.new(@level, Zone::PUSHER_ZONE)

    node_2 = Node.new([boxes_zone, goals_zone, pusher_zone])

    node_1.should == node_2
  end
end
