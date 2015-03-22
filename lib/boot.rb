require 'nokogiri'

Dir.glob("./services/**/*.rb").each { |f| require f }
Dir.glob("./models/**/*.rb").each   { |f| require f }
