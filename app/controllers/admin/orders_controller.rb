class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  
  def show
    @order = Order.find(params[:id])
    @order_details = OrderDetail.where(order_id: @order.id)
  end
  
  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    flash[:notice] = "変更を保存しました"
    redirect_to request.referer
  end
  
  private
  def order_params
    params.require(:order).permit(:order_status)
  end
end
