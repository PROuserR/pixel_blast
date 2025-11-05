# frozen_string_literal: true

# Horizontal lines that flicker, shift, or distort parts of the screen
class GlitchScanlines
  attr_accessor :x, :y

  def initialize(x:, y:, width:, height:, line_height: 2,
                 glitch_chance: 0.02, glitch_offset: 4,
                 color: Gosu::Color.rgba(0, 255, 0, 40))
    @x = x
    @y = y
    @width = width
    @height = height
    @line_height = line_height
    @glitch_chance = glitch_chance
    @glitch_offset = glitch_offset
    @color = color
    @offsets = Array.new((height / line_height.to_f).ceil, 0)
  end

  def update
    @offsets.map! do
      rand < @glitch_chance ? rand(-@glitch_offset..@glitch_offset) : 0
    end
  end

  def draw
    @offsets.each_with_index do |off, i|
      y_pos = @y + i * @line_height
      Gosu.draw_rect(@x + off, y_pos, @width, @line_height, @color, 10)
    end
  end
end
