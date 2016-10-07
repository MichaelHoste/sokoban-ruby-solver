require 'spec_helper'

describe MovesBetweenTwoPositionsService do

  it '#run on simple example' do
    level = Level.new("#######\n"\
                      "#  $  #\n"\
                      "#     #\n"\
                      "#  @  #\n"\
                      "#######")

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 3, :n => 4 }).run
    path.should == 'r'

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 2, :n => 2 }).run
    path.should == 'lu'

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 1, :n => 1 }).run
    path.should == 'lluu'
  end

  it '#run on a complex example' do
    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #   #          \n"\
                      "  ###   ##         \n"\
                      "  #   $  #         \n"\
                      "### # ## #   ######\n"\
                      "#   # ## #####  **#\n"\
                      "#               .*#\n"\
                      "##### ###$#@##  .*#\n"\
                      "    #     #########\n"\
                      "    #######        ")

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 1, :n => 5 }).run
    path.should == 'ulllllluuuuuu'
  end

  it '#run on a complex example - around boxes' do
    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #   #          \n"\
                      "  ###   ##         \n"\
                      "  #   $  #         \n"\
                      "### # ## #   ######\n"\
                      "#   #$## #####  **#\n"\
                      "#               .*#\n"\
                      "##### ###$#@##  .*#\n"\
                      "    #     #########\n"\
                      "    #######        ")

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 1, :n => 5 }).run
    path.should == 'ullluuululluu'
  end

  it '#run on a complex example - around boxes - 2' do
    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #   #          \n"\
                      "  ###   ##         \n"\
                      "  #   $  #         \n"\
                      "### # ##$#   ######\n"\
                      "#   #$## #####  **#\n"\
                      "#               .*#\n"\
                      "##### ###$#@##  .*#\n"\
                      "    #     #########\n"\
                      "    #######        ")

    path = MovesBetweenTwoPositionsService.new(level, level.pusher, { :m => 1, :n => 5 }).run
    path.should == 'ulllllllluuurruuu'
  end
end
