module V1
  class UsersController < ApplicationController
    before_action :authenticate, except: :create

    def create
      @user = User.create(user_params) if user_params
      render json: @user, status: :created
    end

    def update
      user = User.find(params[:id])
      if user.update(user_params)
        render json: user, status: 202
      else
        render json: { Error: "Update not successfull" }, status: 400
      end
    end

    private

    def user_params
      params.permit(:name, :email, :password)
    end
  end
end
