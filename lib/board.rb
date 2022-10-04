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
end
