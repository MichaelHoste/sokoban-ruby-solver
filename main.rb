require 'nokogiri'
Dir.glob("./models/*.rb").each { |f| require f }

pack = Pack.new('data/Original.slc')
pack.print
