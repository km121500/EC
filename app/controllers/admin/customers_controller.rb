class Admin::CustomersController < ApplicationController
    before_action :authenticate_admin!
  
  def index
    @customers = Customer.all.page(params[:page])
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to admin_customer_path(@customer.id)
      flash[:notice] = "変更を保存しました"
    else
      render "edit"
    end
  end
  
  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_read, :first_name_read, :postal_code, :address, :telephone_number, :is_user_status)
  end
  
end
