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
    column.none? { |element| element == '' }
  end
end
