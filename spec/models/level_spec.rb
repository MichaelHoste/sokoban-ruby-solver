require 'spec_helper'

describe Level do
  it '.initialize' do
    level = Pack.new('spec/support/files/level.slc').levels[0]

    level.name.should      == '1'
    level.copyright.should == ''
    level.rows.should      == 11
    level.cols.should      == 19
    level.boxes.should     == 6
    level.goals.should     == 6
    level.pusher.should    == { :pos_m => 8, :pos_n => 11 }

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
                         "    #######        "\
  end

  it 'raise error when loading' do
    message = "Level error: there must be the same number of boxes and goals"

    expect { Pack.new('spec/support/files/wrong_level.slc') }.to raise_error message
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
                         "    #######        "\

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
                         "    #######        "\
  end

  it '#won?' do
    level = Pack.new('spec/support/files/won_level.slc').levels[0]
    level.won?.should == true
  end

  it '#==' do
    level_1 = Pack.new('spec/support/files/level.slc').levels[0]
    level_2 = Pack.new('spec/support/files/level_move_up.slc').levels[0]

    level_1.should_not == level_2

    level_1.move('u')
    level_1.should == level_2
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
end
