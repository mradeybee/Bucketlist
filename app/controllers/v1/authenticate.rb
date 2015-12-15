require "jwt"
module V1
  class Authenticate
    def self.secret
      BucketList::Application.config.secret_token
    end

    def self.create_token(user_info)
      user_info.merge!(exp: Time.zone.now.to_i + 5 * 3600)
      JWT.encode user_info, secret, "HS512"
    end

    def self.decode_token(token)
      decoded = JWT.decode token, secret, true, algorithm: "HS512"
      [true, decoded.first]
    rescue JWT::ExpiredSignature
      [false, { Error: "This session has expired, please login again" }]
    rescue
      [false, { Error: "An error occured, please login again" }]
    end
  end
end
