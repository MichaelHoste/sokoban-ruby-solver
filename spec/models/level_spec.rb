require 'spec_helper'

describe Level do
  it '.initialize (xml_node)' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.name.should      == '1'
    level.copyright.should == ''
    level.rows.should      == 11
    level.cols.should      == 19
    level.boxes.should     == 6
    level.goals.should     == 6
    level.pusher.should    == { :m => 8, :n => 11 }

    level.to_s.should == "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $ #         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $  $          ..#\n"\
                         "##### ### #@##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "
  end

  it '.initialize (text)' do
    text =  "    #####          \n"\
            "    #   #          \n"\
            "    #$  #          \n"\
            "  ###  $##         \n"\
            "  #  $ $ #         \n"\
            "### # ## #   ######\n"\
            "#   # ## #####  ..#\n"\
            "# $  $          ..#\n"\
            "##### ### #@##  ..#\n"\
            "    #     #########\n"\
            "    #######        "

    level = Level.new(text)

    level.name.should      == ''
    level.copyright.should == ''
    level.rows.should      == 11
    level.cols.should      == 19
    level.boxes.should     == 6
    level.goals.should     == 6
    level.pusher.should    == { :m => 8, :n => 11 }

    level.to_s.should == "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $ #         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $  $          ..#\n"\
                         "##### ### #@##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "
  end

  it '.initialize (text with weird lines and end of lines)' do
    text =  " \n"\
            "    #####\n"\
            "    #   #\n"\
            "    #$  #\n"\
            "  ###  $##  \n"\
            "  #  $ $ #\n"\
            "### # ## #   ######   \n"\
            "#   # ## #####  ..#\n"\
            "# $  $          ..#\n"\
            "##### ### #@##  ..#  \n"\
            "    #     #########\n"\
            "    #######"

    level = Level.new(text)

    level.name.should      == ''
    level.copyright.should == ''
    level.rows.should      == 11
    level.cols.should      == 19
    level.boxes.should     == 6
    level.goals.should     == 6
    level.pusher.should    == { :m => 8, :n => 11 }

    level.to_s.should == "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $ #         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $  $          ..#\n"\
                         "##### ### #@##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "
  end

  it '.initialize (node)' do
    level       = Pack.new('spec/support/files/level.slc').levels[0]
    boxes_zone  = Zone.new(level, Zone::BOXES_ZONE)
    goals_zone  = Zone.new(level, Zone::GOALS_ZONE)
    pusher_zone = Zone.new(level, Zone::PUSHER_ZONE)
    node        = Node.new([boxes_zone, goals_zone, pusher_zone])

    Level.new(node).to_s.should == "    #####          \n"\
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

  it '.initialize (node with zones with less boxes/goals than linked level)' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    boxes_zone = Zone.new(level, Zone::BOXES_ZONE)
    boxes_zone[boxes_zone.positions_of_1[0]] = 0

    goals_zone = Zone.new(level, Zone::GOALS_ZONE)
    goals_zone[goals_zone.positions_of_1[0]] = 0

    pusher_zone = Zone.new(level, Zone::PUSHER_ZONE)

    node = Node.new([boxes_zone, goals_zone, pusher_zone])

    Level.new(node).to_s.should == "    #####          \n"\
                                   "    #   #          \n"\
                                   "    #   #          \n"\
                                   "  ###  $##         \n"\
                                   "  #  $ $@#         \n"\
                                   "### # ## #   ######\n"\
                                   "#   # ## #####   .#\n"\
                                   "# $  $          ..#\n"\
                                   "##### ### # ##  ..#\n"\
                                   "    #     #########\n"\
                                   "    #######        "
  end

  it '#read_pos' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.read_pos(2, 5).should == '$'
    level.read_pos(2, 6).should == 's' # inside empty space
    level.read_pos(0, 0).should == ' ' # outside empty space
    expect { level.read_pos(0, 19) }.to raise_error "Try to read value out of level's grid"
    expect { level.read_pos(11, 0) }.to raise_error "Try to read value out of level's grid"
    expect { level.read_pos(-1, 0) }.to raise_error "Try to read value out of level's grid"
  end

  it '#write_pos' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.write_pos(8, 11, 's')
    level.write_pos(7, 11, '@')

    level.to_s.should == "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $ #         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $  $     @    ..#\n"\
                         "##### ### # ##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "

    expect { level.write_pos(0, 19, '$') }.to raise_error "Try to write value out of level's grid"
    expect { level.write_pos(11, 0, '$') }.to raise_error "Try to write value out of level's grid"
    expect { level.write_pos(-1, 0, '$') }.to raise_error "Try to write value out of level's grid"
  end

  it '#can_move?' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.can_move?('D').should == false
    level.can_move?('d').should == false

    level.can_move?('L').should == false
    level.can_move?('l').should == false

    level.can_move?('R').should == false
    level.can_move?('r').should == false

    level.can_move?('U').should == true
    level.can_move?('u').should == true
  end

  it '#can_move? (2)' do
    level = Level.new("####\n"\
                      "# @#\n"\
                      "#  #\n"\
                      "####")

    level.can_move?('r')
  end

  it '#move' do
    original_level = Pack.new('spec/support/files/level.slc').levels[0]
    level_1        = Pack.new('spec/support/files/level.slc').levels[0]
    level_2        = Pack.new('spec/support/files/level_move_up.slc').levels[0]

    level_1.move('D').should == Level::NO_MOVE
    level_1.move('d').should == Level::NO_MOVE
    level_1.should           == original_level

    level_1.move('L').should == Level::NO_MOVE
    level_1.move('l').should == Level::NO_MOVE
    level_1.should           == original_level

    level_1.move('R').should == Level::NO_MOVE
    level_1.move('r').should == Level::NO_MOVE
    level_1.should           == original_level

    level_1.move('U').should == Level::NORMAL_MOVE
    level_1.move('u').should == Level::NO_MOVE
    level_1.should           == level_2
  end

  it '#move (2)' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.move('u').should == Level::NORMAL_MOVE

    5.times do
      level.move('l').should == Level::NORMAL_MOVE
    end

    level.move('l').should == Level::BOX_MOVE

    level.to_s.should == "    #####          \n"\
                         "    #   #          \n"\
                         "    #$  #          \n"\
                         "  ###  $##         \n"\
                         "  #  $ $ #         \n"\
                         "### # ## #   ######\n"\
                         "#   # ## #####  ..#\n"\
                         "# $ $@          ..#\n"\
                         "##### ### # ##  ..#\n"\
                         "    #     #########\n"\
                         "    #######        "
  end

  it '#valid?' do
    Pack.new('spec/support/files/level.slc').levels[0].valid?.should       == true
    Pack.new('spec/support/files/wrong_level.slc').levels[0].valid?.should == false
  end

  it '#won?' do
    level = Pack.new('spec/support/files/won_level.slc').levels[0]
    level.won?.should == true
  end

  it '#size' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    level.size.should == 209
  end

  it '#inside_size' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    level.inside_size.should == 56
  end

  it '#==' do
    level_1 = Pack.new('spec/support/files/level.slc').levels[0]
    level_2 = Pack.new('spec/support/files/level_move_up.slc').levels[0]

    level_1.should_not == level_2

    level_1.move('u')
    level_1.should == level_2
  end

  it '#clone' do
    level     = Pack.new('spec/support/files/level.slc').levels[0]
    new_level = level.clone

    level.should == new_level

    level.write_pos(1, 5, '$')

    level.should_not == new_level
  end

  it '#generate_picture' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    # with extension
    level.generate_picture('test.png')
    File.exist?('./test.png').should == true
    FileUtils.rm './test.png'

    # without extension
    level.generate_picture('test2')
    File.exist?('./test2.png').should == true
    FileUtils.rm './test2.png'
  end

  it 'Check that solution string goes to solution level' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    solution = "ullluuuLUllDlldddrRRRRRRRRRRurDllllllllllllulldRRRRRRRRRRRRR"\
               "dRRlUllllllluuululldDDuulldddrRRRRRRRRRRuRRlDllllllluuulLuuu"\
               "rDDllDDDuulldddrRRRRRRRRRRdRUllllllluuuLLulDDDuulldddrRRRRRR"\
               "RRRRRRlllllllluuuluuullDDDDDuulldddrRRRRRRRRRRRluR"

    solution.each_char { |move| level.move(move) }
    level.won?.should == true
  end

  it 'Checks that zone_pos_to_level_pos and level_pos_to_zone_pos are correct' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.level_pos_to_zone_pos[0].should   == nil
    level.level_pos_to_zone_pos[24].should  == 0
    level.level_pos_to_zone_pos[25].should  == 1
    level.level_pos_to_zone_pos.size.should == 209

    level.zone_pos_to_level_pos[0].should   == 24
    level.zone_pos_to_level_pos[1].should   == 25
    level.zone_pos_to_level_pos.size.should == 56
  end
end
