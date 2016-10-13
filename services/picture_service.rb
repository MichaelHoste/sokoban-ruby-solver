require 'gosu'

class PictureService
  def initialize(level, filename)
    @level     = level
    @filename  = filename.end_with?('.png') ? filename : "#{filename}.png"

    @grid = @level.grid
    @cols = @level.cols
    @rows = @level.rows
  end

  def generate
    (0..@rows-1).each do |m|
      row = @grid[m*@cols..m*@cols+@cols-1]

      row = row.gsub(' ', 'data/imageS/empty64:png ')
               .gsub('s', 'data/imageS/floor64:png ')
               .gsub('.', 'data/imageS/goal64:png ')
               .gsub('#', 'data/imageS/wall64:png ')
               .gsub('$', 'data/imageS/box64:png ')
               .gsub('*', 'data/imageS/boxgoal64:png ')
               .gsub('@', 'data/imageS/pusher64:png ')
               .gsub('+', 'data/imageS/pushergoal64:png ')
               .tr(':S', '.s')

      `convert #{row} +append ./row_#{m}.png`
    end

    command = (0..@rows-1).collect { |m| "row_#{m}.png" }.join(' ')

    `convert #{command} -append #{@filename}`
    `rm -f ./row_*.png`
  end
end
