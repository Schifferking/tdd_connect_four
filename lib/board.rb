class Board
  def initialize
    @grid = nil
  end

  def create_board
    @grid = Array.new(6) { Array.new(7) { nil } }
  end
end
