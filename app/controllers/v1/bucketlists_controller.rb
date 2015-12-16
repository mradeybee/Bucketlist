module V1
  class BucketlistsController < ApplicationController
    before_action :authenticate

    def index
      limit =  bucketlist_params[:limit]
      page = bucketlist_params[:page]
      q = bucketlist_params[:q]
      user = @current_user.id
      if params[:q].present?
        @bucketlist = Bucketlist.paginate("search", user, q, page, limit)
        render json: @bucketlist, status: 200
      else
        @bucketlist = Bucketlist.paginate("index", user, q, page, limit)
        render json: @bucketlist, status: 200
      end
    end

    def show
      bucketlist = Bucketlist.find_list(params[:id], @current_user.id)
      if bucketlist.nil?
        render json: not_found
      else
        render json: bucketlist
      end
    end

    def create
      data = bucketlist_params.merge!(user_id: @current_user.id)
      @bucketlist = Bucketlist.new(data)
      if @bucketlist.save
        render json: @bucketlist, status: :created
      else
        render json:  @bucketlist.errors, status: 400
      end
    end

    def update
      @bucketlist = Bucketlist.find(params[:id])
      if @bucketlist.update(bucketlist_params)
        render json: @bucketlist, status: 202
      else
        render json: @bucketlist.errors, status: 400
      end
    end

    def destroy
      @bucketlist = Bucketlist.find_by_id(params[:id])
      return render json: not_found if @bucketlist.nil?
      if @bucketlist.destroy
        render json: { Deleted: "Bucketlist with its items, has been deleted" }
      end
    end

    private

    def bucketlist_params
      params.permit(:id, :name, :publicity, :limit, :page, :q)
    end

    def not_found
      { not_found!: "Bucketlist with id #{params[:id]} does not exist" }
    end
  end
end
