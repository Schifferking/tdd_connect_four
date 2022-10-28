require_relative '../lib/connect_four'
require_relative '../lib/board'
require_relative '../lib/player'

describe ConnectFour do
  describe '#number?' do
    context 'when given a letter' do
      subject(:connect_four_letter) { described_class.new }

      it 'returns false' do
        letter = 'f'
        result = connect_four_letter.number?(letter)
        expect(result).to eq(false)
      end
    end

    context 'when given a punctuation symbol' do
      subject(:connect_four_punctuation) { described_class.new }

      it 'returns false' do
        punctuation = '-'
        result = connect_four_punctuation.number?(punctuation)
        expect(result).to eq(false)
      end
    end

    context 'when given a string' do
      subject(:connect_four_string) { described_class.new }

      it 'returns false' do
        str = 'Hello, world!'
        result = connect_four_string.number?(str)
        expect(result).to eq(false)
      end
    end

    context 'when given a number' do
      subject(:connect_four_number) { described_class.new }

      it 'returns true' do
        num = '3'
        result = connect_four_number.number?(num)
        expect(result).to eq(true)
      end
    end
  end

  describe '#verify_number' do
    context 'when given a number in the range' do
      subject(:connect_four_valid_number) { described_class.new }

      it 'returns the number' do
        min = 0
        max = 7
        valid_number = 6
        result = connect_four_valid_number.verify_number(valid_number, min, max)
        expect(result).to eq(6)
      end
    end

    context 'when given an invalid number' do
      subject(:connect_four_invalid_number) { described_class.new }

      it 'returns nil' do
        min = 0
        max = 6
        invalid_number = 99
        result = connect_four_invalid_number.verify_number(invalid_number, min, max)
        expect(result).to be_nil
      end
    end
  end

  describe '#obtain_number' do
    subject(:connect_four_message) { described_class.new }
    let(:player_message) { instance_double(Player) }

    before do
      allow(connect_four_message).to receive(:prompt)
      allow(player_message).to receive(:enter_input)
      allow(connect_four_message).to receive(:number?).and_return(true)
      allow(connect_four_message).to receive(:verify_number).and_return(true)
    end

    it 'sends enter_input to player_message once' do
      min = 0
      max = 7
      expect(player_message).to receive(:enter_input).once
      connect_four_message.obtain_number(player_message, min, max)
    end

    context 'when player enters a valid number' do
      subject(:connect_four_number) { described_class.new }
      let(:player_number) { instance_double(Player) }

      before do
        valid_number = 4
        min = 0
        max = 6
        allow(connect_four_number).to receive(:prompt)
        allow(player_number).to receive(:enter_input).and_return(valid_number)
        allow(connect_four_number)
          .to receive(:number?)
          .with(valid_number)
          .and_return(true)

        allow(connect_four_number)
          .to receive(:verify_number)
          .with(valid_number, min, max)
          .and_return(true)
      end

      it 'completes the loop and returns the number' do
        min = 0
        max = 6
        result = connect_four_number.obtain_number(player_number, min, max)
        expect(result).to eq(4)
      end
    end
  end

  describe '#enter_column' do
    subject(:connect_four_column) { described_class.new }
    let(:player_column) { instance_double(Player) }

    before do
      allow(connect_four_column).to receive(:obtain_number).and_return(3)
    end

    it 'returns a number between 0 and 7' do
      row = connect_four_column.enter_column(player_column)
      expect(row).to eq(3)
    end
  end

  describe '#verify_column' do
    context 'when the column is not full' do
      subject(:connect_four_empty_column) { described_class.new }

      it 'returns the index' do
        column_one = 1
        column_index = connect_four_empty_column.verify_column(column_one)
        expect(column_index).to eq(column_one)
      end
    end
  end

  describe '#obtain_column_index' do
    context 'when given a valid column index' do
      subject(:connect_four_valid_index) { described_class.new }
      let(:player_valid_index) { instance_double(Player) }

      before do
        valid_index = 3
        allow(connect_four_valid_index).to receive(:enter_column).with(player_valid_index).and_return(valid_index)
      end

      it 'returns the index' do
        index = connect_four_valid_index.obtain_column_index(player_valid_index)
        expect(index).to eq(3)
      end
    end

    context 'when given an invalid index and then a valid one' do
      subject(:connect_four_two_index) { described_class.new }
      let(:player_two_index) { instance_double(Player) }

      before do
        invalid_index = 0
        valid_index = 4
        allow(connect_four_two_index)
          .to receive(:enter_column)
          .and_return(invalid_index, valid_index)

        allow(connect_four_two_index)
          .to receive(:verify_column)
          .and_return(nil, valid_index)
      end

      it 'completes the loop and returns the index' do
        index = connect_four_two_index.obtain_column_index(player_two_index)
        expect(index).to eq(4)
      end
    end
  end

  describe '#player_turn' do
    subject(:connect_four_player) { described_class.new }

    before do
      allow(connect_four_player)
        .to receive(:obtain_column_index)
        .and_return(0)
      allow(connect_four_player.board).to receive(:put_token)
    end

    it 'sends a message to search_empty_cell' do
      player = connect_four_player.player_one
      expect(connect_four_player.board).to receive(:search_empty_cell)
      connect_four_player.player_turn(player)
    end

    it 'sends a message to put_token' do
      player = connect_four_player.player_two
      expect(connect_four_player.board).to receive(:put_token)
      connect_four_player.player_turn(player)
    end

    context 'when given 3 on an empty board' do
      subject(:connect_four_coordinates_turn) { described_class.new }

      before do
        allow(connect_four_coordinates_turn)
          .to receive(:obtain_column_index)
          .and_return(3)
        allow(connect_four_coordinates_turn.board)
          .to receive(:search_empty_cell)
          .and_return([5, 3])
        allow(connect_four_coordinates_turn.board)
          .to receive(:put_token)
      end

      it 'returns [5, 3]' do
        player = connect_four_coordinates_turn.player_one
        coordinates = connect_four_coordinates_turn.player_turn(player)
        expect(coordinates).to eq([5, 3])
      end
    end
  end

  describe '#game_over?' do
    subject(:connect_four_over_game) { described_class.new }

    before do
      allow(connect_four_over_game.board).to receive(:obtain_diagonals_values)
      allow(connect_four_over_game.board).to receive(:horizontal_line?)
      allow(connect_four_over_game.board).to receive(:diagonal_line?)
    end

    it 'sends a message to find_diagonals' do
      player = connect_four_over_game.player_one
      coordinates = [0, 0]
      expect(connect_four_over_game.board).to receive(:find_diagonals)
      connect_four_over_game.game_over?(player, coordinates)
    end

    it 'sends a message to obtain_diagonals_values' do
      player = connect_four_over_game.player_two
      coordinates = [3, 2]
      expect(connect_four_over_game.board).to receive(:obtain_diagonals_values)
      connect_four_over_game.game_over?(player, coordinates)
    end

    it 'sends a message to horizontal_line?' do
      player = connect_four_over_game.player_one
      coordinates = [4, 5]
      expect(connect_four_over_game.board).to receive(:horizontal_line?)
      connect_four_over_game.game_over?(player, coordinates)
    end

    it 'sends a message to vertical_line?' do
      player = connect_four_over_game.player_two
      coordinates = [2, 6]
      expect(connect_four_over_game.board).to receive(:vertical_line?)
      connect_four_over_game.game_over?(player, coordinates)
    end

    it 'sends a message to diagonal_line?' do
      player = connect_four_over_game.player_one
      coordinates = [1, 3]
      expect(connect_four_over_game.board).to receive(:diagonal_line?)
      connect_four_over_game.game_over?(player, coordinates)
    end

    it 'sends a message to board_full?' do
      player = connect_four_over_game.player_two
      coordinates = [5, 0]
      expect(connect_four_over_game.board).to receive(:board_full?)
      connect_four_over_game.game_over?(player, coordinates)
    end

    context 'when the player fills a horizontal line' do
      subject(:connect_four_horizontal_over) { described_class.new }

      before do
        diagonals_coordinates = [[[[1, 6], [2, 5], [3, 4], [4, 3], [5, 2]]],
                                 [[[0, 1], [1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]]]
        diagonals = [[["\u26aa", "\u26ab", "\u26aa", "\u26ab", "\u26aa"]],
                     [["\u26ab", "\u26ab", "\u26aa", "\u26aa", "\u26aa", "\u26aa"]]]
        allow(connect_four_horizontal_over.board)
          .to receive(:find_diagonals)
          .and_return(diagonals_coordinates)
        allow(connect_four_horizontal_over.board)
          .to receive(:obtain_diagonals_values)
          .with(diagonals_coordinates)
          .and_return(diagonals)
        allow(connect_four_horizontal_over.board)
          .to receive(:horizontal_line?)
          .and_return(true)
        allow(connect_four_horizontal_over).to receive(:announce_winner)
      end

      it 'returns true' do
        coordinates = [3, 4]
        player = connect_four_horizontal_over.player_one
        result = connect_four_horizontal_over.game_over?(player, coordinates)
        expect(result).to be true
      end
    end

    context 'when the player fills a vertical line' do
      subject(:connect_four_vertical_over) { described_class.new }

      before do
        diagonals_coordinates = [[[[0, 2], [1, 3], [2, 4], [3, 5], [4, 6]]]]
        diagonals = [[["\u26aa", "\u26ab", "\u26aa", "\u26ab", "\u26aa"]]]
        allow(connect_four_vertical_over.board)
          .to receive(:find_diagonals)
          .and_return(diagonals_coordinates)

        allow(connect_four_vertical_over.board)
          .to receive(:obtain_diagonals_values)
          .with(diagonals_coordinates)
          .and_return(diagonals)

        allow(connect_four_vertical_over.board)
          .to receive(:horizontal_line?)
          .and_return(false)

        allow(connect_four_vertical_over.board)
          .to receive(:vertical_line?)
          .and_return(true)

        allow(connect_four_vertical_over).to receive(:announce_winner)
      end

      it 'returns true' do
        coordinates = [0, 2]
        player = connect_four_vertical_over.player_two
        result = connect_four_vertical_over.game_over?(player, coordinates)
        expect(result).to be true
      end
    end

    context 'when the player fills a diagonal line' do
      subject(:connect_four_diagonal_over) { described_class.new }

      before do
        diagonal_coordinates = [[[0, 0], [1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]]
        diagonals = [[["\u26ab", "\u26ab", "\u26ab", "\u26ab", "\u26ab", "\u26aa"]]]

        allow(connect_four_diagonal_over.board)
          .to receive(:find_diagonals)
          .and_return(diagonal_coordinates)

        allow(connect_four_diagonal_over.board)
          .to receive(:obtain_diagonals_values)
          .with(diagonal_coordinates)
          .and_return(diagonals)

        allow(connect_four_diagonal_over.board)
          .to receive(:horizontal_line?)
          .and_return(false)

        allow(connect_four_diagonal_over.board)
          .to receive(:vertical_line?)
          .and_return(false)

        allow(connect_four_diagonal_over.board)
          .to receive(:diagonal_line?)
          .and_return(true)

        allow(connect_four_diagonal_over).to receive(:announce_winner)
      end

      it 'returns true' do
        coordinates = [1, 1]
        player = connect_four_diagonal_over.player_two
        result = connect_four_diagonal_over.game_over?(player, coordinates)
        expect(result).to be true
      end
    end

    context 'when the board is full' do
      subject(:connect_four_board_over) { described_class.new }

      before do
        diagonal_coordinates = [[[0, 3], [1, 2], [2, 1], [3, 0]]]
        diagonals = [[["\u26ab", "\u26aa", "\u26ab", "\u26aa"]]]

        allow(connect_four_board_over.board)
          .to receive(:find_diagonals)
          .and_return(diagonal_coordinates)

        allow(connect_four_board_over.board)
          .to receive(:obtain_diagonals_values)
          .with(diagonal_coordinates)
          .and_return(diagonals)

        allow(connect_four_board_over.board)
          .to receive(:horizontal_line?)
          .and_return(false)

        allow(connect_four_board_over.board)
          .to receive(:vertical_line?)
          .and_return(false)

        allow(connect_four_board_over.board)
          .to receive(:diagonal_line?)
          .and_return(false)

        allow(connect_four_board_over.board)
          .to receive(:board_full?)
          .and_return(true)

        allow(connect_four_board_over)
          .to receive(:announce_draw)
          .and_return(true)
      end

      it 'returns true' do
        coordinates = [3, 0]
        player = connect_four_board_over.player_one
        result = connect_four_board_over.game_over?(player, coordinates)
        expect(result).to be true
      end
    end

    context 'when the player not made a line and the board is not full' do
      subject(:connect_four_not_over) { described_class.new }

      before do
        diagonal_coordinates = [[[0, 2], [1, 3], [2, 4], [3, 5], [4, 6]]]
        diagonals = [[["\u26ab", "\u26aa", "\u26ab", "\u26aa", "\u26ab"]]]

        allow(connect_four_not_over.board)
          .to receive(:find_diagonals)
          .and_return(diagonal_coordinates)

        allow(connect_four_not_over.board)
          .to receive(:obtain_diagonals_values)
          .with(diagonal_coordinates)
          .and_return(diagonals)

        allow(connect_four_not_over.board)
          .to receive(:horizontal_line?)
          .and_return(false)

        allow(connect_four_not_over.board)
          .to receive(:vertical_line?)
          .and_return(false)

        allow(connect_four_not_over.board)
          .to receive(:diagonal_line?)
          .and_return(false)

        allow(connect_four_not_over.board)
          .to receive(:board_full?)
          .and_return(false)
      end

      it 'returns false' do
        coordinates = [4, 6]
        player = connect_four_not_over.player_two
        result = connect_four_not_over.game_over?(player, coordinates)
        expect(result).to be false
      end
    end
  end

  describe '#game' do
    subject(:connect_four_game_test) { described_class.new }

    before do
      allow(connect_four_game_test).to receive(:turn_message)
      allow(connect_four_game_test).to receive(:player_turn)
      allow(connect_four_game_test).to receive(:draw_board)
      allow(connect_four_game_test).to receive(:game_over?).and_return(true)
    end

    it 'sends a message to obtain_token' do
      expect(connect_four_game_test.player_one).to receive(:obtain_token)
      connect_four_game_test.game
    end

    context 'when a player made a line' do
      subject(:connect_four_line_game) { described_class.new }

      before do
        allow(connect_four_game_test).to receive(:turn_message)
        allow(connect_four_game_test).to receive(:player_turn)
        allow(connect_four_game_test).to receive(:draw_board)
        allow(connect_four_game_test)
          .to receive(:game_over?)
          .and_return(false, false, false, false, false, false, false, true)
      end

      it 'breaks the loop' do
        expect(connect_four_game_test).to receive(:game_over?).exactly(8).times
        connect_four_game_test.game
      end
    end

    context 'when the board is full' do
      subject(:connect_four_board_game) { described_class.new }

      before do
        allow(connect_four_board_game).to receive(:turn_message)
        allow(connect_four_board_game).to receive(:player_turn)
        allow(connect_four_board_game).to receive(:draw_board)
        allow(connect_four_board_game)
          .to receive(:game_over?)
          .and_return(false, false, false, false, false, false,
                      false, false, false, false, false, false,
                      false, false, false, false, false, false,
                      false, false, false, false, false, false,
                      false, false, false, false, false, false,
                      false, false, false, false, false, false,
                      false, false, false, false, false, true)
      end

      it 'breaks the loop' do
        expect(connect_four_board_game)
          .to receive(:game_over?)
          .exactly(42).times
        connect_four_board_game.game
      end
    end
  end
end
