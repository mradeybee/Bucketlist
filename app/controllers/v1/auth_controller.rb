module V1
  class AuthController < ApplicationController
    before_action :authenticate, only: :logout
    def login
      user = User.find_by(email: auth_params[:email])
      if user.nil?
        render json: { Error: "Invalid Email" }, status: 401
      elsif user.authenticate(auth_params[:password])
        user.active = true
        user.save
        token = Authenticate.create_token(id: user.id, email: user.email)
        render json: { token_key: token }, status: 200
      else
        render json: { Error: "Invalid Password" }, status: 401
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
