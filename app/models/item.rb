class Item < ApplicationRecord
  has_many :cart_items
  belongs_to :genre
  has_many :order_details

  attachment :image, destroy: false

  validates :name, presence: true
  validates :body, presence: true
  validates :price, presence: true
  validates :image, presence: true
end
