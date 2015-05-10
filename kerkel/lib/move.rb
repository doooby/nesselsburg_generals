
class KerkelGame::Move < Struct.new(:from, :to)
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