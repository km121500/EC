class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @items = Item.all.page(params[:page])
  end
  
  def show
    @item = Item.find(params[:id])
    @new_item = Item.new
  end
  
  def new
    @item = Item.new
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item)
      flash[:notice] = "商品を追加しました"
    else
      render "new"
    end
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      redirect_to admin_item_path(@item)
      flash[:notice] = "変更を保存しました"
    else
      render "edit"
    end
  end
  
  private
  def item_params
    params.require(:item).permit(:name, :body, :price, :image, :is_status, :genre_id)
  end
  
end
