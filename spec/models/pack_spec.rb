require 'spec_helper'

describe Pack do
  it '.initialize' do
    pack = Pack.new('spec/support/files/level.slc')

    pack.file_name.should    == 'level.slc'
    pack.email.should        == 'test@gmail.com'
    pack.url.should          == 'http://test.com'
    pack.name.should         == 'Original & Extra'
    pack.description.should  == 'The 50 original levels from Sokoban plus the 40 from Extra.'
    pack.copyright.should    == 'Thinking Rabbit'
    pack.max_cols.should     == 19
    pack.max_rows.should     == 11
    pack.levels.count.should == 1

    pack.levels.first.to_s.should == "    #####          \n"\
                                     "    #   #          \n"\
                                     "    #$  #          \n"\
                                     "  ###  $##         \n"\
                                     "  #  $ $ #         \n"\
                                     "### # ## #   ######\n"\
                                     "#   # ## #####  ..#\n"\
                                     "# $  $          ..#\n"\
                                     "##### ### #@##  ..#\n"\
                                     "    #     #########\n"\
                                     "    #######        "
  end
end
