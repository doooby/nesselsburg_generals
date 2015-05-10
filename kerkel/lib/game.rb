class KerkelGame < SinatraGeneral::Battle

  def on_start(data)
    @board = Board.new
  end

  def on_move(data)
    # 1 | 2  tzn. hráč začínající nebo druhý
    on_turn = data['on_turn'].to_i
    # předchozí tah (může být nil, pokud jde o první tah)
    last_move = Move.from_last data['last_move']
    # zahrání tahu oponenta
    @board.make_move (on_turn==1 ? 2 : 1), last_move
    # vygenerování tahu
    move = calc_move on_turn
    @board.make_move on_turn, move

    # {from: move.from, to: move.to, board: @board.to_s}
    {from: move.from, to: move.to}
  end

  def calc_move(as_player)
    # calc_random_move as_player
    calc_dummy_move as_player
  end

  private

  def calc_random_move(as_player)
    positions = @board.positions_of_player as_player
    from = positions[rand positions.length]
    possible = Board::POSSIBLE_STEPS[from]
    to = possible[rand possible.length]
    Move.new from, to
  end

  def calc_dummy_move(as_player)
    possible = @board.positions_of_player(as_player).map{|p| Board::POSSIBLE_STEPS[p].map{|pp| Move.new(p, pp)}}.flatten
    possible.each{|m| m.count_value @board}
    possible.max_by &:value
  end

end

