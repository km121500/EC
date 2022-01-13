class Public::ItemsController < ApplicationController
  
  def index
    @items = Item.all.page(params[:page]).reverse_order.per(8)
    @item = Item.all
    @genres = Genre.all
    
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    @genres = Genre.all
  end
  
  def genre_search
    #ジャンル検索欄表示用にジャンルを全て取得
    @genres = Genre.all
    #受け取ったジャンルIDと同じジャンルをリストから探し取得
    @genre_searched = Genre.find(params[:id])
    #ジャンルが上のgenre_searchと一致する商品のみを（全て）取得
    @all_items_searched = Item.where(genre_id: @genre_searched.id)
    #直前で受け取った商品の中から,ページネーションのために8個まで取得
    @items = @all_items_searched.page(params[:page]).per(8).reverse_order
  end
end
