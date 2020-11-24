class Product < ApplicationRecord
  belongs_to :user
  has_many :orderitems
  has_many :reviews
  has_and_belongs_to_many :categories

  def create_stock_collection
    currently_instock = self.stock
    stock_collection = []
    currently_instock.times { |num| stock_collection << num + 1 }
    return stock_collection
  end

  def category_on_user_show
    return collection = self.categories.map { |cat| cat.name }
  end
end
