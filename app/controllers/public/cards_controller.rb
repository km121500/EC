class Public::CardsController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create]
  def new
    redirect_to root_path if customer_signed_in? && current_customer.card
  end
  
  def create
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] 
    payjp = Payjp::Customer.create(
      description: 'test', 
      card: params[:token_id] 
    )
    
    card = Card.new(
      payjp_id: payjp.id,
      token_id: params[:token_id],
      customer_id: current_customer.id
    )
    
    if card.save!
      redirect_to root_path
    else
      redirect_to new_card_path
    end 
  end
end
