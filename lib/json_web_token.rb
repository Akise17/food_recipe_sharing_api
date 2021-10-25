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


    def token(user)
      self.encode(user_phone: user.phone, user_id: user.id)
    end

    def verify_signature(token)
      pub64 = "qqOaiQGjGsxBMgI5rdAasaACRiJthOqadmefjY5mS/c="
      token.stringify_keys!
      signatureB64 = token["signature"]
      message = token["identifier"] + token["identifier_type"] + token["receiver"] + token["expire_at"]

      signb = Binascii.a2b_base64(signatureB64)
      msgb = message
      decoded_pub64 = Base64.decode64(pub64)
      verify_sig = RbNaCl::Signatures::Ed25519::VerifyKey.new(decoded_pub64)
      verify_sig.verify(signb,msgb)
    end

  end
end