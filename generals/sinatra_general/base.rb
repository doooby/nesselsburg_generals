require 'sinatra/base'
require 'json'
require 'sinatra/json'

class SinatraGeneral < Sinatra::Application; end
require_relative 'helpers'
require_relative 'battle'

class SinatraGeneral < Sinatra::Application

  def self.train_for(realm, battle_klass)
    raise "Cannot train for this battle - #{battle_klass.to_s}" unless battle_klass.ancestors.include? Battle
    realms[realm.to_s] = battle_klass
  end

  def self.realms
    @realms ||= {}
  end

  helpers Helpers
  after { set_cors_headers }
  error { |e| json general_fail: {message: e.message, backtrace: e.backtrace} }
  set :show_exceptions, false
  set :run, false
  set :nesselsburg_origin, 'http://www.nesselsburg.cz'

  options('/*') { 200 } # CORS requirement

  get('/') { json settings.identity }

  post '/:realm' do |realm|
    data = json_payload
    respond_from get_realm(realm).new(data['game_id']), 'start', data
  end

  post '/:realm/:game_id/:event' do |realm, game_id, event|
    respond_from get_realm(realm).instace(game_id), event, json_payload
  end

  get '/:realm/:game_id' do |realm, game_id|
    respond_from get_realm(realm).instace(game_id), 'move', params
  end

end

