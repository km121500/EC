class Public::OrdersController < ApplicationController
  before_action :cart_item, except: [:success, :show, :index]
  before_action :authenticate_customer!

  def new
    @order = Order.new
  end

  def check
    @order = Order.new(order_params)                   #オーダーID
    @cart_items = current_customer.cart_items.all       #自分のカートIDを取得
    @order.payment_way = params[:order][:payment_way]     #支払い方法を取得
    @order.postage = 800                                  #送料の定義づけ

    if params[:order][:address_option] == "0"             #address_optionが0の場合
      @order.postal_code = current_customer.postal_code     #自分の郵便番号をpostal_code取得
      @order.address = current_customer.address                 #自分の住所をaddress取得
      @order.orderer_name = current_customer.last_name + current_customer.first_name    #名前をorder_name取得

    elsif params[:order][:address_option] == "1"      #address_optionが1の場合
      @order.postal_code = Address.find(params[:order][:registered]).postal_code
      @order.address = Address.find(params[:order][:registered]).address
      @order.orderer_name = Address.find(params[:order][:registered]).name

    elsif params[:order][:address_option] == "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.orderer_name = params[:order][:orderer_name]
    end
    session[:order] = @order
    if @order.postal_code.blank? || @order.address.blank? || @order.orderer_name.blank?
      redirect_to new_order_path, alert: "お届け先情報を入力してください"
    else
      redirect_to orders_check_view_path
    end
  end

  def check_view
    @cart_items = current_customer.cart_items.all
    @order = Order.new(session[:order])
  end

  def create
    cart_items = current_customer.cart_items.all #自分のカートアイテムを全て取得
    @orders = current_customer.orders.new(order_params)  #paramsで取得
    if @orders.payment_way == "クレジットカード"
      return redirect_to new_card_path unless current_customer.card.present?
      item_ids = cart_items.map(&:item_id) #mapで取得した要素の配列を作る
      amount = 0
      item_ids.each do |item_id|
        price = Item.find(item_id).price
        quantity = cart_items.find_by(item_id: item_id).quantity
        amount += price * quantity
      end
      amount += 800 # TODO fix this
      # order = Item.find(params[:order_id]) # 購入する商品のレコードを取得
      Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # PAY.JPに秘密鍵を設定
      payjp_id = current_customer.card.payjp_id # 顧客idを取得
      Payjp::Charge.create( # PAY.JPに購入価格と顧客id、通貨の種類を渡す
        amount: amount,
        customer: payjp_id,
        currency: 'jpy' 
      )
      @orders.save
    else
      @orders.save
    end
      cart_items.each do |cart_item|
        order_detail = OrderDetail.new
        order_detail.order_id = @orders.id
        order_detail.item_id = cart_item.item_id
        order_detail.price = cart_item.item.with_tax_price
        order_detail.quantity = cart_item.quantity
        order_detail.save
        current_customer.cart_items.destroy_all
      end
      redirect_to orders_success_path, notice: "注文を受け付けました"
  end

  def success
  end

  def index
    @orders = current_customer.orders.all.page(params[:page]).reverse_order.per(8)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  private

  def cart_item
    if current_customer.cart_items.blank?
      redirect_to cart_items_path, alert: "カートに商品が入っていません"
    end
  end

  def order_params
    params.require(:order).permit(:orderer_name, :postal_code, :address, :postage, :claimed, :payment_way)
  end

  def address_params
    params.require(:order).permit(:name, :postal_code, :address)
  end

  def order_detail_params
    params.require(:order_detail).permit(:order_id, :item_id, :price, :quantity, :created_at)
  end
end
