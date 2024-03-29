class Board
  attr_accessor :grid

  def initialize
    create_board
  end

  def create_board
    @grid = Array.new(6) { Array.new(7) { '' } }
  end

  def cell_empty?(row, column)
    @grid[row][column].empty?
  end

  def board_empty?
    @grid.flatten.all?('')
  end

  def obtain_column(index)
    (0..5).map { |row| @grid[row][index] }
  end

  def column_full?(column)
    column.none? { |element| element.empty? }
  end

  def put_token(row, column, token)
    @grid[row][column] = token
  end

  def search_empty_cell(column_index)
    5.downto(0) do |row|
      return [row, column_index] if cell_empty?(row, column_index)
    end
  end

  def obtain_row(row_index)
    @grid[row_index]
  end

  def horizontal_line?(row_index, token)
    row = obtain_row(row_index)
    0.upto(3) do |index|
      return true if row[index..index + 3].all?(token)
    end

    false
  end

  def vertical_line?(column_index, token)
    column = obtain_column(column_index)
    0.upto(2) do |index|
      return true if column[index..index + 3].all?(token)
    end

    false
  end

  def obtain_diagonals
    [[[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]],
     [[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]],
     [[0, 6], [1, 5], [2, 4], [3, 3], [4, 2], [5, 1]],
     [[0, 5], [1, 4], [2, 3], [3, 2], [4, 1], [5, 0]],
     [[0, 2], [1, 3], [2, 4], [3, 5], [4, 6]],
     [[1, 0], [2, 1], [3, 2], [4, 3], [5, 4]],
     [[0, 4], [1, 3], [2, 2], [3, 1], [4, 0]],
     [[1, 6], [2, 5], [3, 4], [4, 3], [5, 2]],
     [[0, 3], [1, 4], [2, 5], [3, 6]],
     [[2, 0], [3, 1], [4, 2], [5, 3]],
     [[0, 3], [1, 2], [2, 1], [3, 0]],
     [[2, 6], [3, 5], [4, 4], [5, 3]]]
  end

  def find_diagonals(coordinates)
    diagonals = obtain_diagonals
    found_diagonals = []
    diagonals.each do |diagonal|
      found_diagonals << diagonal if diagonal.include?(coordinates)
    end

    found_diagonals
  end

  def obtain_cell_value(row, column)
    @grid[row][column]
  end

  def obtain_cells_values(coordinates_list)
    values = []
    coordinates_list.each do |coordinates|
      row, column = coordinates
      values << obtain_cell_value(row, column)
    end

    values
  end

  def obtain_diagonals_values(diagonals)
    diagonal_values = []
    diagonals.each do |diagonal|
      diagonal_values << obtain_cells_values(diagonal)
    end

    diagonal_values
  end

  def diagonal_line?(diagonals, token)
    diagonals.each do |diagonal|
      iterations = diagonal.length
      if iterations == 4
        return true if diagonal.all?(token)

        next
      end

      iterations = 1 if iterations == 5
      iterations = 2 if iterations == 6

      0.upto(iterations) do |index|
        return true if diagonal[index..index + 3].all?(token)
      end
    end

    false
  end

  def board_full?
    false if board_empty?

    0.upto(6) do |index|
      column = obtain_column(index)
      return false unless column_full?(column)
    end

    true
  end
end
