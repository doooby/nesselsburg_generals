
class KerkelGame

  attr_reader :game_id, :board

  def initialize(params)
    @game_id = params[:game_id]
    @board = Board.new
  end

  def self.turn(params)
    game = games[params[:game_id]]
    unless game
      game = new params
      games[params[:game_id]] = game
    end

    on_turn = params[:on_turn].to_i          # 1 | 2  tzn. hráč začínající nebo druhý
    last_move =  Move.from_last params[:last_move] # předchozí tah (může být nil, pokud jde o první tah)

    game.note_move (on_turn==1 ? 2 : 1), last_move
    game.calc_turn on_turn
  end

  def self.games
    @games ||= {}
  end

  def note_move(player, move)
    board.make_move move
  end

  def calc_turn(as_player)
    positions = board.positions_of_player as_player
    from = positions[rand positions.length]
    possible = Board::POSSIBLE_STEPS[from]
    to = possible[rand possible.length]
    Move.new from, to
  end

  class Board

    POSSIBLE_STEPS = [
        [1, 4, 5, 20, 6],
        [0, 6, 3],
        [],
        [4, 8, 1],
        [0, 3, 9, 24, 8],

        [6, 15, 10, 0],
        [7, 5, 11, 1, 12, 10, 0],
        [8, 6, 12],
        [9, 7, 13, 3, 14, 12, 4],
        [19, 8, 14, 4],

        [11, 15, 5, 16, 6],
        [12, 10, 16, 6],
        [13, 11, 17, 7, 18, 16, 6, 8],
        [14, 12, 18, 8],
        [13, 19, 9, 18, 8],

        [16, 5, 20, 10],
        [17, 15, 21, 11, 20, 10, 12],
        [18, 16, 12],
        [19, 17, 23, 13, 24, 12, 14],
        [9, 18, 24, 14],

        [21, 24, 0, 15, 16],
        [20, 23, 16],
        [],
        [24, 21, 18],
        [20, 23, 4, 19, 18]
    ]

    attr_reader :positions

    def initialize
      @positions = [
          [2], [2], [ ], [2], [2],
          [ ], [ ], [ ], [ ], [ ],
          [0], [0], [0], [0], [0],
          [ ], [ ], [ ], [ ], [ ],
          [1], [1], [ ], [1], [1]
      ]
    end

    def make_move(move)
      player = positions[move.from].first
      position_to = positions[move.to]
      if position_to.empty? || position_to.first==player
        position_to << player
      else
        new_arr = [player]
        new_arr << player if position_to.first==0
        positions[move.to] = new_arr
      end
    end

    def positions_of_player(player)
      positions.each_index.select{|i| positions[i].first == player}
    end

  end

  class Move < Struct.new(:from, :to)

    def self.from_last(hash)
      move = new
      move.from = hash[:from].to_i
      move.to = hash[:to].to_i
      move
    end

    def to_hash
      {from: from, to: to}
    end

  end

end