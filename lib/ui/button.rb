class Button
  attr_reader :x, :y, :width, :height, :label

  def initialize(x:, y:, width:, height:, label:, font:, bg_color:, hover_color:, text_color:)
    @x = x
    @y = y
    @width = width
    @height = height
    @label = label
    @font = font
    @bg_color = bg_color
    @hover_color = hover_color
    @text_color = text_color
  end

  def draw(mouse_x, mouse_y)
    color = hovered?(mouse_x, mouse_y) ? @hover_color : @bg_color
    Gosu.draw_rect(@x, @y, @width, @height, color, 1)
    text_x = @x + (@width - @font.text_width(@label)) / 2
    text_y = @y + (@height - @font.height) / 2
    @font.draw_text(@label, text_x, text_y, 1, 1, 1, @text_color)
  end

  def clicked?(mouse_x, mouse_y)
    hovered?(mouse_x, mouse_y)
  end

  def hovered?(mouse_x, mouse_y)
    mouse_x.between?(@x, @x + @width) && mouse_y.between?(@y, @y + @height)
  end
end
