# frozen_string_literal: true

# Class to allow the playing of a gif
class GifPlayer
  attr_reader :width, :height, :frame_count

  def initialize(path_pattern, options = {})
    files = Dir[path_pattern].sort
    @frames = []
    @delays = [] # ms

    files.each do |file|
      @frames << Gosu::Image.new(file)

      # Parse delay from filename: frame_XX_delay-0.05s
      @delays << if file =~ /_delay-(\d+\.\d+)s/i
                   (::Regexp.last_match(1).to_f * 1000).to_i
                 else
                   100 # default fallback
                 end
    end

    @frame_count = @frames.size
    @tint_color  = options[:tint_color] || Gosu::Color::WHITE
    @scale_x     = options[:scale_x]    || 1.0
    @scale_y     = options[:scale_y]    || 1.0

    if @frame_count.positive?
      base = @frames.first
      @width  = options[:width]  || (base.width  * @scale_x).to_i
      @height = options[:height] || (base.height * @scale_y).to_i
    else
      @width = @height = 0
    end

    @start_time = Gosu.milliseconds
  end

  def current_frame
    return nil if @frame_count.zero?

    elapsed = Gosu.milliseconds - @start_time
    idx = 0
    while elapsed >= @delays[idx]
      elapsed -= @delays[idx]
      idx = (idx + 1) % @frame_count
    end
    @frames[idx]
  end

  def draw(x_coordinate, y_coordinate, z_coordinate)
    frame = current_frame
    frame&.draw(x_coordinate, y_coordinate, z_coordinate, @scale_x, @scale_y, @tint_color)
  end
end
