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

    @left_pressed      = 0
    @right_pressed     = 0
    @up_pressed        = 0
    @down_pressed      = 0
    @backspace_pressed = 0

    @images = {}

    %w(box boxgoal empty floor goal pusher pushergoal wall).each do |image_name|
      @images[image_name.to_sym] = Gosu::Image.new("data/images/#{image_name}64.png", :tileable => true)
    end
  end

  def update
    if !@level.won?
      update_move_left
      update_move_right
      update_move_up
      update_move_down
    end

    update_move_backspace
  end

  def draw
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

    @font.draw(@path.compressed_string_path, 20, @height - 40, 0, 1, 1, 0xff_ffffff)
  end

  def update_move_left
    if @left_pressed == 1 || (@left_pressed > 15 && @left_pressed % 4 == 0)
      case @level.move('l')
        when Level::NORMAL_MOVE then @path.add_move('l')
        when Level::BOX_MOVE    then @path.add_push('l')
      end
    end

    @left_pressed += 1 if @left_pressed >= 1
  end

  def update_move_right
    if @right_pressed == 1 || (@right_pressed > 15 && @right_pressed % 4 == 0)
      case @level.move('r')
        when Level::NORMAL_MOVE then @path.add_move('r')
        when Level::BOX_MOVE    then @path.add_push('r')
      end
    end

    @right_pressed += 1 if @right_pressed >= 1
  end

  def update_move_up
    if @up_pressed == 1 || (@up_pressed > 15 && @up_pressed % 4 == 0)
      case @level.move('u')
        when Level::NORMAL_MOVE then @path.add_move('u')
        when Level::BOX_MOVE    then @path.add_push('u')
      end
    end

    @up_pressed += 1 if @up_pressed >= 1
  end

  def update_move_down
    if @down_pressed == 1 || (@down_pressed > 15 && @down_pressed % 4 == 0)
      case @level.move('d')
        when Level::NORMAL_MOVE then @path.add_move('d')
        when Level::BOX_MOVE    then @path.add_push('d')
      end
    end

    @down_pressed += 1 if @down_pressed >= 1
  end

  def update_move_backspace
    if @backspace_pressed == 1 || (@backspace_pressed > 15 && @backspace_pressed % 4 == 0)
      @path.delete_last_move
      @level = @original_level.clone
      @path.to_s.each_char { |c| @level.move(c) }
    end

    @backspace_pressed += 1 if @backspace_pressed >= 1
  end

  def button_down(id)
    case id
      when Gosu::KbLeft      then @left_pressed      = 1
      when Gosu::KbRight     then @right_pressed     = 1
      when Gosu::KbUp        then @up_pressed        = 1
      when Gosu::KbDown      then @down_pressed      = 1
      when Gosu::KbBackspace then @backspace_pressed = 1
      when Gosu::KbD         then @backspace_pressed = 1
      when Gosu::KbEscape    then close
    end
  end

  def button_up(id)
    case id
      when Gosu::KbLeft      then @left_pressed      = 0
      when Gosu::KbRight     then @right_pressed     = 0
      when Gosu::KbUp        then @up_pressed        = 0
      when Gosu::KbDown      then @down_pressed      = 0
      when Gosu::KbBackspace then @backspace_pressed = 0
      when Gosu::KbD         then @backspace_pressed = 0
    end
  end
end
