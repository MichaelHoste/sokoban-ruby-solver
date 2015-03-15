require './lib/boot'

pack  = Pack.new('data/Original.slc')
level = pack.levels[1]

level.print

positions = CornerDeadlock.new(level).deadlock_positions

Zone.new(level, Zone::BOXES_ZONE).print
Zone.new(level, Zone::GOALS_ZONE).print
Zone.new(level, Zone::PUSHER_ZONE).print
Zone.new(level, Zone::CUSTOM_ZONE, { :positions => positions }).print
