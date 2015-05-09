require 'spec_helper'

describe PenaltiesService do

  it '#run' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)
    node  = level.to_node

    penalties = PenaltiesService.new(node).run

    penalties.count.should == 2

    penalties[0][:node].to_s.should == "  ####  \n"\
                                       "###@ #  \n"\
                                       "#    #  \n"\
                                       "#   .###\n"\
                                       "### # .#\n"\
                                       "  # $$ #\n"\
                                       "  #    #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[0][:value].should == 3

    penalties[1][:node].to_s.should == "  ####  \n"\
                                       "###  #  \n"\
                                       "#    #  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $  #\n"\
                                       "  #  $ #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[1][:value].should == 3
  end

  it '#run', :focus => true do
    text =  "  ####  \n"\
            "###  #  \n"\
            "# $ .#  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level = Level.new(text)
    node  = level.to_node

    penalties = PenaltiesService.new(node).run

    penalties.count.should == 5

    penalties[0][:node].to_s.should == "  ####  \n"\
                                       "###@ #  \n"\
                                       "#   .#  \n"\
                                       "#   .###\n"\
                                       "### # .#\n"\
                                       "  # $$ #\n"\
                                       "  #    #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[0][:value].should == 2

    penalties[1][:node].to_s.should == "  ####  \n"\
                                       "###  #  \n"\
                                       "#   .#  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $  #\n"\
                                       "  #  $ #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[1][:value].should == 2

    penalties[2][:node].to_s.should == "  ####  \n"\
                                       "###@ #  \n"\
                                       "# $ .#  \n"\
                                       "#   .###\n"\
                                       "### # .#\n"\
                                       "  # $$ #\n"\
                                       "  #    #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[2][:value].should == 1

    penalties[3][:node].to_s.should == "  ####  \n"\
                                       "###  #  \n"\
                                       "# $ .#  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $  #\n"\
                                       "  #  $ #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[3][:value].should == 6

    penalties[4][:node].to_s.should == "  ####  \n"\
                                       "###  #  \n"\
                                       "#   .#  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $$ #\n"\
                                       "  #  $ #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[4][:value].should == 3
  end

end
