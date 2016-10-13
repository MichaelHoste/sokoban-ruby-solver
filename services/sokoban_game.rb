require 'gosu'

class SokobanGame < Gosu::Window
  def initialize(level, width, height)
    super(width, height)
    self.caption = "Sokoban"

    @width  = width
    @height = height

    @original_level = level.clone
    @level          = level
    @cols           = level.cols
    @rows           = level.rows

    @path = Path.new
    @font = Gosu::Font.new(15)

    @box_size = [@width.to_f / (@cols + 3), @height.to_f / (@rows + 3)].min
    @x_offset = (@width.to_f  - @cols * @box_size) / 2
    @y_offset = (@height.to_f - @rows * @box_size) / 2

    @pressed = {
      :left      => 0,
      :right     => 0,
      :up        => 0,
      :down      => 0,
      :backspace => 0
    }

    @images = {}

    %w(box boxgoal empty floor goal pusher pushergoal wall).each do |image_name|
      @images[image_name.to_sym] = Gosu::Image.new("data/images/#{image_name}64.png", :tileable => true)
    end
  end

  def update
    if !@level.won?
      update_move(:left)
      update_move(:right)
      update_move(:up)
      update_move(:down)
    end

    update_move_backspace
  end

  def draw
    draw_background
    draw_level
    draw_path
    draw_moves
    draw_pushes
  end

  def draw_background
    draw_quad(
      0,      0,       0xff_f4f4f4,
      @width, 0,       0xff_f4f4f4,
      0,      @height, 0xff_f4f4f4,
      @width, @height, 0xff_f4f4f4
    )
  end

  def draw_level
    (0..@rows-1).each do |m|
      (0..@cols-1).each do |n|
        cell = @level.read_pos(m, n)

        image_name = case cell
          when ' ' then :empty
          when 's' then :floor
          when "#" then :wall
          when "$" then :box
          when "*" then :boxgoal
          when "@" then :pusher
          when "+" then :pushergoal
          when '.' then :goal
        end

        @images[image_name].draw(
          @x_offset + n*@box_size,
          @y_offset + m*@box_size,
          0,
          @box_size/64.0,
          @box_size/64.0
        )
      end
    end
  end

  def draw_path
    @font.draw(@path.compressed_string_path, 20, @height - 32, 0, 1, 1, 0xff_000000)
  end

  def draw_moves
    @font.draw("Moves:",          20, 12, 0, 1, 1, 0xff_000000)
    @font.draw(@path.moves_count, 80, 12, 0, 1, 1, 0xff_000000)
  end

  def draw_pushes
    @font.draw("Pushes:",          20, 28, 0, 1, 1, 0xff_000000)
    @font.draw(@path.pushes_count, 80, 28, 0, 1, 1, 0xff_000000)
  end

  def update_move(direction)
    d = direction.to_s[0]

    if @pressed[direction] == 1 || (@pressed[direction] > 15 && @pressed[direction] % 4 == 0)
      case @level.move(d)
        when Level::NORMAL_MOVE then @path.add_move(d)
        when Level::BOX_MOVE    then @path.add_push(d)
      end
    end

    @pressed[direction] += 1 if @pressed[direction] >= 1
  end

  def update_move_backspace
    if @pressed[:backspace] == 1 || (@pressed[:backspace] > 15 && @pressed[:backspace] % 4 == 0)
      @path.delete_last_move
      @level = @original_level.clone
      @path.to_s.each_char { |c| @level.move(c) }
    end

    @pressed[:backspace] += 1 if @pressed[:backspace] >= 1
  end

  def button_down(id)
    case id
      when Gosu::KbLeft      then @pressed[:left]      = 1
      when Gosu::KbRight     then @pressed[:right]     = 1
      when Gosu::KbUp        then @pressed[:up]        = 1
      when Gosu::KbDown      then @pressed[:down]      = 1
      when Gosu::KbBackspace then @pressed[:backspace] = 1
      when Gosu::KbD         then @pressed[:backspace] = 1
      when Gosu::KbEscape    then puts(@path.compressed_string_path); close
    end
  end

  def button_up(id)
    case id
      when Gosu::KbLeft      then @pressed[:left]      = 0
      when Gosu::KbRight     then @pressed[:right]     = 0
      when Gosu::KbUp        then @pressed[:up]        = 0
      when Gosu::KbDown      then @pressed[:down]      = 0
      when Gosu::KbBackspace then @pressed[:backspace] = 0
      when Gosu::KbD         then @pressed[:backspace] = 0
    end
  end
end
