class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  validates :last_name,  presence:{ message: "は１文字以上入力してください。" }
  validates :first_name, presence:{ message: "は１文字以上入力してください。" }
  validates :last_name_read,  presence:{ message: "は１文字以上入力してください。" }, format: {with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}
  validates :first_name_read, presence:{ message: "は１文字以上入力してください。" }, format: {with: /\A[\p{katakana}\p{blank}ー－]+\z/, message: 'はカタカナで入力して下さい。'}
  validates :telephone_number, presence:{ message: "は１文字以上入力してください。" }, format: {with: /\A\d{10}$|^\d{11}\z/, message: '10桁か11桁の電話番号を入力してください。'}
  validates :postal_code,  presence:{ message: "は１文字以上入力してください。" }, format: {with: /\A\d{7}\z/, message: '7桁の郵便番号を入力してください。'}
  validates :address, presence:{ message: "は１文字以上入力してください。" }
  
  has_many :addresses, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  def active_for_authentication?
    super && (self.is_user_status == false)
  end
  
end
