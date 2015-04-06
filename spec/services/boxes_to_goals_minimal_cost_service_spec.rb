require 'spec_helper'

describe BoxesToGoalsMinimalCostService do

  i = Float::INFINITY

  before :all do
    @level     = Pack.new('spec/support/files/level.slc').levels[0]
    @node      = @level.to_node

    @service   = LevelDistancesService.new(@level).run
    @distances = @service.distances_for_zone
  end

  it '#run' do
    cost = BoxesToGoalsMinimalCostService.new(@node, @distances).run
    puts "---------"
    puts cost
    puts "---------"
  end

end
