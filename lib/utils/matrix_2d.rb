# frozen_string_literal: true

# Matrix provides helper methods for performing common operations.
# These RandomGenerator are useful for grid-based algorithms or matrix manipulations.
module Matrix2D
  module_function

  def safe_transpose(matrix, fill: 0)
    max_cols = matrix.map(&:size).max
    (0...max_cols).map do |col|
      matrix.map { |row| row[col] || fill }
    end
  end

  def is_2d_matrix_row_full(matrix_2d)
    row_count = 0
    matrix_2d.size.times do |row|
      matrix_2d[row].size.times do |col|
        row_count += 1 if matrix_2d[row][col] == 1
        return true, row if row_count == matrix_2d[row].size - safe_transpose(matrix_2d).count { |col| col.all?(-1) }
      end
      row_count = 0
    end
    false
  end

  def is_2d_matrix_column_full(matrix_2d)
    col_count = 0
    matrix_2d.size.times do |row|
      matrix_2d[row].size.times do |col|
        col_count += 1 if matrix_2d[col][row] == 1
        return true, row if col_count == matrix_2d.size - matrix_2d.count { |row| row.all?(-1) }
      end
      col_count = 0
    end
    false
  end

  def clear_row(matrix_2d, row)
    matrix_2d.size.times do |i|
      set_matrix_at(matrix_2d, row, i, 0)
    end
  end

  def clear_column(matrix_2d, col)
    matrix_2d.size.times do |i|
      set_matrix_at(matrix_2d, i, col, 0)
    end
  end

  def set_matrix_at(matirx_2d, row, column, value)
    matirx_2d[row][column] = value
  end

  def find_2dmatrix_with_position(position, sub_matrix_2d, matrix_2d)
    test_conditon = true
    sub_matrix_2d_ones_count = sub_matrix_2d.flatten.count(1)
    matches = 0
    (0...sub_matrix_2d.size).each do |row|
      (0...sub_matrix_2d[row].size).each do |column|
        next unless column + position[1] != matrix_2d.size && row + position[0] != matrix_2d.size

        matrix_2d_elem = matrix_2d[row + position[0]][column + position[1]]
        first_condition = sub_matrix_2d[row][column] != matrix_2d_elem
        second_condition = sub_matrix_2d[row][column] == 1
        third_condition = matrix_2d_elem != -1

        test_conditon = first_condition && second_condition && third_condition
        matches += 1 if test_conditon
      end
    end

    matches == sub_matrix_2d_ones_count
  end

  def find_2dmatrix(sub_matrix_2d, matrix_2d)
    position = 0, 0
    while position[1] + sub_matrix_2d.first.size <= matrix_2d.first.size
      return true if find_2dmatrix_with_position(position, sub_matrix_2d, matrix_2d)

      position[0] += 1
      if position[0] + sub_matrix_2d.size > matrix_2d.size
        position[0] = 0
        position[1] += 1
      end
    end
    false
  end
end
