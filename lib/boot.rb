require 'nokogiri'

require './models/deadlock/deadlock'
Dir.glob("./models/**/*.rb").each { |f| require f }
