require 'spec_helper'

describe MovesBetweenLevelAndNodeService do

  it '#run on simple example' do
    level = Level.new("#######\n"\
                      "#  $  #\n"\
                      "#     #\n"\
                      "#  @  #\n"\
                      "#######")

    node = Level.new("#######\n"\
                     "#   $ #\n"\
                     "#     #\n"\
                     "#  @  #\n"\
                     "#######").to_node # lose precise pusher position

    path = MovesBetweenLevelAndNodeService.new(level, node).run

    path.should == 'luuR'
  end

  it '#run on simple example - 2' do
    level = Level.new("#######\n"\
                      "#     #\n"\
                      "# $   #\n"\
                      "#    @#\n"\
                      "#######")

    node = Level.new("#######\n"\
                     "# @  $#\n"\
                     "#     #\n"\
                     "#     #\n"\
                     "#######").to_node # lose precise pusher position

    path = MovesBetweenLevelAndNodeService.new(level, node).run

    path.should == 'lllluRRRdrU'
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

    node = Level.new("    #####          \n"\
                     "    #   #          \n"\
                     "    #   #          \n"\
                     "  ###   ##         \n"\
                     "  #   $  #         \n"\
                     "### # ## #   ######\n"\
                     "#   # ## #####  **#\n"\
                     "#       @       .*#\n"\
                     "##### ### # ##  **#\n"\
                     "    #     #########\n"\
                     "    #######        ").to_node # lose precise pusher position

    path = MovesBetweenLevelAndNodeService.new(level, node).run

    path.should == 'ullllllddrrrrUdlllluurrrRRRRRRurDldR'
  end

  it '#run on a complex example - 2' do
    level = Level.new("    #####          \n"\
                      "    #   #          \n"\
                      "    #   #          \n"\
                      "  ###   ##         \n"\
                      "  #   $  #         \n"\
                      "### # ## #   ######\n"\
                      "#   # ## #####  **#\n"\
                      "#               .*#\n"\
                      "##### ### # ## @**#\n"\
                      "    #     #########\n"\
                      "    #######        ")

    node = Level.new("    #####          \n"\
                     "    #@  #          \n"\
                     "    #   #          \n"\
                     "  ###   ##         \n"\
                     "  #      #         \n"\
                     "### # ## #   ######\n"\
                     "#   # ## #####  **#\n"\
                     "#               **#\n"\
                     "##### ### # ##  **#\n"\
                     "    #     #########\n"\
                     "    #######        ").to_node # lose precise pusher position

    path = MovesBetweenLevelAndNodeService.new(level, node).run

    path.should == 'lulllllluuulLulDDDuulldddrRRRRRRRRRRR'
  end
end
