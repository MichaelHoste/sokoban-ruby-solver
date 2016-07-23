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

    penalties.count.should == 17

    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 2 }.should == 14
    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 3 }.should == 3
    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 4 }.should == 0

    penalties.all[0][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  #$   #\n"\
                                           "  #$   #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[0][:value].should == Float::INFINITY

    penalties.all[1][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  #$   #\n"\
                                           "  # $  #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[1][:value].should == Float::INFINITY

    penalties.all[2][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   *#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  #$   #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[2][:value].should == Float::INFINITY

    penalties.all[3][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#  $.#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  #$   #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[3][:value].should == Float::INFINITY

    penalties.all[4][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "# $ .#  \n"\
                                           "# $ .###\n"\
                                           "### # .#\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[4][:value].should == Float::INFINITY

    penalties.all[5][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  # $  #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[5][:value].should == 4

    penalties.all[6][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #$   #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[6][:value].should == 4

    penalties.all[7][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "# $$.#  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[7][:value].should == 3

    penalties.all[8][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  #$   #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[8][:value].should == 3

    penalties.all[9][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "# $ .#  \n"\
                                           "#  $.###\n"\
                                           "###@# .#\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[9][:value].should == 3

    penalties.all[10][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "# $ .#  \n"\
                                           "#  $.###\n"\
                                           "### # .#\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[10][:value].should == 3

    penalties.all[11][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "###$#@.#\n"\
                                           "  #    #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[11][:value].should == 3

    penalties.all[12][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[12][:value].should == 2

    penalties.all[13][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[13][:value].should == 2

    penalties.all[14][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $  #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[14][:value].should == 8

    penalties.all[15][:node].to_s.should == "  ####  \n"\
                                           "###  #  \n"\
                                           "#   .#  \n"\
                                           "#   .###\n"\
                                           "### #@.#\n"\
                                           "  # $$ #\n"\
                                           "  #  $ #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[15][:value].should == 7

    penalties.all[16][:node].to_s.should == "  ####  \n"\
                                           "###@ #  \n"\
                                           "# $ .#  \n"\
                                           "#   .###\n"\
                                           "### # .#\n"\
                                           "  # $$ #\n"\
                                           "  #    #\n"\
                                           "  #. ###\n"\
                                           "  ####  "

    penalties.all[16][:value].should == 3
  end

  it 'run (3)', :focus do
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

    penalties.count.should == 36

    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 2 }.should == 35
    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 3 }.should == 1
    penalties.all.count { |penalty| penalty[:node].num_of_boxes == 4 }.should == 0
  end

  xit 'run (4)', :slow do
    text =  "        #####\n"\
            "#########   #\n"\
            "#@ ...*..$  #\n"\
            "#   # ###   #\n"\
            "###   $ #   #\n"\
            "  # $ $ #   #\n"\
            "  #     #####\n"\
            "  #######    "

    level = Level.new(text)
    node  = level.to_node

    service = PenaltiesService.new(node)
    service.run
    penalties = service.penalties

    penalties.count.should == 501

    # penalties.all.count { |penalty| penalty[:node].num_of_boxes == 2 }.should == 39
    # penalties.all.count { |penalty| penalty[:node].num_of_boxes == 3 }.should == 1
    # penalties.all.count { |penalty| penalty[:node].num_of_boxes == 4 }.should == 0
  end

end
