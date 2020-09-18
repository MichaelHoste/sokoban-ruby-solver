require 'nokogiri'
require 'bsearch'
require 'ruby-prof'
require 'memoist'

require 'munkres'
require 'munkres_ru'

require './lib/read_char.rb'

Dir.glob("./services/**/*.rb").each { |f| require f }

require './models/solver/solver'
Dir.glob("./models/**/*.rb").each   { |f| require f }
