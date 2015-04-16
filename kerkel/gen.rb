require_relative '../general_sinatra'
require 'puma'

require_relative 'game/game'
require_relative 'game/board'

class Kerkel < GeneralSinatra::MusicPiece

  # aka je vyžádáno zapojení do nové hry
  def prepare_for_performance(id, data)
    performances[id] = KerkelGame.new
  end

  # aka něco se stalo
  def audience_raction(id, event, data)
    case event
      when 'win'
        performances.delete id
      when 'lost'
        performances.delete id
      else
        raise 'Kerkel game event not defined'
    end
  end

  # aka seš na tahu
  def preform_a_gig(id, data)
    # 1 | 2  tzn. hráč začínající nebo druhý
    on_turn = data['on_turn'].to_i
    # předchozí tah (může být nil, pokud jde o první tah)
    last_move = KerkelGame::Move.from_last data['last_move']

    game = performances[id]
    game.board.make_move (on_turn==1 ? 2 : 1), last_move
    # move = game.calc_random_move on_turn
    move = game.calc_dummy_move on_turn
    game.board.make_move on_turn, move

    # {from: move.from, to: move.to, board: game.board.to_s}
    {from: move.from, to: move.to}

  rescue => e
    {fail: {message: e.message, backtrace: e.backtrace}}
  end

end

kerkel = Kerkel.new name: 'kerkel', author: {}
GeneralSinatra.set :port, 3001
GeneralSinatra.go_on_a_tour_with kerkel