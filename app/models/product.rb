class Product < ApplicationRecord
  belongs_to :user
  has_many :orderitems
  has_and_belongs_to_many :categories

  def create_stock_collection
    currently_instock = self.stock
    stock_collection = []

    if currently_instock > 10
      10.times { |num| stock_collection << num + 1 }
    else
      currently_instock.times { |num| stock_collection << num + 1}
    end

    return stock_collection
  end
end
