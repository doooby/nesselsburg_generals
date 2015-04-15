
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'game/game'

set :port, 3001

def enable_cors
  headers 'Access-Control-Allow-Origin' => 'http://localhost:3000',
          'Access-Control-Allow-Methods' => 'GET',
          'Access-Control-Max-Age' => 900,
          'Access-Control-Allow-headers' => 'Content-Type'
end

options '/' do
  enable_cors
end

get '/' do
  enable_cors
  headers['Content-Type'] = 'application/json'
  begin
    json KerkelGame.turn(params).to_hash
  rescue  => e
    json err: {msg: e.message, backtrace: e.backtrace}
  end
end
