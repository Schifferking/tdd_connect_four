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
end
