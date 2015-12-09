module V1
  class ItemsController < ApplicationController
    def index
      @item = Item.all
      render json: @item
    end

    def show
      @item = Item.find(params[:id])
      render json: @item
    end

    def new
      @item = Item.new(item_params) if item_params
      render json: @item
    end

    def edit
    end

    def create
      @item = Item.create(item_params) if item_params
      render json: @item
    end

    def update
      @item = Item.find(params[:id])
      @item.update(item_params) if item_params
      render json: @item
    end

    def destroy
      @item = Item.find(params[:id])
      if @item.destroy
          render json: { Deleted: "Item has been deleted" }
      end
    end

    private

    def item_params
      params.permit(:bucketlist_id, :name, :details, :done)
    end
  end
end
