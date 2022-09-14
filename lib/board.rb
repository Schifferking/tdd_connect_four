class Board
  def initialize
    @grid = nil
  end

  def create_board
    @grid = Array.new(7) { Array.new(6) { nil } }
  end
end
