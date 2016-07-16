require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'nokogiri'
require 'bsearch'
require 'ruby-prof'
require 'memoist'

require './lib/read_char.rb'

Dir.glob("./services/**/*.rb").each { |f| require f }

require './models/solver/solver'
Dir.glob("./models/**/*.rb").each   { |f| require f }
