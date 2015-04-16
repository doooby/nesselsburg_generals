
class KerkelGame

  attr_reader :board

  def initialize
    @board = Board.new
  end

  def calc_random_move(as_player)
    positions = board.positions_of_player as_player
    from = positions[rand positions.length]
    possible = Board::POSSIBLE_STEPS[from]
    to = possible[rand possible.length]
    Move.new from, to
  end

  def calc_dummy_move(as_player)
    possible = board.positions_of_player(as_player).map{|p| Board::POSSIBLE_STEPS[p].map{|pp| Move.new(p, pp)}}.flatten
    # raise possible.map(&:inspect).to_s
    possible.each{|m| m.count_value board}
    possible.max_by &:value
  end

  class Move < Struct.new(:from, :to)
    attr_reader :value

    def self.from_last(hash)
      move = new
      move.from = hash[:from].to_i
      move.to = hash[:to].to_i
      move
    end

    def ==(other)
      from==other.from && to==other.to
    end

    def count_value(board)
      @value = to # :-D takže všichni dojdou na 24 a potom tah 24->23, což je vítězné pole :p
    end

  end

end