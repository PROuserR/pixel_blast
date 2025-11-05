# frozen_string_literal: true

# Vertical streams of symbols (katakana, numbers, glyphs) cascading down the screen.
# Vertical streams of symbols (katakana, numbers, glyphs) cascading down the screen.
class CodeStream
  attr_accessor :x, :y, :width, :height, :font_size, :speed, :chars, :lines

  def initialize(x:, y:, width:, height:, font_size: 12, speed: 0.5, chars: nil)
    @x = x
    @y = y
    @width = width
    @height = height
    @font_size = font_size
    @speed = speed
    @chars = chars || ('A'..'Z').to_a + ('0'..'9').to_a + %w[@ # $ % & * + -]
    @lines = Array.new(height / font_size) { random_line }
    @font = Gosu::Font.new(font_size)
    @offset = 0
  end

  def update
    @offset = (@offset + @speed) % @font_size
    return unless @offset == 0

    @lines.pop
    @lines.unshift(random_line)
  end

  def draw
    @lines.each_with_index do |line, i|
      line.each_with_index do |(char, color), j|
        draw_x = @x + j * @font_size
        draw_y = @y + i * @font_size + @offset
        next if draw_x > @x + @width || draw_y > @y + @height

        @font.draw_text(char, draw_x, draw_y, 0, 1, 1, color)
      end
    end
  end

  private

  def random_line
    Array.new(@width / @font_size) do
      [
        @chars.sample,
        Gosu::Color.new(
          92, # alpha
          rand(32..255),            # red
          rand(32..255),            # green
          rand(32..255)             # blue
        )
      ]
    end
  end
end
