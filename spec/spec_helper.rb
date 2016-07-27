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
    # result.eliminate_methods!([
    #   /Unknown#column_indices/,
    #   /Unknown#row_indices/,
    #   /Class#new/,
    #   /Array#index/,
    #   /Array#each/,
    #   /Array#include?/,
    #   /Array#collect/,
    #   /Array#count/,
    #   /Hash#==/,
    #   /Hash#each_pair/
    # ])
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT)

    # printer = RubyProf::GraphHtmlPrinter.new(result)
    # printer.print(File.new('reports/graph.html', 'w'))

    printer = RubyProf::CallStackPrinter.new(result)
    printer.print(File.new('reports/stack.html', 'w'))

    #system('open reports/graph.html')
    system('open reports/stack.html')
  end

  # config.profile_examples = 3
  # config.warnings         = true
  config.order            = :random
end
