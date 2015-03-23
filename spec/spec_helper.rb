require './lib/boot'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  # config.profile_examples = 3
  # config.warnings         = true
  config.order            = :random
end
