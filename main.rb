require './lib/boot'

pack  = Pack.new('data/packs/Original.slc')
level = pack.levels[1]

puts level.play

text =  "  ####  \n"\
        "###  #  \n"\
        "#    #  \n"\
        "#   .###\n"\
        "### #@.#\n"\
        "  # $$ #\n"\
        "  #  $ #\n"\
        "  #. ###\n"\
        "  ####  "

level = Level.new(text)

# level.play

# positions = CornerDeadlock.new(level).deadlock_positions

# Zone.new(level, Zone::BOXES_ZONE).print
# Zone.new(level, Zone::GOALS_ZONE).print
# Zone.new(level, Zone::PUSHER_ZONE).print
# Zone.new(level, Zone::CUSTOM_ZONE, { :positions => positions }).print
