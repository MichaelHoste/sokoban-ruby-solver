require './lib/boot'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  config.before :example, :profiling => true do
    RubyProf.start
  end

  config.after :example, :profiling => true do
    result  = RubyProf.stop
    #result.eliminate_methods!([/Unknown#column_indices/])
    #result.eliminate_methods!([/Unknown#row_indices/])
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT)
  end

  # config.profile_examples = 3
  # config.warnings         = true
  config.order            = :random
end
