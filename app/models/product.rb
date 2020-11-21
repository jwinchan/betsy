class Product < ApplicationRecord
  self.primary_key = :id
  belongs_to :user
  has_many :orderitems
  has_and_belongs_to_many :categories
end
