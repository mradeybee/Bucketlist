module V1
  class UsersController < ApplicationController
    before_action :authenticate, except: :create

    def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, status: :created
      else
        render json: { Error: "User not created" }, status: 400
      end
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
