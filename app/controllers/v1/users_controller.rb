module V1
  class UsersController < ApplicationController
    before_action :authenticate

    def index
      @user = User.all
      render json: @user
    end

    def show
      @user = User.find(params[:id])
      render json: @user
    end

    def new
      @user = User.new(user_params) if user_params
      render json: @user
    end

    def edit
    end

    def create
      @user = User.create(user_params) if user_params
      render json: @user, status: :created
    end

    def update
      user =  User.find(params[:id])
      if user.update(user_params)
        render json: user, status: 202
      else
        format.json { render :show, status: :ok, location: @booking }
      end
    end


    private

    def user_params
      params.permit(:name, :email, :password)
    end
  end
end
