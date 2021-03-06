require 'spec_helper'

describe AStarSolver do

  it '#run (first level)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level)
    solver.run

    solver.solution_path.each_char { |move| level.move(move) }
    level.won?.should == true

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 97, 3, 341, 9, 737]
  end

  it '#run (first level without penalties)' do
    level  = Pack.new('spec/support/files/level.slc').levels[0]
    solver = AStarSolver.new(level, [], Float::INFINITY, false)
    solver.run

    solver.solution_path.each_char { |move| level.move(move) }
    level.won?.should == true

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 97, 0, 0, 29, 29]
  end

  it '#run (simple level)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = AStarSolver.new(level)
    solver.run

    solver.solution_path.each_char { |move| level.move(move) }
    level.won?.should == true

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 25, 23, 74, 69, 2536]
  end

  it '#run (simple level without penalties)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  # $$ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = AStarSolver.new(level, [], Float::INFINITY, false)
    solver.run

    solver.solution_path.each_char { |move| level.move(move) }
    level.won?.should == true

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 25, 0, 0, 111, 111]
  end

  it '#run (level with less boxes than goals)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#    #  \n"\
            "#   .###\n"\
            "### #@.#\n"\
            "  #  $ #\n"\
            "  #  $ #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = AStarSolver.new(level)
    solver.run

    solver.solution_path.each_char { |move| level.move(move) }
    level.won?.should == true

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [true, 5, 0, 0, 2, 2]
  end

  it '#run (impossible level)' do
    text =  "  ####  \n"\
            "###  #  \n"\
            "#  $ #  \n"\
            "#   .###\n"\
            "###$#@.#\n"\
            "  #    #\n"\
            "  #    #\n"\
            "  #. ###\n"\
            "  ####  "

    level  = Level.new(text)
    solver = AStarSolver.new(level)
    solver.run

    solver.solution_path.should == nil

    [ solver.found,
      solver.pushes,
      solver.penalties.size,
      solver.processed_penalties.size,
      solver.tries,
      solver.total_tries ].should == [false, Float::INFINITY, 0, 0, 1, 1]
  end

end
