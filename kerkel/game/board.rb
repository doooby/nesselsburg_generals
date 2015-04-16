
class KerkelGame::Board

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

  def make_move(player, move)
    player = positions[move.from].shift
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

  def to_s
    ret = ''
    25.times do |i|
      ret += positions[i].to_s
      ret += ' | ' if i%5==4 && i!=24
    end
    ret
  end

end