class Player
  def initialize(token)
    @token = token
  end

  def get_token
    @token
  end

  def enter_input
    gets.chomp.to_i
  end
end
