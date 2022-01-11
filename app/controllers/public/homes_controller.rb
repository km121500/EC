class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @items = Item.order(created_at: :desc).limit(12)
  end

  def about
  end
end
