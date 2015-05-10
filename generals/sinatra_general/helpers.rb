
module SinatraGeneral::Helpers

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

  def get_realm(realm)
    self.class.realms[realm] || raise("This general hasn't been trained for realm: #{realm}")
  end

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

  def respond_from(battle, event, data)
    json(battle.event(event, data) || {})
  end

end