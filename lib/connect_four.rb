require_relative '../lib/board'
require_relative '../lib/player'

class ConnectFour
  attr_reader :player_one, :player_two
  attr_accessor :board

  def initialize
    @board = Board.new
    @player_one = Player.new("\u26aa")
    @player_two = Player.new("\u26ab")
  end

  def prompt(min = 0, max = 7)
    print "Please enter a number between #{min} and #{max}: "
  end

  def number?(input)
    input.to_i.to_s == input
  end

  def verify_number(number, min, max)
    return number if number.between?(min, max)
  end

  def obtain_number(player, min, max)
    loop do
      prompt(min, max)
      input = player.enter_input
      return input.to_i if number?(input) && verify_number(input.to_i, min, max)
    end
  end

  def enter_column(player)
    obtain_number(player, 0, 7)
  end

  def verify_column(column_index)
    column = board.obtain_column(column_index)
    column_index unless board.column_full?(column)
  end

  def obtain_column_index(player)
    loop do
      column_index = enter_column(player)
      index = verify_column(column_index)
      return index unless index.nil?
    end
  end
end
