class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!
  
  def update
    @order_detail = OrderDetail.find(params[:id])
    @order_detail.update(order_detail_params)
    flash[:notice] = "変更を保存しました"
    redirect_to request.referer
  end 
  
  private
  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
