# frozen_string_literal: true

# Draws a pixel-perfect grid inside a block
module Draw
  module_function

  # x, y: top-left in pixels
  # w, h: total size in pixels
  # cell_size: size of each cell in pixels
  # color: Gosu::Color for the lines
  # z: draw order
  def pixel_grid(x_coordinate, y_coordinate, width, height)
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

  def thick_line(x1, y1, x2, y2, thickness, color, z = 0)
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

  def rect(x_coordinate, y_coordinate, width, height, color)
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
  def rect_border(x, y, w, h, thickness, color, z = 1, align: :inside)
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

  def block(x_coordinate, y_coordinate, width, height, color, solving_block = false)
    screen_margin = 200
    if solving_block
      rect(x_coordinate + 5, y_coordinate + 5, width - 10, height - 10, color)
      rect_border(x_coordinate, y_coordinate, 400 / 16, 400 / 16, 2, color)
    else
      rect(x_coordinate + 5, y_coordinate + screen_margin + 5, width - 10, height - 10, color)
      rect_border(x_coordinate, y_coordinate + screen_margin, 400 / 16, 400 / 16, 2, color)
    end
  end

  # Draws a portion of an image between dest coords (x1, y1) and (x2, y2)
  # Uses the upper half of the source image by default
  def image_region(image, src_x1, src_y1, src_width, src_height, dest_x1, dest_y1, dest_width, dest_height)
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

  def self.matrix_2d(matrix_2d, color, image)
    matrix_2d.size.times do |row|
      row_full_of_minus_ones = matrix_2d[row].count(-1) == matrix_2d[row].size
      if row_full_of_minus_ones
        Draw.image_region(image,
                          0, row * (image.height / matrix_2d[0].size), image.width, image.height / matrix_2d[0].size,
                          0, (400 / matrix_2d[0].size * row) + 200, 400, 400 / matrix_2d.size)
      end
      matrix_2d[row].size.times do |col|
        col_full_of_minus_ones = matrix_2d.all? { |row| row[col] == -1 }
        if col_full_of_minus_ones
          Draw.image_region(image,
                            col * (image.width / matrix_2d.size), 0, image.width / matrix_2d.size, image.height,
                            col * (400 / matrix_2d.size), 200, 400 / matrix_2d[0].size, 400)
        end

        pos_value = matrix_2d[row][col]
        next unless pos_value == 1

        Draw.block(col * (400 / matrix_2d[0].size), row * (400 / matrix_2d.size), 400 / matrix_2d[0].size,
                   400 / matrix_2d.size, color)
      end
    end
  end

  def self.next_block_set(block_id, x_coordinate = 275, y_coordinate = 120, matrix_2d, color)
    case block_id
    when 0
      # -> ##
      # -> ##
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 1
      # -> ##
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
    when 2
      # -> #
      # -> #
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 3
      # -> ##
      # -> #
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 4
      # -> ##
      # ->  #
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 5
      # -> #
      # -> ##
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 6
      # ->  #
      # -> ##
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Draw.block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                 400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 7
      # -> #
      Draw.block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                 400 / matrix_2d.size, color, true)
    end
  end
end
