module V1
  class BucketlistsController < ApplicationController
    before_action :authenticatew

    def index
      @bucketlist = Bucketlist.all_bucketlists(@current_user.id)
      render json: @bucketlist, status: 200
    end

    def show
      @bucketlist = Bucketlist.find(params[:id])
      render json: @bucketlist
    end

    def new
      @bucketlist = Bucketlist.new(bucketlist_params) if bucketlist_params
      render json: @bucketlist
    end

    def edit
    end

    def create
      data = bucketlist_params.merge!(user_id: @current_user.id)
      # binding.pry
      @bucketlist = Bucketlist.create(data) if bucketlist_params
      render json: @bucketlist
    end

    def update
      @bucketlist =  Bucketlist.find(params[:id])
      if @bucketlist.update(bucketlist_params)
        render json: @bucketlist, status: 202
      else
        format.json { render :show, status: :ok, location: @booking }
      end
    end

    private

    def bucketlist_params
      params.permit(:id, :name, :publicity)
    end


  end
end
