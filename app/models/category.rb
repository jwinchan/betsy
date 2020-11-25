class Category < ApplicationRecord
  has_and_belongs_to_many :products 
  has_many :users, through: :products
  
  validates :name, presence: true, uniqueness: true

  def self.alphabetical
    self.all.order(:name)
  end

  def find_products(merchant = nil, products = nil)
    where_clause = {
        categories_products: {category_id: self.id}
    }

    if merchant
      where_clause[:user_id] = merchant.id
    end

    if products.nil?
      products = Product.where(retired: false)
    end

    products.joins(:categories_products).where(where_clause)
  end

  # ~Some Rails Magic~
  def self.restrict_by_products(products)
    joins(:categories_products).where(categories_products: {product_id: products.pluck(:id)}).distinct
  end
end
  


