module V1
  class AuthController < ApplicationController
    before_action :authenticate, only: :logout
    def login
      user = User.find_by(email: auth_params[:email])
      password = "$2a$10$8iyAfEv9vT0vL6OHi71M8u92P8vW79Axk5Ox4lrXFGs.DHq37MVzG"
      user = User.new(password_digest: password) unless user
      if user.authenticate(auth_params[:password])
        user.active = true
        user.save
        token = Authenticate.create_token(id: user.id, email: user.email)
        render json: { token_key: token }, status: 200
      else
        render json: { Error: "Invalid Credentials" }, status: 401
      end
    end

    def logout
      user = User.find(@current_user.id)
      user.active = false
      user.save
      render json: { Status: "Logged out" }, status: 200
    end

    private

    def auth_params
      params.permit(:email, :password)
    end
  end
end
