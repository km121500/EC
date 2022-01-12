class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!

  def index
    @addresses = current_customer.addresses.all
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if@address.save
      flash[:notice] = "配送先を登録しました。"
      redirect_to addresses_path
    else
      @addresses = Address.all
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    @address.customer_id = current_customer.id
    if@address.update(address_params)
      flash[:notice] = "変更を保存しました。"
      redirect_to addresses_path
    else
      flash.now[:alert]
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.customer_id = current_customer.id
    @address.destroy
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:name, :address, :postal_code)
  end

end
