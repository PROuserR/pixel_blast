# frozen_string_literal: true

# Draws a pixel-perfect grid inside a block
module Graphics
  module_function

  # x, y: top-left in pixels
  # w, h: total size in pixels
  # cell_size: size of each cell in pixels
  # color: Gosu::Color for the lines
  # z: draw order
  def draw_pixel_grid(x_coordinate, y_coordinate, width, height)
    cell_size = 25
    color = Gosu::Color::WHITE
    z = 0

    # Vertical lines
    col = 0
    while col <= width
      Gosu.draw_rect(x_coordinate + col, y_coordinate, 1, height, color, z)
      col += cell_size
    end

    # Horizontal lines
    row = 0
    while row <= height
      Gosu.draw_rect(x_coordinate, y_coordinate + row, width, 1, color, z)
      row += cell_size
    end
  end

  def draw_thick_line(x1, y1, x2, y2, thickness, color, z = 0)
    dx = x2 - x1
    dy = y2 - y1
    length = Math.sqrt(dx**2 + dy**2)

    # Normalize direction
    nx = dx / length
    ny = dy / length

    # Perpendicular vector
    px = -ny * thickness / 2
    py = nx * thickness / 2

    # Four corners of the rectangle
    Gosu.draw_quad(
      x1 + px, y1 + py, color,
      x1 - px, y1 - py, color,
      x2 - px, y2 - py, color,
      x2 + px, y2 + py, color,
      z
    )
  end

  def draw_rect(x_coordinate, y_coordinate, width, height, color)
    Gosu.draw_quad(
      x_coordinate,         y_coordinate,          color,  # Top-left
      x_coordinate + width, y_coordinate,          color,  # Top-right
      x_coordinate,         y_coordinate + height, color,  # Bottom-left
      x_coordinate + width, y_coordinate + height, color,  # Bottom-right
      1
    )
  end

  # Draw a rectangle (or square) border with configurable thickness.
  # Alignment:
  #   :inside  -> border lies fully inside the (x,y,w,h) box
  #   :center  -> border is centered on the box edges
  #   :outside -> border lies fully outside the box
  def draw_rect_border(x, y, w, h, thickness, color, z = 1, align: :inside)
    return if thickness <= 0 || w <= 0 || h <= 0

    case align
    when :inside
      t = [thickness, w, h].min.to_f
      # Top
      Gosu.draw_quad(x, y, color,
                     x + w, y, color,
                     x + w, y + t, color,
                     x, y + t, color, z)
      # Bottom
      Gosu.draw_quad(x, y + h - t, color,
                     x + w, y + h - t, color,
                     x + w, y + h, color,
                     x, y + h, color, z)
      # Left
      Gosu.draw_quad(x, y, color,
                     x + t, y, color,
                     x + t, y + h, color,
                     x, y + h, color, z)
      # Right
      Gosu.draw_quad(x + w - t, y, color,
                     x + w, y, color,
                     x + w, y + h, color,
                     x + w - t, y + h, color, z)

    when :center
      t = thickness.to_f
      half = t / 2.0
      # Top
      Gosu.draw_quad(x - half, y - half, color,
                     x + w + half, y - half, color,
                     x + w + half, y + half, color,
                     x - half, y + half, color, z)
      # Bottom
      Gosu.draw_quad(x - half, y + h - half, color,
                     x + w + half, y + h - half, color,
                     x + w + half, y + h + half, color,
                     x - half, y + h + half, color, z)
      # Left
      Gosu.draw_quad(x - half, y - half, color,
                     x + half, y - half, color,
                     x + half, y + h + half, color,
                     x - half, y + h + half, color, z)
      # Right
      Gosu.draw_quad(x + w - half, y - half, color,
                     x + w + half, y - half, color,
                     x + w + half, y + h + half, color,
                     x + w - half, y + h + half, color, z)

    when :outside
      t = thickness.to_f
      # Top
      Gosu.draw_quad(x, y - t, color,
                     x + w, y - t, color,
                     x + w, y, color,
                     x, y, color, z)
      # Bottom
      Gosu.draw_quad(x, y + h, color,
                     x + w, y + h, color,
                     x + w, y + h + t, color,
                     x, y + h + t, color, z)
      # Left
      Gosu.draw_quad(x - t, y - 0, color,
                     x, y - 0, color,
                     x, y + h, color,
                     x - t, y + h, color, z)
      # Right
      Gosu.draw_quad(x + w, y - 0, color,
                     x + w + t, y - 0, color,
                     x + w + t, y + h, color,
                     x + w, y + h, color, z)
    else
      raise ArgumentError, 'align must be :inside, :center, or :outside'
    end
  end

  def draw_block(x_coordinate, y_coordinate, width, height, color, solving_block = false)
    screen_margin = 200
    if solving_block
      draw_rect(x_coordinate + 5, y_coordinate + 5, width - 10, height - 10, color)
      draw_rect_border(x_coordinate, y_coordinate, 400 / 16, 400 / 16, 2, color)
    else
      draw_rect(x_coordinate + 5, y_coordinate + screen_margin + 5, width - 10, height - 10, color)
      draw_rect_border(x_coordinate, y_coordinate + screen_margin, 400 / 16, 400 / 16, 2, color)
    end
  end

  # Draws a portion of an image between dest coords (x1, y1) and (x2, y2)
  # Uses the upper half of the source image by default
  def draw_image_region(image, src_x1, src_y1, src_width, src_height, dest_x1, dest_y1, dest_width, dest_height)
    tint_color = Gosu::Color::WHITE
    alpha = 255
    z = 0
    mode = :default
    # Tint with alpha applied
    tint_color = Gosu::Color.rgba(tint_color.red, tint_color.green, tint_color.blue, alpha)

    # Crop the source portion
    sub_img = image.subimage(src_x1, src_y1, src_width, src_height)

    # Draw the cropped portion scaled to fit the destination rectangle
    sub_img.draw_as_quad(
      dest_x1, dest_y1, tint_color, # TL
      dest_x1 + dest_width,     dest_y1, tint_color, # TR
      dest_x1 + dest_width,     dest_y1 + dest_height, tint_color, # BR
      dest_x1, dest_y1 + dest_height, tint_color, # BL
      z, mode
    )
  end
end
