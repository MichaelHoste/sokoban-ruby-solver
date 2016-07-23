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

    service = PenaltiesService.new(node)
    service.run
    penalties = service.penalties

    penalties.count.should == 2

    penalties.all[0][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#    #  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[0][:value].should == 3

    penalties.all[1][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "#    #  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[1][:value].should == 3
  end

  it '#run (2)' do
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

    service = PenaltiesService.new(node)
    service.run
    penalties = service.penalties

    penalties.count.should == 5

    penalties.all[0][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[0][:value].should == 2

    penalties.all[1][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[1][:value].should == 2

    penalties.all[2][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[2][:value].should == 8

    penalties.all[3][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $$ #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[3][:value].should == 7

    penalties.all[4][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "
    penalties.all[4][:value].should == 3
  end

  it 'run (3)' do
    text =  "        #####\n"\
            "#########   #\n"\
            "#@ ...*..$  #\n"\
            "#   # ###   #\n"\
            "###   $ #   #\n"\
            "  # $   #   #\n"\
            "  #     #####\n"\
            "  #######    "

    level = Level.new(text)
    node  = level.to_node

    service = PenaltiesService.new(node)
    service.run
    penalties = service.penalties

    # if infinity penalty is found, we don't need other penalties
    penalties.count.should == 1

    penalties.all[0][:node].to_s.should == "        #####\n"\
                                           "#########   #\n"\
                                           "#@ ...*..$  #\n"\
                                           "#   # ###   #\n"\
                                           "###     #   #\n"\
                                           "  #     #   #\n"\
                                           "  #     #####\n"\
                                           "  #######    "
    penalties.all[0][:value].should == Float::INFINITY

    # penalties.all[1][:node].to_s.should == "        #####\n"\
    #                                        "#########   #\n"\
    #                                        "#@ ......$  #\n"\
    #                                        "#   # ###   #\n"\
    #                                        "###   $ #   #\n"\
    #                                        "  #     #   #\n"\
    #                                        "  #     #####\n"\
    #                                        "  #######    "
    # penalties.all[1][:value].should == 2

    # penalties.all[2][:node].to_s.should == "        #####\n"\
    #                                        "#########   #\n"\
    #                                        "#@ ......$  #\n"\
    #                                        "#   # ###   #\n"\
    #                                        "###   $ #   #\n"\
    #                                        "  # $   #   #\n"\
    #                                        "  #     #####\n"\
    #                                        "  #######    "
    # penalties.all[2][:value].should == 3
  end

end
