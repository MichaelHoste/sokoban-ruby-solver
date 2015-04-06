require 'spec_helper'

describe BoxesToGoalsMinimalCostService do

  i = Float::INFINITY

  context "for the first level" do
    level     = Pack.new('spec/support/files/level.slc').levels[0]

    service   = LevelDistancesService.new(level).run
    distances = service.distances_for_zone
    node      = level.to_node

    it '#run' do
      cost = BoxesToGoalsMinimalCostService.new(node, distances).run
      puts "---------"
      puts cost
      puts "---------"
    end
  end

end
