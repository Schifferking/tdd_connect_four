class Player
  def initialize(token)
    @token = token
  end

  def obtain_token
    @token
  end

  def enter_input
    gets.chomp
  end
end
