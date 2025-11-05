# frozen_string_literal: true

require 'gosu'
require_relative '../media/media_loader'
require_relative './matrix_2d'
require_relative './timer'

# PixelblastHelper provides helper methods for implementing game logic.
# like checking the game loop.
class PixelblastHelper
  @@matrix_2d = Array.new(16) { Array.new(16) { 0 } }
  @@solving_block_drawn = false
  @@new_matrix_2d_index = 0, 0
  @@score = 0
  @@refersh_score_flag = false
  @@blasts = 3
  @@level = 1
  @@loader = MediaLoader.new

  def self.level
    @@level
  end

  def self.level=(value)
    @@level = value
  end

  def self.blasts
    @@blasts
  end

  def self.blasts=(value)
    @@blasts = value
  end

  def self.score
    @@score
  end

  def self.score=(value)
    @@score = value
  end

  def self.refersh_score_flag
    @@refersh_score_flag
  end

  def self.refersh_score_flag=(val)
    @@refersh_score_flag = val
  end

  def self.matrix_2d
    @@matrix_2d
  end

  def self.matrix_2d=(val)
    @@matrix_2d = val
  end

  def self.check_game_loop
    is_row_full, row = Matrix2D.is_2d_matrix_row_full(@@matrix_2d)
    is_col_full, col = Matrix2D.is_2d_matrix_column_full(@@matrix_2d)
    dice_roll = rand(7)
    if is_row_full && is_col_full
      @@matrix_2d[row].fill(-1)
      @@matrix_2d.each { |row| row[col] = -1 }
      @@score += 500
      @@loader.blast.play(0.25)
      @@loader.super_frenzy_counter += 500
      @@loader.double_blast.play(1) if @@loader.super_frenzy_counter != 10
      @@refersh_score_flag = true
      sleep(1)
    elsif is_row_full
      @@matrix_2d[row].fill(-1)
      @@score += 100
      @@loader.blast.play(0.25)
      @@loader.super_frenzy_counter += 100
      if dice_roll.zero?
        @@loader.go_go_go.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 1
        @@loader.way_to_go.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 2
        @@loader.amazing.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 3
        @@loader.perfect.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 4
        @@loader.blast_em.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 5
        @@loader.great.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 6
        @@loader.awesome.play(1) if @@loader.super_frenzy_counter != 10
      end
      sleep(1)
      @@refersh_score_flag = true
    elsif is_col_full
      @@matrix_2d.each { |row| row[col] = -1 }
      @@score += 100
      @@loader.blast.play(0.25)
      @@loader.super_frenzy_counter += 100
      if dice_roll.zero?
        @@loader.go_go_go.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 1
        @@loader.way_to_go.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 2
        @@loader.amazing.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 3
        @@loader.perfect.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 4
        @@loader.blast_em.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 5
        @@loader.great.play(1) if @@loader.super_frenzy_counter != 10
      elsif dice_roll == 6
        @@loader.awesome.play(1) if @@loader.super_frenzy_counter != 10
      end
      sleep(1)
      @@refersh_score_flag = true
    end

    return unless @@loader.super_frenzy_counter == 1000

    dice_roll = rand(2)
    if dice_roll.zero?
      @@loader.super_frenzy.play
    else
      @@loader.block_blaster.play
    end
    @@loader.super_frenzy_counter = 0
  end

  def self.solving_block_drawn
    @@solving_block_drawn
  end

  def self.solving_block_drawn=(value)
    @@solving_block_drawn = value
  end

  def self.new_matrix_2d_index
    @@new_matrix_2d_index
  end

  def self.new_matrix_2d_index=(value)
    @@new_matrix_x_index = value
  end

  def self.after_successful_placment_procedure(timer, loader)
    @@solving_block_drawn = false
    timer.add_time(2)
    loader.click.play
  end

  def self.try_draw_block(random_block_id, timer, loader)
    return unless PixelblastHelper.solving_block_drawn

    PixelblastHelper.end_game_if_block_does_not_fit_in(random_block_id)
    # Detect what type of block to operate on
    case random_block_id
    when 0
      sub_2dmatrix = [[1, 1], [1, 1]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 1
      sub_2dmatrix = [[1, 1], [0, 0]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 2
      sub_2dmatrix = [[1, 0], [1, 0]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 3
      sub_2dmatrix = [[1, 1], [1, 0]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 4
      sub_2dmatrix = [[1, 1], [0, 1]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 5
      sub_2dmatrix = [[1, 0], [1, 1]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 6
      sub_2dmatrix = [[0, 1], [1, 1]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1] + 1,
                               PixelblastHelper.new_matrix_2d_index[0] + 1, 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    when 7
      sub_2dmatrix = [[1]]
      if PixelblastHelper.block_fits_in(sub_2dmatrix)
        Matrix2D.set_matrix_at(PixelblastHelper.matrix_2d, PixelblastHelper.new_matrix_2d_index[1],
                               PixelblastHelper.new_matrix_2d_index[0], 1)
        after_successful_placment_procedure(timer, loader)
        true
      end
    end
  end

  def self.draw_matrix_2d(color, image)
    matrix_2d.size.times do |row|
      row_full_of_minus_ones = @@matrix_2d[row].count(-1) == @@matrix_2d[row].size
      if row_full_of_minus_ones
        Graphics.draw_image_region(image,
                                   0, row * (image.height / @@matrix_2d[0].size), image.width, image.height / @@matrix_2d[0].size,
                                   0, (400 / @@matrix_2d[0].size * row) + 200, 400, 400 / @@matrix_2d.size)
      end
      matrix_2d[row].size.times do |col|
        col_full_of_minus_ones = @@matrix_2d.all? { |row| row[col] == -1 }
        if col_full_of_minus_ones
          Graphics.draw_image_region(image,
                                     col * (image.width / matrix_2d.size), 0, image.width / matrix_2d.size, image.height,
                                     col * (400 / matrix_2d.size), 200, 400 / matrix_2d[0].size, 400)
        end

        pos_value = @@matrix_2d[row][col]
        next unless pos_value == 1

        Graphics.draw_block(col * (400 / matrix_2d[0].size), row * (400 / matrix_2d.size), 400 / matrix_2d[0].size,
                            400 / matrix_2d.size, color)
      end
    end
  end

  def self.check_if_block_fits_in(block_id)
    case block_id
    when 0
      sub_2dmatrix = [[1, 1], [1, 1]]

      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 1
      sub_2dmatrix = [[1, 1], [0, 0]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 2
      sub_2dmatrix = [[1, 0], [1, 0]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 3
      sub_2dmatrix = [[1, 1], [1, 0]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 4
      sub_2dmatrix = [[1, 1], [0, 1]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 5
      sub_2dmatrix = [[1, 0], [1, 1]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 6
      sub_2dmatrix = [[0, 1], [1, 1]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 7
      sub_2dmatrix = [[0, 1, 0], [1, 1, 1]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    when 8
      sub_2dmatrix = [[1, 1, 1], [0, 1, 0]]
      Matrix2D.find_2dmatrix(sub_2dmatrix,
                             PixelblastHelper.matrix_2d)
    end
  end

  def self.end_game_if_block_does_not_fit_in(block_id)
    return unless check_if_block_fits_in(block_id) == false

    return if blasts >= 0

    puts 'No space left!'
    puts "You scored #{PixelblastHelper.score}"
    @@loader.game_over.play
    sleep(2)
    exit
  end

  def self.draw_next_block_set(block_id, x_coordinate = 275, y_coordinate = 120, color)
    case block_id
    when 0
      # -> ##
      # -> ##
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 1
      # -> ##
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
    when 2
      # -> #
      # -> #
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 3
      # -> ##
      # -> #
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 4
      # -> ##
      # ->  #
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size, 400 / matrix_2d.size, color, true)
    when 5
      # -> #
      # -> ##
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 6
      # ->  #
      # -> ##
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate, y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
      Graphics.draw_block(x_coordinate + (400 / matrix_2d[0].size), y_coordinate + (400 / matrix_2d.size),
                          400 / matrix_2d[0].size,  400 / matrix_2d.size, color, true)
    when 7
      # -> #
      Graphics.draw_block(x_coordinate, y_coordinate, 400 / matrix_2d[0].size,
                          400 / matrix_2d.size, color, true)
    end
  end

  def self.block_fits_in(sub_2dmatrix)
    block_fits_in_matrix = Matrix2D.find_2dmatrix_with_position(@@new_matrix_2d_index, sub_2dmatrix,
                                                                @@matrix_2d)
    col = @@new_matrix_2d_index[0]
    row = @@new_matrix_2d_index[1]
    matrix_row_full_of_minus_ones = @@matrix_2d[row].all? { |val| val == -1 }
    matrix_col_full_of_minus_ones = @@matrix_2d.all? { |row| row[col] == -1 }
    block_fits_in_matrix && !matrix_row_full_of_minus_ones && !matrix_col_full_of_minus_ones
  end
end
