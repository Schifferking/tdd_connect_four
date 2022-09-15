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
end
