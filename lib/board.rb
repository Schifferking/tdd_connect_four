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
end
