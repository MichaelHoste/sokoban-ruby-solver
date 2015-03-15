require 'nokogiri'
Dir.glob("./models/*.rb").each { |f| require f }

pack  = Pack.new('data/Original.slc')
level = pack.levels.first

level.print

#puts CornerDeadlock.new(pack.levels.first).deadlock_positions

Zone.new(level).print
