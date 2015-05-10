require_relative '../generals/sinatra_general/base'

require 'puma'

require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/move'

# pro vývojové prostředí
SinatraGeneral.set :port, 3001
SinatraGeneral.set :nesselsburg_origin, 'http://localhost:3000'

SinatraGeneral.set :identity, {}
SinatraGeneral.train_for 'kerkel', KerkelGame
SinatraGeneral.run!