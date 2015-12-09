module V1
  class BucketlistsController < ApplicationController
    before_action :authenticate

    def index
      if params[:q].present?
        @bucketlist = Bucketlist.search(@current_user.id, params[:q])
        render json: @bucketlist, status: 200
      else
        @bucketlist = paginate(params[:limit], params[:page])
        render json: @bucketlist, status: 200
      end
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
      @bucketlist = Bucketlist.create(data) if bucketlist_params
      render json: @bucketlist, status: 200
    end

    def update
      @bucketlist = Bucketlist.find(params[:id])
      if @bucketlist.update(bucketlist_params)
        render json: @bucketlist, status: 202
      else
        render json: @bucketlist, status: :ok, location: @bucketlist
      end
    end

    def destroy
      @bucketlist = Bucketlist.find(params[:id])
      if @bucketlist.destroy
        render json: { Deleted: "Bucketlist with its items, has been deleted" }
      end
    end

    private

    def bucketlist_params
      params.permit(:id, :name, :publicity, :limit, :page, :q)
    end

    def paginate(limit, page)
      # binding.pry
      lists = limit.to_i * page.to_i
      set = lists - limit.to_i
      Bucketlist.blists(@current_user.id).limit(limit).offset(set)
    end
  end
end
