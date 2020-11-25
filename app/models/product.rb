class Product < ApplicationRecord
  belongs_to :user
  has_many :orderitems
  has_many :reviews
  has_and_belongs_to_many :categories

  validates :name, presence: true, uniqueness: true
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :description, presence: true


  def create_stock_collection
    currently_instock = self.stock
    stock_collection = []
    currently_instock.times { |num| stock_collection << num + 1 }
    return  stock_collection == [] ? 0 : stock_collection
  end

  def category_on_user_show
    return collection = self.categories.map { |cat| cat.name }
  end

  def product_reviews
    return self.reviews.order(id: :desc)
  end

  def ave_rating
    total_rating = self.reviews.sum { |review| review.rating }
    return (total_rating / self.reviews.count.to_f).round(1)
  end
end
