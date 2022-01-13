class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy

  enum order_status: { waiting_for_deposit:0, payment_confirmation:1, production:2, ready_to_ship:3, shipped:4}

  enum payment_way: { クレジットカード: 0, 銀行振込: 1 }
  enum order_status: { 入金待ち: 0, 入金確認: 1, 製作中: 2, 発送準備中: 3, 発送済み: 4 }

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :orderer_name, presence: true
end
