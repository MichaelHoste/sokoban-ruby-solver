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

    puts penalties.count

    penalties.count.should == 3
    penalties.each do |penalty|
      puts penalty.to_s
    end
  end

end
