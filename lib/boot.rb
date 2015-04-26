require 'nokogiri'
require 'bsearch'
require 'ruby-prof'

Dir.glob("./services/**/*.rb").each { |f| require f }

require './models/solver/solver'
Dir.glob("./models/**/*.rb").each   { |f| require f }
