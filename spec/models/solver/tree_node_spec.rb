require 'spec_helper'

describe TreeNode do

  it '.initialize (without g)' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = level.to_node

    tree_node = TreeNode.new(node)

    tree_node.g.should        == 0
    tree_node.h.should        == Float::INFINITY
    tree_node.node.should     == node
    tree_node.children.should == []
    tree_node.f.should        == Float::INFINITY
  end

  it '.initialize (with g)' do
    level = Pack.new('spec/support/files/level.slc').levels[0]
    node  = level.to_node

    tree_node = TreeNode.new(node, nil, 10)

    tree_node.g.should        == 10
    tree_node.h.should        == Float::INFINITY
    tree_node.node.should     == node
    tree_node.children.should == []
    tree_node.f.should        == Float::INFINITY
  end

  it '#add_child' do
    level     = Pack.new('spec/support/files/level.slc').levels[0]
    node      = level.to_node
    tree_node = TreeNode.new(node)

    level_2     = level.move('u')
    node_2      = level.to_node
    tree_node_2 = TreeNode.new(node_2)

    tree_node.add_child(tree_node_2)

    tree_node.children.should == [tree_node_2]
    tree_node_2.parent.should == tree_node
  end

  it '#remove_child' do
    level     = Pack.new('spec/support/files/level.slc').levels[0]
    node      = level.to_node
    tree_node = TreeNode.new(node)

    level_2     = level.move('u')
    node_2      = level.to_node
    tree_node_2 = TreeNode.new(node_2)

    tree_node.add_child(tree_node_2)
    tree_node.remove_child(tree_node_2)

    tree_node.children.should == []
    tree_node_2.parent.should == nil
  end

  it '#f' do
    level       = Pack.new('spec/support/files/level.slc').levels[0]
    node        = level.to_node
    tree_node   = TreeNode.new(node, nil, 10)
    tree_node.h = 32

    tree_node.f.should == 42
  end

  it '#won?' do
    level     = Pack.new('spec/support/files/won_level.slc').levels[0]
    node      = level.to_node
    tree_node = TreeNode.new(node)

    tree_node.won?.should == true
  end

  it '#path' do
    level_1 = Level.new("#######\n"\
                        "#    @#\n"\
                        "#$ $  #\n"\
                        "#     #\n"\
                        "#..####\n"\
                        "#**#   \n"\
                        "####   ")

    level_2 = Level.new("#######\n"\
                        "#     #\n"\
                        "#  $  #\n"\
                        "#@    #\n"\
                        "#*.####\n"\
                        "#**#   \n"\
                        "####   ")

    level_3 = Level.new("#######\n"\
                        "#     #\n"\
                        "#     #\n"\
                        "# @   #\n"\
                        "#**####\n"\
                        "#**#   \n"\
                        "####   ")

    node_1 = level_1.to_node
    node_2 = level_2.to_node
    node_3 = level_3.to_node

    tree_node_1 = TreeNode.new(node_1)
    tree_node_2 = TreeNode.new(node_2, tree_node_1, 2)
    tree_node_3 = TreeNode.new(node_3, tree_node_2, 3)

    tree_node_1.path.should == ''
    tree_node_2.path.should == 'llllDD'
    tree_node_3.path.should == 'llllDDrrruLulDD'
  end

  it '#current_level' do
    level_1 = Level.new("#######\n"\
                        "#    @#\n"\
                        "#$ $  #\n"\
                        "#     #\n"\
                        "#..####\n"\
                        "#**#   \n"\
                        "####   ")

    level_2 = Level.new("#######\n"\
                        "#     #\n"\
                        "#  $  #\n"\
                        "#@    #\n"\
                        "#*.####\n"\
                        "#**#   \n"\
                        "####   ")

    level_3 = Level.new("#######\n"\
                        "#     #\n"\
                        "#     #\n"\
                        "# @   #\n"\
                        "#**####\n"\
                        "#**#   \n"\
                        "####   ")

    node_1 = level_1.to_node
    node_2 = level_2.to_node
    node_3 = level_3.to_node

    tree_node_1 = TreeNode.new(node_1)
    tree_node_2 = TreeNode.new(node_2, tree_node_1, 2)
    tree_node_3 = TreeNode.new(node_3, tree_node_2, 3)

    tree_node_1.current_level.to_s.should == "#######\n"\
                                             "#    @#\n"\
                                             "#$ $  #\n"\
                                             "#     #\n"\
                                             "#..####\n"\
                                             "#**#   \n"\
                                             "####   "

    tree_node_2.current_level.to_s.should == "#######\n"\
                                             "#     #\n"\
                                             "#  $  #\n"\
                                             "#@    #\n"\
                                             "#*.####\n"\
                                             "#**#   \n"\
                                             "####   "

    tree_node_3.current_level.to_s.should == "#######\n"\
                                             "#     #\n"\
                                             "#     #\n"\
                                             "# @   #\n"\
                                             "#**####\n"\
                                             "#**#   \n"\
                                             "####   "
  end

  it '#find_children' do
    level     = Pack.new('spec/support/files/level.slc').levels[0]
    node      = level.to_node
    tree_node = TreeNode.new(node, nil, 10)

    children = tree_node.find_children

    children[0].g == 11
    children[0].node.to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #  $$@ #         \n"\
                                    "### # ## #   ######\n"\
                                    "#   # ## #####  ..#\n"\
                                    "# $  $          ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "

    children[1].g == 11
    children[1].node.to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #  $ $@#         \n"\
                                    "### # ## #   ######\n"\
                                    "#   # ## #####  ..#\n"\
                                    "# $ $           ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "

    children[2].g == 11
    children[2].node.to_s.should == "    #####          \n"\
                                    "    #   #          \n"\
                                    "    #$  #          \n"\
                                    "  ###  $##         \n"\
                                    "  #@ $ $ #         \n"\
                                    "### # ## #   ######\n"\
                                    "#   #$## #####  ..#\n"\
                                    "# $             ..#\n"\
                                    "##### ### # ##  ..#\n"\
                                    "    #     #########\n"\
                                    "    #######        "
  end

end
