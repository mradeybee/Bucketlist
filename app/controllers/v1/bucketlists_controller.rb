module V1
  class BucketlistsController < ApplicationController
    before_action :authenticate

    def index
      if params[:q].present?
        search = Bucketlist.search(@current_user.id, params[:q])
        @bucketlist = paginate(search, "search", params[:limit], params[:page])
        render json: @bucketlist, status: 200
      else
        lists = Bucketlist.lists(@current_user.id)
        @bucketlist = paginate(lists, "index", params[:limit], params[:page])
        render json: @bucketlist, status: 200
      end
    end

    def show
      bucketlist = Bucketlist.find_list(params[:id], @current_user.id)
      not_found = "Bucketlist with id #{params[:id]} does not exist"
      if bucketlist.nil?
        render json: { not_found!: not_found }
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
      @bucketlist = Bucketlist.find(params[:id])
      if @bucketlist.destroy
        render json: { Deleted: "Bucketlist with its items, has been deleted" }
      end
    end

    private

    def bucketlist_params
      params.permit(:id, :name, :publicity, :limit, :page, :q)
    end

    def paginate(methods, type, page = nil, limit = nil)
      lists = limit.to_i * page.to_i
      set = lists - limit.to_i
      result = methods.limit(limit).offset(set)
      check_resut(result, type)
    end

    def check_resut(result, type)
      if type == "search" && result.empty?
        return { Oops!: "Bucketlist named '#{params[:q]}' not found" }
      elsif type == "index" && result.empty?
        return { Oops!: "Bucketlist is empty" }
      else
        result
      end
    end
  end
end
