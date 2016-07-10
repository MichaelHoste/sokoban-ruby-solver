require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'nokogiri'
require 'bsearch'
require 'ruby-prof'
require 'memoist'

Dir.glob("./services/**/*.rb").each { |f| require f }

require './models/solver/solver'
Dir.glob("./models/**/*.rb").each   { |f| require f }
