require 'nokogiri'
Dir.glob("./models/*.rb").each { |f| require f }

pack = Pack.new('data/Original.slc')
puts
pack.levels.last.print

puts CornerDeadlock.new(pack.levels.first).deadlock_positions
