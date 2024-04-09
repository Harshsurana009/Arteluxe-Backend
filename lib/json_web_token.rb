# frozen_string_literal: true

# lib/json_web_token
class JsonWebToken
  class << self
    def initialize(user)
      @user = user
    end

    def encode_token(payload, exp)
      secret_key_base = Rails.application.secrets.secret_key_base.to_s
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key_base)
    end

    def decode_token(auth_header)
      secret_key_base = Rails.application.secrets.secret_key_base.to_s
      return unless auth_header

      JWT.decode(auth_header, secret_key_base, true, algorithm: 'HS256')[0]
    end

    def token_expiry
      7.days.freeze
    end
  end
end
