require 'spec_helper'

describe PenaltiesService, :focus => true do

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

    penalties.each do |penalty|
      puts penalty[:node].to_s
      puts penalty[:value].to_s
    end
  end

end
