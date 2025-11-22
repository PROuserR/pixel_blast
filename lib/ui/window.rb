# frozen_string_literal: true

require_relative './button'
require_relative  '../utils/helper'
require_relative  '../utils/random_generator'
require_relative  '../media/media_loader'
require_relative  '../graphics/draw'
require_relative  '../graphics/starfield'
require_relative  '../graphics/code_rain'

# Class GameWindow inherits from Gosu::Window to run the window && draw method
class PixelblastWindow < Gosu::Window
  attr_accessor :random_block_id

  def initialize(width, height)
    super(width, height, resizable: false)
    @win_width = width
    @win_height = height
    @last_time = Gosu.milliseconds / 1000.0
    @timer = Timer.new(60) {}
    @loader = MediaLoader.new
    @start_game = 0
    @alpha = 0
    @block_color = RandomGenerator.random_vivid_color
    @loader.intro.play(loop = true)
    @btn_play = Button.new(
      x: @win_width / 2 - 150, y: @win_height - 50, width: 300, height: 50,
      label: 'Click anywhere to start!',
      font: @loader.font_subtitle,
      bg_color: Gosu::Color::BLACK,
      hover_color: RandomGenerator.random_vivid_color,
      text_color: Gosu::Color::WHITE
    )
    @starfield = Starfield.new(num_stars: 256, width: @win_width, height: @win_height)
    # Create code streams across the screen
    @stream = CodeStream.new(x: 0, y: 200, width: @win_width, height: @win_height - 200)
  end

  def button_down(id)
    dice_roll = rand(2)

    if id == Gosu::MsRight && PixelblastHelper.blasts >= 1
      case dice_roll
      when 0
        random_row = rand(16)
        loop do
          break if PixelblastHelper.matrix_2d[random_row].include?(0)

          random_row = rand(16)
        end

        PixelblastHelper.matrix_2d[random_row].fill(-1)

      when 1
        random_col = rand(16)
        loop do
          break if PixelblastHelper.matrix_2d.transpose[random_col].include?(0)

          random_col = rand(16)
        end

        PixelblastHelper.matrix_2d.each do |row|
          row[random_col] = -1 if row.size > random_col
        end
      end
      @random_block_id = RandomGenerator.generate_unique_random(@random_block_id, 8)
    end
    PixelblastHelper.blasts -= 1 if id == Gosu::MsRight && PixelblastHelper.blasts >= 0

    if id == Gosu::MsLeft && @start_game.zero?
      @start_game = 1

      return
    end

    @start_game += 1 if id == Gosu::MsLeft && @start_game == 1
    puts 'You have no blasts!' if PixelblastHelper.blasts.negative?
  end

  def button_up(id)
    @timer.start if @start_game == 1
    if @start_game >= 2 && id == Gosu::MsLeft
      PixelblastHelper.new_matrix_2d_index[0] =
        (Integer(mouse_y) - 200) / ((@win_height - 200) / PixelblastHelper.matrix_2d.size)

      PixelblastHelper.new_matrix_2d_index[1] =
        Integer(mouse_x) / (@win_width / PixelblastHelper.matrix_2d[0].size)
      PixelblastHelper.solving_block_drawn = true
    end
    return unless @start_game == 1

    @loader.song.play(loop = true)
    @loader.intro.stop
  end

  def draw_logo
    @loader.font_title.draw_text('P', @win_width / 2 - 77 + 5, 20, 0, 2, 2, Gosu::Color.new(@alpha, 255, 0, 0))
    @loader.font_title.draw_text('i', @win_width / 2 - 77  + 50, 20, 0, 2, 2, Gosu::Color.new(@alpha, 255, 255, 0))
    @loader.font_title.draw_text('x', @win_width / 2 - 77  + 75, 20, 0, 2, 2, Gosu::Color.new(@alpha, 255, 0, 255))
    @loader.font_title.draw_text('e', @win_width / 2 - 77  + 120, 20, 0, 2, 2, Gosu::Color.new(@alpha, 0, 255, 0))
    @loader.font_title.draw_text('l', @win_width / 2 - 77  + 160, 20, 0, 2, 2, Gosu::Color.new(@alpha, 0, 0, 255))

    @loader.font_title.draw_text('blast', @win_width / 2 - 77, 77, 0, 2, 2, Gosu::Color::WHITE)
  end

  # Main game loop
  def draw
    if @start_game < 1
      draw_logo

      @btn_play.draw(mouse_x, mouse_y)
      @starfield.draw

    else
      @loader.font.draw_text('Statistics', @win_width / 2 - 75, 35 - 20, 0, 2, 2, 0xff_ffffff)
      @loader.font.draw_text("Score:#{PixelblastHelper.score}", @win_width / 2 - 190, 70 - 20, 0, 2, 2, 0xff_ffffff)
      @loader.font.draw_text('Top Score:10000', @win_width / 2 - 50, 70 - 20, 0, 2, 2, 0xff_ffffff)
      @loader.font.draw_text("Blasts:#{PixelblastHelper.blasts}", @win_width / 2 - 190, 105 - 20, 0, 2, 2, 0xff_ffffff)
      @loader.font.draw_text("Time left:#{@timer.remaining.round(0)}", @win_width / 2 - 50, 105 - 20, 0, 2, 2,
                             0xff_ffffff)
      @loader.font.draw_text("Level:#{PixelblastHelper.level}", @win_width / 2 - 190, 140 - 20, 0, 2, 2, 0xff_ffffff)
      @loader.font.draw_text('next:', @win_width / 2 - 50, 140 - 20, 0, 2, 2, 0xff_ffffff)

      @stream.draw

      Draw.pixel_grid(
        0, 200, # x, y position
        @win_width, @win_height - 200 # total width & height in pixels
      )

      Draw.matrix_2d(PixelblastHelper.matrix_2d, @block_color, @loader.background, @win_width, @win_height - 200)
      Draw.next_block_set(@random_block_id, @win_width, @block_color)

      unless PixelblastHelper.try_block(@random_block_id, @timer, @loader).nil?
        @random_block_id = RandomGenerator.generate_unique_random(random_block_id, 8)
      end

      PixelblastHelper.check_game_loop

      is_full = PixelblastHelper.matrix_2d.flatten.all? { |val| val == -1 }
      return unless is_full

      PixelblastHelper.matrix_2d = Array.new(16) { Array.new(16) { 0 } }
      @loader.background = Gosu::Image.new(RandomGenerator.random_file_from_subfolders)
      PixelblastHelper.blasts += 3
      PixelblastHelper.level += 1
      @block_color = RandomGenerator.random_vivid_color

      return unless PixelblastHelper.refersh_score_flag

      PixelblastHelper.refersh_score_flag = (false)
    end
  end

  # For timer implementation
  def update
    if @start_game.zero?
      @starfield.update
      @alpha += 1
      @alpha = 0 if @alpha > 256
    else
      @stream.update
    end

    now = Gosu.milliseconds / 1000.0
    dt = now - @last_time
    @last_time = now

    @timer.tick(dt)
    return unless @timer.remaining.round(2) <= 0

    puts "Time's out"
    puts "You scored #{PixelblastHelper.score}"
    @loader.game_over.play
    sleep(2)
    exit
  end
end
