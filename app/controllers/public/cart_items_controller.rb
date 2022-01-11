class Public::CartItemsController < ApplicationController
    before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items.all
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    
    if current_customer.cart_item.find_by(item_id: params[:cart_item][:item_id]).present?
      cart_item = current_customer.cart_item.find_by(item_id: params[:cart_item][:item_id])
      cart_item.quantity += params[:cart_item][:quantity].to_i
      cart_item.save
      redirect_to cart_items_path, notice: "カートに商品が追加されました"
      
    elsif
      @cart_item.save
      redirect_to cart_items_path, notice: "カートに新たな商品が追加されました"

    else
      render 'public/items/show'
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
    cart_item.update(cart_item_params)
    redirect_to cart_items_path, notice: "商品の数量が変更されました"
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: "商品が削除されました"
  end

  def destroy_all
    @cart_items = current_customer.cart_items.all
    @cart_items.destroy_all
    redirect_to items_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :quantity)
  end
  
end
