require './lib/boot'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  #config.filter_run :focus

  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.order = 'random'
end
