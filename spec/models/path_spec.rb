require 'spec_helper'

describe Path do
  it '.initialize (uncompressed)' do
    path = Path.new('rrrllUUUUUruLLLdlluRRRRdr')

    path.pushes_count.should == 12
    path.moves_count.should  == 25

    path.uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdr'
    path.compressed_string_path.should   == '3r2l5Uru3Ld2lu4Rdr'
  end

  it '.initialize (compressed)' do
    path = Path.new('3r2l5Uru3Ld2lu4Rdr')

    path.pushes_count.should == 12
    path.moves_count.should  == 25

    path.uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdr'
    path.compressed_string_path.should   == '3r2l5Uru3Ld2lu4Rdr'
  end

  it '.initialize (compressed with big numbers)' do
    path = Path.new('32r2l5Uru12Ld2lu4Rdr')

    path.pushes_count.should == 21
    path.moves_count.should  == 63

    path.uncompressed_string_path.should == 'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr'
    path.compressed_string_path.should   == '32r2l5Uru12Ld2lu4Rdr'
  end

  it '.initialize (empty string)' do
    path = Path.new('')

    path.pushes_count.should == 0
    path.moves_count.should  == 0

    path.uncompressed_string_path.should == ''
    path.compressed_string_path.should   == ''
  end

  it '#add_move' do
    path = Path.new('3r2l5Uru3Ld2lu4Rdr')

    path.pushes_count.should == 12
    path.moves_count.should  == 25

    path.add_move('u')
    path.add_move('r')
    path.add_move('l')
    path.add_move('d')

    path.pushes_count.should == 12
    path.moves_count.should  == 29

    path.uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdrurld'
    path.compressed_string_path.should   == '3r2l5Uru3Ld2lu4Rdrurld'
  end

  it '#add_push' do
    path = Path.new('3r2l5Uru3Ld2lu4Rdr')

    path.pushes_count.should == 12
    path.moves_count.should  == 25

    path.add_push('u')
    path.add_push('r')
    path.add_push('L') # test if uppercase works too
    path.add_push('D') # test if uppercase works too

    path.pushes_count.should == 16
    path.moves_count.should  == 29

    path.uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdrURLD'
    path.compressed_string_path.should   == '3r2l5Uru3Ld2lu4RdrURLD'
  end

  it '#add_displacement' do
    path = Path.new('3r2l5Uru3Ld2lu4Rdr')

    path.pushes_count.should == 12
    path.moves_count.should  == 25

    path.add_displacement('u')
    path.add_displacement('r')
    path.add_displacement('L')
    path.add_displacement('D')

    path.pushes_count.should == 14
    path.moves_count.should  == 29

    path.uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdrurLD'
    path.compressed_string_path.should   == '3r2l5Uru3Ld2lu4RdrurLD'
  end

  it '#last_move' do
    Path.new('3r2l5Uru3Ld2lu4Rdr').last_move.should == 'r'
    Path.new('3r2l5Uru3Ld').last_move.should        == 'd'
    Path.new('3r2l5U').last_move.should             == 'U'
    Path.new('3r').last_move.should                 == 'r'
    Path.new('').last_move.should                   == nil
  end

  it '#delete_last_move' do
    path = Path.new('3r2l5Uru3Ld2lu4Rdr')
    path.delete_last_move.should == true
    path.compressed_string_path.should == '3r2l5Uru3Ld2lu4Rd'

    path = Path.new('3r2l5Uru3Ld')
    path.delete_last_move.should == true
    path.compressed_string_path.should == '3r2l5Uru3L'

    path = Path.new('3r2l5U')
    path.delete_last_move.should == true
    path.compressed_string_path.should == '3r2l4U'

    path = Path.new('3r')
    path.delete_last_move.should == true
    path.compressed_string_path.should == '2r'

    path = Path.new('')
    path.delete_last_move.should == false
    path.compressed_string_path.should == ''
  end

  it '#uncompressed_string_path' do
    path = Path.new('rrrllUUUUUruLLLdlluRRRRdr').uncompressed_string_path.should == 'rrrllUUUUUruLLLdlluRRRRdr'
    path = Path.new('3r2l5Uru3Ld2lu4Rdr').uncompressed_string_path.should        == 'rrrllUUUUUruLLLdlluRRRRdr'

    path = Path.new('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr')
    path.uncompressed_string_path.should == 'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr'

    path = Path.new('32r2l5Uru12Ld2lu4Rdr')
    path.uncompressed_string_path.should == 'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr'
  end

  it '#compressed_string_path' do
    path = Path.new('rrrllUUUUUruLLLdlluRRRRdr').compressed_string_path.should == '3r2l5Uru3Ld2lu4Rdr'
    path = Path.new('3r2l5Uru3Ld2lu4Rdr').compressed_string_path.should        == '3r2l5Uru3Ld2lu4Rdr'

    path = Path.new('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr')
    path.compressed_string_path.should == '32r2l5Uru12Ld2lu4Rdr'

    path = Path.new('32r2l5Uru12Ld2lu4Rdr')
    path.compressed_string_path.should == '32r2l5Uru12Ld2lu4Rdr'
  end

  it '#to_s' do
    path = Path.new('rrrllUUUUUruLLLdlluRRRRdr').to_s.should == 'rrrllUUUUUruLLLdlluRRRRdr'
    path = Path.new('3r2l5Uru3Ld2lu4Rdr').to_s.should        == 'rrrllUUUUUruLLLdlluRRRRdr'

    path = Path.new('rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr')
    path.to_s.should == 'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr'

    path = Path.new('32r2l5Uru12Ld2lu4Rdr')
    path.to_s.should == 'rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrllUUUUUruLLLLLLLLLLLLdlluRRRRdr'
  end
end
