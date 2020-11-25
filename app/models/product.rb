class Product < ApplicationRecord
  belongs_to :user
  has_many :orderitems
  has_many :reviews
  has_and_belongs_to_many :categories

  validates :name, presence: true
  validates :stock, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :price, presence: true
  validates :description, presence: true
  validates :user_id, presence: true
  validates :photo_url, presence: true



  def create_stock_collection
    currently_instock = self.stock
    stock_collection = []
    currently_instock.times { |num| stock_collection << num + 1 }
    return stock_collection
  end

  def category_on_user_show
    return collection = self.categories.map { |cat| cat.name }
  end

  def product_reviews
    return self.reviews.order(id: :desc)
  end
end
