class JsonWebToken
  class << self
    require 'json/jwt'
    SECRET_KEY = Rails.application.secrets.secret_key_base
    
    def encode(payload, exp = 1.year.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end
    
    def decode(token)
      decoded = JWT.decode(token, SECRET_KEY)[0]
      HashWithIndifferentAccess.new decoded
    rescue
      nil
    end
  end
end