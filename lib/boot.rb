require 'nokogiri'

require './models/deadlock'
Dir.glob("./models/*.rb").each { |f| require f }
