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
                                       "###  #  \n"\
                                       "#    #  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $  #\n"\
                                       "  #  $ #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[0][:value].should == 3

    penalties[1][:node].to_s.should == "  ####  \n"\
                                       "###  #  \n"\
                                       "#    #  \n"\
                                       "#   .###\n"\
                                       "### #@.#\n"\
                                       "  # $$ #\n"\
                                       "  #    #\n"\
                                       "  #. ###\n"\
                                       "  ####  "
    penalties[1][:value].should == 3
  end

end
