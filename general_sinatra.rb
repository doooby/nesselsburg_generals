require 'sinatra/base'
require 'json'
require 'sinatra/json'

class GeneralSinatra < Sinatra::Application

  set :show_exceptions, false
  set :run, false
  set :nesselsburg_origin, 'http://localhost:3000'

  def self.go_on_a_tour_with(piece)
    raise 'Sinatra cannot play that piece.' unless piece.kind_of? MusicPiece
    set :piece, piece
    run!
  end

  after { set_cors_headers }
  error { |e| json message: e.message, backtrace: e.backtrace }
  options('/*') { 200 } # CORS requirement

  ########## Helpers ###################################################################################################

  helpers do

    # def protected!
    #   return if authorized?
    #   headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    #   halt 401, "Not authorized\n"
    # end
    #
    # def authorized?
    #   @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    #   @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
    # end

    def set_cors_headers
      headers 'Access-Control-Allow-Origin' => settings.nesselsburg_origin,
              'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
              'Access-Control-Max-Age' => 900,
              'Access-Control-Allow-headers' => 'Content-Type',
              'Content-Type' => 'application/json'
    end

    def json_payload
      JSON.parse request.body.read
    end

    def piece
      settings.piece
    end

  end

  ########## Defined API ###############################################################################################

  get '/' do
    json piece.author
  end

  post '/' do
    data = json_payload
    raise "Sinatra cannot play this piece -#{data['game_name']}-" unless data['game_name']==piece.name
    piece.prepare_for_performance data['game_id'], data
    json({})
  end

  post %r{/([^/]+)(/\w+)?} do
    game_id, event = params['captures']
    event = event[1..-1] if event
    event_response = piece.audience_raction game_id, event, json_payload
    event_response ? json(event_response) : json({})
  end

  get '/:game_id' do |game_id|
    json piece.preform_a_gig(game_id, params)
  end

  ########## Miscs #####################################################################################################

  class MusicPiece
    attr_reader :author, :name, :performances
    def initialize(**opts)
      @author = opts[:author] || raise('Identity of the author not specified')
      @name = opts[:name] || raise('Name of the piece not specified')
      @performances = {}
    end
    def prepare_for_performance(id, data); raise 'Not be defined in a subclass.'; end
    def audience_raction(id, event, data); raise 'Not be defined in a subclass.'; end
    def preform_a_gig(id, data); raise 'Not be defined in a subclass.'; end
  end

end